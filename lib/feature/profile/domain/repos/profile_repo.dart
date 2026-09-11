import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:smart_pharmacy/core/error/failures.dart';
import 'package:smart_pharmacy/feature/profile/data/models/my_profile_response.dart';
import 'package:smart_pharmacy/feature/profile/data/models/update_my_profile_request.dart';

abstract class ProfileRepo {
  Future<Either<Failure, MyProfileResponse>> getMyProfile();

  Future<Either<Failure, MyProfileResponse>> updateMyProfile(
    UpdateMyProfileRequest request,
  );

  Future<Either<Failure, MyProfileResponse>> uploadAvatar(File image);

}
