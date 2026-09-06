import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:smart_pharmacy/core/Helper/shared_pref_keys.dart';
import 'package:smart_pharmacy/core/service/api_constant.dart';
import 'package:smart_pharmacy/core/Helper/sheard_pref_healper.dart';
import 'package:smart_pharmacy/core/util/app_navigator.dart';
import 'package:smart_pharmacy/feature/auth/presentation/views/login_view.dart';

/// نقطة إنشاء واحدة لـ [Dio]. نبنيه مرة وحدة (singleton) ونعيد استخدامه،
/// عشان الـ interceptors والإعدادات ما تتكرر مع كل طلب.
class DioFactory {
  DioFactory._();

  static Dio? _dio;

  /// عنوان الـ API — مصدر واحد للحقيقة من [ApiConstants].
  static const String _baseUrl = ApiConstants.apiBaseUrl;

  static Future<Dio> getDio() async {
    if (_dio != null) return _dio!;

    const timeOut = Duration(seconds: 30);
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: timeOut,
        receiveTimeout: timeOut,
        headers: {'Accept': 'application/json',
        'Accept-Language': 'en',
        },
      ),
    );

    _allowSelfSignedCertInDebug(); // شهادة HTTPS محلية (تطوير فقط)
    await _attachStoredAccessToken(); // لو المستخدم مسجّل دخول من قبل
    _addLogger(); // طباعة تفاصيل الطلب/الرد في الـ console
    _addRefreshTokenInterceptor(); // تجديد التوكن تلقائيًا عند 401
    return _dio!;
  }

  // ---------------------------------------------------------------------------
  // 1) الهيدر الابتدائي
  // ---------------------------------------------------------------------------

  /// عند فتح التطبيق: لو في access token مخزّن من جلسة سابقة، نحطّه بالهيدر.
  static Future<void> _attachStoredAccessToken() async {
    final token =
        await SharedPrefHelper.getSecuredString(SharedPrefKeys.userToken);
    if (token.isNotEmpty) {
      _dio!.options.headers['Authorization'] = 'Bearer $token';
    }
  }

  /// نادِيها **بعد نجاح تسجيل الدخول** مباشرة.
  /// تخزّن التوكنين وتحدّث الهيدر عشان الطلبات الجاية تروح موثّقة.
  static Future<void> setTokensAfterLogin({
    required String accessToken,
    required String refreshToken,
  }) async {
    await SharedPrefHelper.setSecuredString(
        SharedPrefKeys.userToken, accessToken);
    await SharedPrefHelper.setSecuredString(
        SharedPrefKeys.refreshToken, refreshToken);
    _dio?.options.headers['Authorization'] = 'Bearer $accessToken';
  }

  // ---------------------------------------------------------------------------
  // 2) اللوقر
  // ---------------------------------------------------------------------------

  static void _addLogger() {
    // في الـ release ما نطبع شي (أداء + أمان).
    if (kReleaseMode) return;
    _dio!.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: true,
    ));
  }

  // ---------------------------------------------------------------------------
  // 3) تجديد التوكن (القلب)
  //
  // الفكرة: access token عمره 60 دقيقة. أول ما ينتهي، أي طلب يرجع 401.
  // هون نمسك الـ 401، نستخدم refresh token عشان ناخذ access جديد، ونعيد
  // الطلب الأصلي — والمستخدم ما يحس بشي.
  //
  // نستخدم QueuedInterceptorsWrapper (مو InterceptorsWrapper العادي):
  // لو 5 طلبات رجعوا 401 بنفس اللحظة، هو يصفّهم بالدور فيصير تجديد واحد
  // بس، والباقي ينتظروه. العادي كان بيعمل 5 نداءات refresh.
  // ---------------------------------------------------------------------------

  static void _addRefreshTokenInterceptor() {
    _dio!.interceptors.add(
      QueuedInterceptorsWrapper(
        onError: (DioException e, handler) async {
          final isUnauthorized = e.response?.statusCode == 401;
          final isRefreshCall =
              e.requestOptions.path.contains('refresh-token');

          // مش 401، أو الـ 401 جاي من نداء التجديد نفسه:
          // مرّري الخطأ زي ما هو (تجنّب اللوب اللانهائي).
          if (!isUnauthorized || isRefreshCall) {
            return handler.next(e);
          }

          final refreshToken = await SharedPrefHelper.getSecuredString(
              SharedPrefKeys.refreshToken);

          // ما في refresh token أصلاً → الجلسة انتهت.
          if (refreshToken.isEmpty) {
            await _forceLogout();
            return handler.next(e);
          }

          try {
            // Dio نظيف بدون أي interceptors → عشان ما يدخل بنفس الدورة.
            final refreshDio = Dio(BaseOptions(baseUrl: _baseUrl));
            _applySelfSignedCert(refreshDio);

            final res = await refreshDio.post(
              ApiConstants.refreshToken,
              data: {'refreshToken': refreshToken},
            );

            final newAccess = res.data['accessToken'] as String;
            final newRefresh = res.data['refreshToken'] as String;

            // خزّني الجداد.
            await SharedPrefHelper.setSecuredString(
                SharedPrefKeys.userToken, newAccess);
            await SharedPrefHelper.setSecuredString(
                SharedPrefKeys.refreshToken, newRefresh);
            _dio!.options.headers['Authorization'] = 'Bearer $newAccess';

            // أعيدي تنفيذ الطلب الأصلي بالتوكن الجديد.
            final retried = await _dio!.fetch(
              e.requestOptions
                ..headers['Authorization'] = 'Bearer $newAccess',
            );
            // resolve = اعتبري الطلب نجح ورجّعي هالرد للـ caller.
            return handler.resolve(retried);
          } catch (_) {
            // refresh token نفسه منتهي/غير صالح → خلاص، سجّلي خروج.
            await _forceLogout();
            return handler.next(e);
          }
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 4) تسجيل الخروج القسري
  // ---------------------------------------------------------------------------

  /// امسحي التوكنات المخزّنة وهيدر الـ Authorization — بدون تنقّل.
  /// تُستخدم من [_forceLogout] (انتهاء الجلسة تلقائيًا) ومن زر تسجيل
  /// الخروج اليدوي بالواجهة.
  static Future<void> clearLocalSession() async {
    await SharedPrefHelper.clearAllData();
    _dio?.options.headers.remove('Authorization');
  }

  static Future<void> _forceLogout() async {
    await clearLocalSession();

    // نوصل للـ Navigator بدون context عبر المفتاح العام في main.dart.
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      LoginView.routeName,
      (route) => false, // امسحي كل الشاشات السابقة
    );
  }

  // ---------------------------------------------------------------------------
  // 5) شهادة HTTPS محلية (تطوير فقط)
  //
  // السيرفر المحلي على HTTPS بشهادة self-signed، و Dio يرفضها افتراضيًا.
  // هون نقبلها **في وضع الـ debug فقط**. لا تفعّليها في الـ release أبدًا.
  // ---------------------------------------------------------------------------

  static void _allowSelfSignedCertInDebug() => _applySelfSignedCert(_dio!);

  static void _applySelfSignedCert(Dio dio) {
    if (kReleaseMode) return;
    final adapter = dio.httpClientAdapter;
    if (adapter is IOHttpClientAdapter) {
      adapter.createHttpClient = () => HttpClient()
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
}
