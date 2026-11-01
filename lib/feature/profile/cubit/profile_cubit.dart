import 'package:clean_arch_session/core/networking/api_error_handler.dart';
import 'package:clean_arch_session/feature/profile/domain/entities/profile_entity.dart';
import 'package:clean_arch_session/feature/profile/domain/entities/update_profile_entity.dart';
import 'package:clean_arch_session/feature/profile/domain/usecases/get_profile_usecase.dart';
import 'package:clean_arch_session/feature/profile/domain/usecases/update_profile_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase _getProfileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;

  ProfileCubit(this._getProfileUseCase, this._updateProfileUseCase)
    : super(ProfileInitial());

  Future<void> getProfile() async {
    emit(ProfileLoading());
    try {
      final profile = await _getProfileUseCase();
      emit(ProfileSuccess(profile));
    } catch (error) {
      emit(ProfileFailure(ApiErrorHandler.getMessage(error)));
    }
  }

  Future<void> updateProfile(UpdateProfileEntity entity) async {
    emit(ProfileLoading());
    try {
      final message = await _updateProfileUseCase(entity);
      emit(ProfileUpdated(message));
    } catch (error) {
      emit(ProfileFailure(ApiErrorHandler.getMessage(error)));
    }
  }
}
