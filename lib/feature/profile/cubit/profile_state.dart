part of 'profile_cubit.dart';

sealed class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  final ProfileModel profile;

  ProfileSuccess(this.profile);
}

class ProfileUpdated extends ProfileState {
  final String message;

  ProfileUpdated(this.message);
}

class ProfileFailure extends ProfileState {
  final String message;

  ProfileFailure(this.message);
}
