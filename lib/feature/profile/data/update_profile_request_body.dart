import 'package:clean_arch_session/feature/profile/domain/entities/update_profile_entity.dart';
import 'package:dio/dio.dart';

// The domain entity can't know about Dio, so the data layer adds the
// multipart body the update endpoint expects
extension UpdateProfileRequestBody on UpdateProfileEntity {
  Future<FormData> toFormData() async {
    return FormData.fromMap({
      // the route is PUT, but PHP only reads multipart bodies (our picture)
      // on POST, so we send POST and Laravel routes it as PUT
      '_method': 'PUT',
      'name': name,
      'email': email,
      'phone': phone,
      if (address != null) 'address': address,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (picturePath != null)
        'picture': await MultipartFile.fromFile(picturePath!),
    });
  }
}
