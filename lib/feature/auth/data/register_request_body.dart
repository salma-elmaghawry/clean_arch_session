import 'package:dio/dio.dart';

class RegisterRequestBody {
  final String name;
  final String email;
  final String phone;
  final String password;
  final String passwordConfirmation;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String? picturePath;

  RegisterRequestBody({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.passwordConfirmation,
    this.address,
    this.latitude,
    this.longitude,
    this.picturePath,
  });

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
