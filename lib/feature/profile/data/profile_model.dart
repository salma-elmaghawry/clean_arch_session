import 'package:clean_arch_session/feature/profile/domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  ProfileModel({
    required super.name,
    required super.email,
    required super.phone,
    super.address,
    super.latitude,
    super.longitude,
    super.pictureUrl,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      // Laravel sends decimal columns as strings, so parse whatever comes
      latitude: double.tryParse('${json['latitude']}'),
      longitude: double.tryParse('${json['longitude']}'),
      pictureUrl: json['picture_url'],
    );
  }
}
