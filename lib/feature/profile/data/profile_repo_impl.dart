import 'package:clean_arch_session/core/networking/api_constants.dart';
import 'package:clean_arch_session/core/networking/api_service.dart';
import 'package:clean_arch_session/feature/profile/data/profile_model.dart';
import 'package:clean_arch_session/feature/profile/data/update_profile_request_body.dart';
import 'package:clean_arch_session/feature/profile/domain/entities/profile_entity.dart';
import 'package:clean_arch_session/feature/profile/domain/entities/update_profile_entity.dart';
import 'package:clean_arch_session/feature/profile/domain/repositories/profile_repo.dart';

class ProfileRepoImpl implements ProfileRepo {
  final ApiService _apiService;

  ProfileRepoImpl(this._apiService);

  @override
  Future<ProfileEntity> getProfile() async {
    final response = await _apiService.get(ApiConstants.profile);
    return ProfileModel.fromJson(response.data['data']);
  }

  @override
  Future<String> updateProfile(UpdateProfileEntity entity) async {
    final response = await _apiService.post(
      ApiConstants.updateProfile,
      data: await entity.toFormData(),
    );
    return response.data['message'];
  }
}
