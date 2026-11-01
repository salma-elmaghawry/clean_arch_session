import 'package:clean_arch_session/feature/auth/domain/entities/register_entity.dart';
import 'package:dio/dio.dart';

// The domain entity can't know about Dio, so the data layer adds the
// multipart body the register endpoint expects
extension RegisterRequestBody on RegisterEntity {
  Future<FormData> toFormData() async {
    return FormData.fromMap({
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'password_confirmation': passwordConfirmation,
      if (address != null) 'address': address,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (picturePath != null)
        'picture': await MultipartFile.fromFile(picturePath!),
    });
  }
}
