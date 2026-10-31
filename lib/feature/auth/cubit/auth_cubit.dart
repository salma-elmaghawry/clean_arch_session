import 'package:clean_arch_session/feature/auth/data/auth_repo.dart';
import 'package:clean_arch_session/feature/auth/data/register_request_body.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo _authRepo;

  AuthCubit(this._authRepo) : super(AuthInitial());

  Future<void> login({required String email, required String password}) async {
    emit(AuthLoading());
    final result = await _authRepo.login(email: email, password: password);
    result.fold(
      (error) => emit(AuthFailure(error)),
      (message) => emit(AuthOtpSent(email: email, message: message)),
    );
  }

  Future<void> register(RegisterRequestBody body) async {
    emit(AuthLoading());
    final result = await _authRepo.register(body);
    // register only creates the account, the backend doesn't send an OTP for it
    await result.fold(
      (error) async => emit(AuthFailure(error)),
      (_) => resendOtp(email: body.email),
    );
  }

  Future<void> verifyOtp({
    required String email,
    required String otpCode,
  }) async {
    emit(AuthLoading());
    final result = await _authRepo.verifyOtp(email: email, otpCode: otpCode);
    result.fold(
      (error) => emit(AuthFailure(error)),
      (message) => emit(AuthVerified()),
    );
  }

  Future<void> resendOtp({required String email}) async {
    emit(AuthLoading());
    final result = await _authRepo.resendOtp(email: email);
    result.fold(
      (error) => emit(AuthFailure(error)),
      (message) => emit(AuthOtpSent(email: email, message: message)),
    );
  }

  Future<void> logout() async {
    emit(AuthLoading());
    await _authRepo.logout();
    emit(AuthLoggedOut());
  }
}
