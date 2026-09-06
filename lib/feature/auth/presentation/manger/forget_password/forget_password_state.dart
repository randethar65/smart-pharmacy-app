part of 'forget_password_cubit.dart';

@immutable
sealed class ForgetPasswordState {}

final class ForgetPasswordInitial extends ForgetPasswordState {}

// --- Step 1: request a reset code ---------------------------------------------

final class ForgetPasswordLoading extends ForgetPasswordState {}

final class ForgetPasswordSuccess extends ForgetPasswordState {
  /// Carried forward to the reset-code screen.
  final String email;
  final String message;
  ForgetPasswordSuccess({required this.email, required this.message});
}

final class ForgetPasswordFailure extends ForgetPasswordState {
  final String errorMessage;
  ForgetPasswordFailure(this.errorMessage);
}

// --- Step 2: submit code + new password -------------------------------------

final class ResetPasswordLoading extends ForgetPasswordState {}

final class ResetPasswordSuccess extends ForgetPasswordState {
  final String message;
  ResetPasswordSuccess(this.message);
}

final class ResetPasswordFailure extends ForgetPasswordState {
  final String errorMessage;
  ResetPasswordFailure(this.errorMessage);
}
