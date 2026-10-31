import 'package:clean_arch_session/core/cache/cache_const.dart';
import 'package:clean_arch_session/core/cache/cache_helper.dart';
import 'package:clean_arch_session/core/networking/api_constants.dart';
import 'package:clean_arch_session/core/networking/api_error_handler.dart';
import 'package:clean_arch_session/core/networking/api_service.dart';
import 'package:clean_arch_session/feature/auth/data/register_request_body.dart';
import 'package:dartz/dartz.dart';

class AuthRepo {
  final ApiService _apiService;

  AuthRepo(this._apiService);

  Future<Either<String, String>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConstants.login,
        data: {'email': email, 'password': password},
      );
      return Right(response.data['message']);
    } catch (error) {
      return Left(ApiErrorHandler.getMessage(error));
    }
  }

  Future<Either<String, String>> register(RegisterRequestBody body) async {
    try {
      final response = await _apiService.post(
        ApiConstants.register,
        data: await body.toFormData(),
      );
      return Right(response.data['message']);
    } catch (error) {
      return Left(ApiErrorHandler.getMessage(error));
    }
  }

  Future<Either<String, String>> verifyOtp({
    required String email,
    required String otpCode,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConstants.verifyOtp,
        data: {'email': email, 'otp_code': otpCode},
      );
      await CacheHelper.saveSecureData(
        key: CacheConstants.userToken,
        value: response.data['token'],
      );
      return Right(response.data['message']);
    } catch (error) {
      return Left(ApiErrorHandler.getMessage(error));
    }
  }

  Future<Either<String, String>> resendOtp({required String email}) async {
    try {
      final response = await _apiService.post(
        ApiConstants.resendOtp,
        data: {'email': email},
      );
      return Right(response.data['message']);
    } catch (error) {
      return Left(ApiErrorHandler.getMessage(error));
    }
  }

  Future<Either<String, String>> logout() async {
    try {
      final response = await _apiService.post(ApiConstants.logout);
      return Right(response.data['message']);
    } catch (error) {
      return Left(ApiErrorHandler.getMessage(error));
    } finally {
      await CacheHelper.deleteSecureData(key: CacheConstants.userToken);
    }
  }
}
