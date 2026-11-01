import 'package:clean_arch_session/core/networking/api_constants.dart';
import 'package:clean_arch_session/core/networking/api_service.dart';
import 'package:clean_arch_session/feature/profile/data/profile_model.dart';
import 'package:clean_arch_session/feature/profile/data/update_profile_request_body.dart';

class ProfileRepo {
  final ApiService _apiService;

  ProfileRepo(this._apiService);

  Future<ProfileModel> getProfile() async {
    final response = await _apiService.get(ApiConstants.profile);
    return ProfileModel.fromJson(response.data['data']);
  }

  Future<String> updateProfile(UpdateProfileRequestBody body) async {
    final response = await _apiService.post(
      ApiConstants.updateProfile,
      data: await body.toFormData(),
    );
    return response.data['message'];
  }
}
