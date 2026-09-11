part of 'profile_cubit.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileSuccess extends ProfileState {
  final MyProfileResponse profile;
  ProfileSuccess(this.profile);
}

/// Initial load failed — there is nothing to show yet.
final class ProfileFailure extends ProfileState {
  final String message;
  ProfileFailure(this.message);
}

/// An update / avatar action failed — [profile] (if any) is still valid to show.
final class ProfileActionFailure extends ProfileState {
  final MyProfileResponse? profile;
  final String message;
  ProfileActionFailure({required this.profile, required this.message});
}
