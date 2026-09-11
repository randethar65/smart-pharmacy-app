import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:smart_pharmacy/core/error/failures.dart';
import 'package:smart_pharmacy/core/service/api_constant.dart';
import 'package:smart_pharmacy/core/service/api_services.dart';
import 'package:smart_pharmacy/feature/profile/data/models/my_profile_response.dart';
import 'package:smart_pharmacy/feature/profile/data/models/update_my_profile_request.dart';
import 'package:smart_pharmacy/feature/profile/domain/repos/profile_repo.dart';

class ProfileRepoImple implements ProfileRepo {
  final ApiService apiService;

  ProfileRepoImple({required this.apiService});

  @override
  Future<Either<Failure, MyProfileResponse>> getMyProfile() async {
    try {
      final data = await apiService.get(endPoint: ApiConstants.getMyProfile);
      return Right(MyProfileResponse.fromJson(data as Map<String, dynamic>));
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MyProfileResponse>> updateMyProfile(
    UpdateMyProfileRequest request,
  ) async {
    try {
      final data = await apiService.patch(
        endPoint: ApiConstants.updateMyProfile,
        data: request.toJson(),
      );
      return Right(MyProfileResponse.fromJson(data as Map<String, dynamic>));
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MyProfileResponse>> uploadAvatar(File image) async {
    try {
      // POST /api/Profile/avatar — multipart, field name "file".
      final form = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          image.path,
          filename: image.path.split(Platform.pathSeparator).last,
        ),
      });
      final response = await apiService.dio.post(
        '${ApiConstants.apiBaseUrl}${ApiConstants.getMyProfile}/avatar',
        data: form,
      );
      return Right(
        MyProfileResponse.fromJson(response.data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
