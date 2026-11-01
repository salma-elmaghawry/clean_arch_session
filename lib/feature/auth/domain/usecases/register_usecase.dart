import 'package:clean_arch_session/feature/auth/domain/entities/register_entity.dart';
import 'package:clean_arch_session/feature/auth/domain/repositories/auth_repo.dart';

class RegisterUseCase {
  final AuthRepo _authRepo;

  RegisterUseCase(this._authRepo);

  // register only creates the account, the backend doesn't send an OTP for it,
  // so we ask for one right away and return that message
  Future<String> call(RegisterEntity entity) async {
    await _authRepo.register(entity);
    return _authRepo.resendOtp(email: entity.email);
  }
}
