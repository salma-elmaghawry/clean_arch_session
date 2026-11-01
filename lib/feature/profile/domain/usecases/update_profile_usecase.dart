import 'package:clean_arch_session/feature/profile/domain/entities/update_profile_entity.dart';
import 'package:clean_arch_session/feature/profile/domain/repositories/profile_repo.dart';

class UpdateProfileUseCase {
  final ProfileRepo _profileRepo;

  UpdateProfileUseCase(this._profileRepo);

  Future<String> call(UpdateProfileEntity entity) {
    return _profileRepo.updateProfile(entity);
  }
}
