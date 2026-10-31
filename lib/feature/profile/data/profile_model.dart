class ProfileModel {
  final String name;
  final String email;
  final String phone;
  final String? address;
  final String? pictureUrl;

  ProfileModel({
    required this.name,
    required this.email,
    required this.phone,
    this.address,
    this.pictureUrl,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      pictureUrl: json['picture_url'],
    );
  }
}
