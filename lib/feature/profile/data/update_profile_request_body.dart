import 'package:dio/dio.dart';

class UpdateProfileRequestBody {
  final String name;
  final String email;
  final String phone;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String? picturePath;

  UpdateProfileRequestBody({
    required this.name,
    required this.email,
    required this.phone,
    this.address,
    this.latitude,
    this.longitude,
    this.picturePath,
  });

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
