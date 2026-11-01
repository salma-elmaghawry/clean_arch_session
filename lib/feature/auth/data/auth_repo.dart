import 'package:clean_arch_session/core/cache/cache_const.dart';
import 'package:clean_arch_session/core/cache/cache_helper.dart';
import 'package:clean_arch_session/core/networking/api_constants.dart';
import 'package:clean_arch_session/core/networking/api_service.dart';
import 'package:clean_arch_session/feature/auth/data/register_request_body.dart';

class AuthRepo {
  final ApiService _apiService;

  AuthRepo(this._apiService);

    //<<----      login  ------>>  

  Future<String> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiService.post(
      ApiConstants.login,
      data: {'email': email, 'password': password},
    );
    return response.data['message'];
  }
    //<<----      register  ------>>  

  Future<String> register(RegisterRequestBody body) async {
    final response = await _apiService.post(
      ApiConstants.register,
      data: await body.toFormData(),
    );
    return response.data['message'];
  }
    //<<----      verifyOtp  ------>>  

  Future<String> verifyOtp({
    required String email,
    required String otpCode,
  }) async {
    final response = await _apiService.post(
      ApiConstants.verifyOtp,
      data: {'email': email, 'otp_code': otpCode},
    );
    await CacheHelper.saveSecureData(
      key: CacheConstants.userToken,
      value: response.data['token'],
    );
    return response.data['message'];
  }
    //<<----      resendOtp  ------>>  
  Future<String> resendOtp({required String email}) async {
    final response = await _apiService.post(
      ApiConstants.resendOtp,
      data: {'email': email},
    );
    return response.data['message'];
  }
    //<<----      logout  ------>>  
  Future<String> logout() async {
    try {
      final response = await _apiService.post(ApiConstants.logout);
      return response.data['message'];
    } finally {
      await CacheHelper.deleteSecureData(key: CacheConstants.userToken);
    }
  }
}
