import 'package:clean_arch_session/core/networking/api_error_handler.dart';
import 'package:clean_arch_session/feature/profile/data/profile_model.dart';
import 'package:clean_arch_session/feature/profile/data/profile_repo.dart';
import 'package:clean_arch_session/feature/profile/data/update_profile_request_body.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo _profileRepo;

  ProfileCubit(this._profileRepo) : super(ProfileInitial());

  Future<void> getProfile() async {
    emit(ProfileLoading());
    try {
      final profile = await _profileRepo.getProfile();
      emit(ProfileSuccess(profile));
    } catch (error) {
      emit(ProfileFailure(ApiErrorHandler.getMessage(error)));
    }
  }

  Future<void> updateProfile(UpdateProfileRequestBody body) async {
    emit(ProfileLoading());
    try {
      final message = await _profileRepo.updateProfile(body);
      emit(ProfileUpdated(message));
    } catch (error) {
      emit(ProfileFailure(ApiErrorHandler.getMessage(error)));
    }
  }
}
