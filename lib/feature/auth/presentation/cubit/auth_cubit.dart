import 'package:clean_arch_session/core/networking/api_error_handler.dart';
import 'package:clean_arch_session/feature/auth/domain/entities/register_entity.dart';
import 'package:clean_arch_session/feature/auth/domain/usecases/login_usecase.dart';
import 'package:clean_arch_session/feature/auth/domain/usecases/logout_usecase.dart';
import 'package:clean_arch_session/feature/auth/domain/usecases/register_usecase.dart';
import 'package:clean_arch_session/feature/auth/domain/usecases/resend_otp_usecase.dart';
import 'package:clean_arch_session/feature/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;
  final ResendOtpUseCase _resendOtpUseCase;
  final LogoutUseCase _logoutUseCase;

  AuthCubit(
    this._loginUseCase,
    this._registerUseCase,
    this._verifyOtpUseCase,
    this._resendOtpUseCase,
    this._logoutUseCase,
  ) : super(AuthInitial());

  Future<void> login({required String email, required String password}) async {
    emit(AuthLoading());
    try {
      final message = await _loginUseCase(email: email, password: password);
      emit(AuthOtpSent(email: email, message: message));
    } catch (error) {
      emit(AuthFailure(ApiErrorHandler.getMessage(error)));
    }
  }

  Future<void> register(RegisterEntity entity) async {
    emit(AuthLoading());
    try {
      final message = await _registerUseCase(entity);
      emit(AuthOtpSent(email: entity.email, message: message));
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
      await _verifyOtpUseCase(email: email, otpCode: otpCode);
      emit(AuthVerified());
    } catch (error) {
      emit(AuthFailure(ApiErrorHandler.getMessage(error)));
    }
  }

  Future<void> resendOtp({required String email}) async {
    emit(AuthLoading());
    try {
      final message = await _resendOtpUseCase(email: email);
      emit(AuthOtpSent(email: email, message: message));
    } catch (error) {
      emit(AuthFailure(ApiErrorHandler.getMessage(error)));
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());
    try {
      await _logoutUseCase();
    } catch (_) {
      // the token is deleted locally either way, so the user is still logged out
    }
    emit(AuthLoggedOut());
  }
}
