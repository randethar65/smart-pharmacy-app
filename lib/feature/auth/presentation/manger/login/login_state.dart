part of 'login_cubit.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

final class LoginSuccess extends LoginState {
  final LoginResponse response;
  LoginSuccess(this.response);
}

final class LoginFailure extends LoginState {
  final String errorMessage;
  LoginFailure(this.errorMessage);
}
