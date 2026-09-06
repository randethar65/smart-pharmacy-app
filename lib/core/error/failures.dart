import 'package:dio/dio.dart';

/// النوع الأساسي لأي خطأ يرجع من الطبقات (Repo / DataSource).
/// كل خطأ لازم يحمل [message] جاهزة للعرض للمستخدم.
abstract class Failure {
  final String message;
  const Failure(this.message);
}

/// خطأ جاي من السيرفر أو الشبكة (Dio).
class ServerFailure extends Failure {
  const ServerFailure(super.message);

  /// يحوّل [DioException] لرسالة مفهومة.
  factory ServerFailure.fromDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ServerFailure('انتهت مهلة الاتصال بالسيرفر.');
      case DioExceptionType.badCertificate:
        return const ServerFailure('شهادة أمان السيرفر غير صالحة.');
      case DioExceptionType.connectionError:
        return const ServerFailure('لا يوجد اتصال بالإنترنت.');
      case DioExceptionType.cancel:
        return const ServerFailure('تم إلغاء الطلب.');
      case DioExceptionType.badResponse:
        return ServerFailure._fromResponse(
          e.response?.statusCode,
          e.response?.data,
        );
      default:
        return const ServerFailure('حدث خطأ غير متوقع. حاول مرة أخرى.');
    }
  }

  /// يعالج ردود الأخطاء (4xx / 5xx).
  /// الباك اند يرجّع `{ "message": "...", "success": false }` فنحاول نقرأها.
  factory ServerFailure._fromResponse(int? statusCode, dynamic data) {
    final serverMessage =
        (data is Map && data['message'] is String) ? data['message'] as String : null;

    switch (statusCode) {
      case 400:
        return ServerFailure(serverMessage ?? 'طلب غير صحيح.');
      case 401:
        return ServerFailure(serverMessage ?? 'انتهت الجلسة، سجّل الدخول من جديد.');
      case 403:
        return ServerFailure(serverMessage ?? 'ليس لديك صلاحية لهذا الإجراء.');
      case 404:
        return ServerFailure(serverMessage ?? 'المورد غير موجود.');
      case 409:
        return ServerFailure(serverMessage ?? 'تعارض في البيانات.');
      case 422:
        return ServerFailure(serverMessage ?? 'بيانات غير صالحة.');
      case 429:
        return ServerFailure(serverMessage ?? 'محاولات كثيرة، انتظر قليلاً.');
      case 500:
      case 502:
      case 503:
        return ServerFailure(serverMessage ?? 'خطأ في السيرفر، حاول لاحقاً.');
      default:
        return ServerFailure(serverMessage ?? 'حدث خطأ ($statusCode).');
    }
  }
}

/// خطأ من الكاش / التخزين المحلي.
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}
