import 'package:dartz/dartz.dart';
import 'package:smart_pharmacy/core/error/failures.dart';
import 'package:smart_pharmacy/feature/auth/data/models/forget_password_request_body.dart';
import 'package:smart_pharmacy/feature/auth/data/models/forget_password_response.dart';
import 'package:smart_pharmacy/feature/auth/data/models/login_request_body.dart';
import 'package:smart_pharmacy/feature/auth/data/models/login_response.dart';
import 'package:smart_pharmacy/feature/auth/data/models/register_request_body.dart';
import 'package:smart_pharmacy/feature/auth/data/models/register_response.dart';
import 'package:smart_pharmacy/feature/auth/data/models/reset_password_request_body.dart';
import 'package:smart_pharmacy/feature/auth/data/models/reset_password_response.dart';

abstract class AuthRepo {
  Future<Either<Failure, LoginResponse>> signInWithEmailAndPassword(
    LoginRequestBody loginRequestBody,
  );

  Future<Either<Failure, RegisterResponse>> register(
    RegisterRequest registerRequestBody,
  );

  Future<Either<Failure, ForgetPasswordResponse>> requestPasswordReset(
    ForgetPasswordRequest forgetPasswordRequestBody,
  );

  Future<Either<Failure, ResetPasswordResponse>> resetPassword(
    ResetPasswordRequest resetPasswordRequestBody,
  );

  /// Revokes the refresh token server-side. Best-effort: the caller clears
  /// the local session regardless of whether this succeeds.
  Future<Either<Failure, Unit>> logout();
}
