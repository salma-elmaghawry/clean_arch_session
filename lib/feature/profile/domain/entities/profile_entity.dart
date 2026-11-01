class ProfileEntity {
  final String name;
  final String email;
  final String phone;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String? pictureUrl;

  ProfileEntity({
    required this.name,
    required this.email,
    required this.phone,
    this.address,
    this.latitude,
    this.longitude,
    this.pictureUrl,
  });
}
