import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_pharmacy/core/service/dio_factory.dart';
import 'package:smart_pharmacy/feature/auth/data/models/login_request_body.dart';
import 'package:smart_pharmacy/feature/auth/data/models/login_response.dart';
import 'package:smart_pharmacy/feature/auth/domain/repos/auth_repos.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required this.authRepo}) : super(LoginInitial());

  final AuthRepo authRepo;

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());

    final result = await authRepo.signInWithEmailAndPassword(
      LoginRequestBody(email: email, password: password),
    );

    await result.fold(
      (failure) async => emit(LoginFailure(failure.message)),
      (response) async {
        // نتأكد إن السيرفر رجّع توكنات فعلاً
        if (response.accessToken == null || response.refreshToken == null) {
          emit(LoginFailure(response.message ?? 'Login failed'));
          return;
        }

        // 3) حفظ التوكن: نخزّنه ونحدّث هيدر Dio قبل ما نخبر الـ UI بالنجاح
        await DioFactory.setTokensAfterLogin(
          accessToken: response.accessToken!,
          refreshToken: response.refreshToken!,
        );

        emit(LoginSuccess(response));
      },
    );
  }
}
