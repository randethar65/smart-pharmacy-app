import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_pharmacy/feature/profile/data/models/my_profile_response.dart';
import 'package:smart_pharmacy/feature/profile/data/models/update_my_profile_request.dart';
import 'package:smart_pharmacy/feature/profile/domain/repos/profile_repo.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({required this.profileRepo}) : super(ProfileInitial());

  final ProfileRepo profileRepo;

  /// Last loaded profile — kept so an action failure can still show the screen.
  MyProfileResponse? _profile;

    Future<void> getMyProfile() async {
    emit(ProfileLoading());
    final result = await profileRepo.getMyProfile();
    result.fold(
      (failure) => emit(ProfileFailure(failure.message)),
      (profile) {
        _profile = profile;
        emit(ProfileSuccess(profile));
      },
    );
  }

  Future<void> updateProfile(UpdateMyProfileRequest request) async {
    final result = await profileRepo.updateMyProfile(request);
    result.fold(
      (failure) => emit(
        ProfileActionFailure(profile: _profile, message: failure.message),
      ),
      (profile) {
        _profile = profile;
        emit(ProfileSuccess(profile));
      },
    );
  }

  Future<void> uploadAvatar(File image) async {
    final result = await profileRepo.uploadAvatar(image);
    result.fold(
      (failure) => emit(
        ProfileActionFailure(profile: _profile, message: failure.message),
      ),
      (profile) {
        _profile = profile;
        emit(ProfileSuccess(profile));
      },
    );
  }
}
