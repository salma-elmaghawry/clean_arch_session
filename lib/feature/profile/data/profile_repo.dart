import 'package:clean_arch_session/core/networking/api_constants.dart';
import 'package:clean_arch_session/core/networking/api_error_handler.dart';
import 'package:clean_arch_session/core/networking/api_service.dart';
import 'package:clean_arch_session/feature/profile/data/profile_model.dart';
import 'package:dartz/dartz.dart';

class ProfileRepo {
  final ApiService _apiService;

  ProfileRepo(this._apiService);

  Future<Either<String, ProfileModel>> getProfile() async {
    try {
      final response = await _apiService.get(ApiConstants.profile);
      return Right(ProfileModel.fromJson(response.data['data']));
    } catch (error) {
      return Left(ApiErrorHandler.getMessage(error));
    }
  }
}
