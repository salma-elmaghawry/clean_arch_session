import 'package:clean_arch_session/core/networking/api_error_handler.dart';
import 'package:clean_arch_session/feature/auth/data/auth_repo.dart';
import 'package:clean_arch_session/feature/auth/data/register_request_body.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo _authRepo;

  AuthCubit(this._authRepo) : super(AuthInitial());

  Future<void> login({required String email, required String password}) async {
    emit(AuthLoading());
    try {
      final message = await _authRepo.login(email: email, password: password);
      emit(AuthOtpSent(email: email, message: message));
    } catch (error) {
      emit(AuthFailure(ApiErrorHandler.getMessage(error)));
    }
  }

  Future<void> register(RegisterRequestBody body) async {
    emit(AuthLoading());
    try {
      await _authRepo.register(body);
      // register only creates the account, the backend doesn't send an OTP for it
      await resendOtp(email: body.email);
    } catch (error) {
      emit(AuthFailure(ApiErrorHandler.getMessage(error)));
    }
  }

  Future<void> verifyOtp({
    required String email,
    required String otpCode,
  }) async {
    emit(AuthLoading());
    try {
      await _authRepo.verifyOtp(email: email, otpCode: otpCode);
      emit(AuthVerified());
    } catch (error) {
      emit(AuthFailure(ApiErrorHandler.getMessage(error)));
    }
  }

  Future<void> resendOtp({required String email}) async {
    emit(AuthLoading());
    try {
      final message = await _authRepo.resendOtp(email: email);
      emit(AuthOtpSent(email: email, message: message));
    } catch (error) {
      emit(AuthFailure(ApiErrorHandler.getMessage(error)));
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());
    try {
      await _authRepo.logout();
    } catch (_) {
      // the token is deleted locally either way, so the user is still logged out
    }
    emit(AuthLoggedOut());
  }
}
