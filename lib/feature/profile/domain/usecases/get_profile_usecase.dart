import 'package:clean_arch_session/feature/profile/domain/entities/profile_entity.dart';
import 'package:clean_arch_session/feature/profile/domain/repositories/profile_repo.dart';

class GetProfileUseCase {
  final ProfileRepo _profileRepo;

  GetProfileUseCase(this._profileRepo);

  Future<ProfileEntity> call() {
    return _profileRepo.getProfile();
  }
}
