import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_pharmacy/feature/auth/data/models/forget_password_request_body.dart';
import 'package:smart_pharmacy/feature/auth/data/models/reset_password_request_body.dart';
import 'package:smart_pharmacy/feature/auth/domain/repos/auth_repos.dart';

part 'forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  ForgetPasswordCubit({required this.authRepo})
      : super(ForgetPasswordInitial());

  final AuthRepo authRepo;

  /// Step 1 — ask the server to email a 6-digit reset code.
  Future<void> requestCode({required String email}) async {
    emit(ForgetPasswordLoading());

    final result = await authRepo.requestPasswordReset(
      ForgetPasswordRequest(email: email),
    );

    result.fold(
      (failure) => emit(ForgetPasswordFailure(failure.message)),
      (response) {
        if (!response.success) {
          emit(ForgetPasswordFailure(response.message));
          return;
        }
        // The API returns the same generic message whether or not the account
        // exists, so success here just means "the request went through".
        emit(ForgetPasswordSuccess(email: email, message: response.message));
      },
    );
  }

  /// Step 2 — submit the code plus the new password.
  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    emit(ResetPasswordLoading());

    final result = await authRepo.resetPassword(
      ResetPasswordRequest(
        email: email,
        code: code,
        newPassword: newPassword,
      ),
    );

    result.fold(
      (failure) => emit(ResetPasswordFailure(failure.message)),
      (response) {
        if (!response.success) {
          emit(ResetPasswordFailure(response.message));
          return;
        }
        emit(ResetPasswordSuccess(response.message));
      },
    );
  }
}
