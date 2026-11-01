import 'package:clean_arch_session/feature/profile/domain/entities/profile_entity.dart';
import 'package:clean_arch_session/feature/profile/domain/entities/update_profile_entity.dart';

abstract class ProfileRepo {
  Future<ProfileEntity> getProfile();

  Future<String> updateProfile(UpdateProfileEntity entity);
}
