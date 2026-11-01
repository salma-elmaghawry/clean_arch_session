class ProfileModel {
  final String name;
  final String email;
  final String phone;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String? pictureUrl;

  ProfileModel({
    required this.name,
    required this.email,
    required this.phone,
    this.address,
    this.latitude,
    this.longitude,
    this.pictureUrl,
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
