import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:smart_pharmacy/core/error/failures.dart';
import 'package:smart_pharmacy/core/service/api_constant.dart';
import 'package:smart_pharmacy/core/service/api_services.dart';
import 'package:smart_pharmacy/feature/auth/data/models/forget_password_request_body.dart';
import 'package:smart_pharmacy/feature/auth/data/models/forget_password_response.dart';
import 'package:smart_pharmacy/feature/auth/data/models/login_request_body.dart';
import 'package:smart_pharmacy/feature/auth/data/models/login_response.dart';
import 'package:smart_pharmacy/feature/auth/data/models/register_request_body.dart';
import 'package:smart_pharmacy/feature/auth/data/models/register_response.dart';
import 'package:smart_pharmacy/feature/auth/data/models/reset_password_request_body.dart';
import 'package:smart_pharmacy/feature/auth/data/models/reset_password_response.dart';
import 'package:smart_pharmacy/feature/auth/domain/repos/auth_repos.dart';

class AuthRepoImpl implements AuthRepo {
  final ApiService _apiService;

  AuthRepoImpl(this._apiService);

  @override
  Future<Either<Failure, LoginResponse>> signInWithEmailAndPassword(
    LoginRequestBody body,
  ) async {
    try {
      final data = await _apiService.post(
        endPoint: ApiConstants.login,
        data: body.toJson(),
      );
      return Right(LoginResponse.fromJson(data));
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, RegisterResponse>> register(
    RegisterRequest registerRequestBody,
  ) async {
    try {
      final data = await _apiService.post(
        endPoint: ApiConstants.register,
        data: registerRequestBody.toJson(),
      );
      return Right(RegisterResponse.fromJson(data));
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ForgetPasswordResponse>> requestPasswordReset(
    ForgetPasswordRequest forgetPasswordRequestBody,
  ) async {
    try {
      final data = await _apiService.post(
        endPoint: ApiConstants.requestResetPassword,
        data: forgetPasswordRequestBody.toJson(),
      );
      return Right(ForgetPasswordResponse.fromJson(data));
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ResetPasswordResponse>> resetPassword(
    ResetPasswordRequest resetPasswordRequestBody,
  ) async {
    try {
      final data = await _apiService.post(
        endPoint: ApiConstants.resetPassword,
        data: resetPasswordRequestBody.toJson(),
      );
      return Right(ResetPasswordResponse.fromJson(data));
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      await _apiService.post(endPoint: ApiConstants.logout, data: const {});
      return const Right(unit);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
