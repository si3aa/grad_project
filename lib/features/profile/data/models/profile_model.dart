class ProfileModel {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? address;
  final String? bio;
  final String? profilePictureUrl;

  ProfileModel({
    this.id,
    this.firstName,
    this.lastName,
    this.phone,
    this.address,
    this.bio,
    this.profilePictureUrl,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        id: json['id'] as int?,
        firstName: json['firstName'] as String?,
        lastName: json['lastName'] as String?,
        phone: json['phone'] as String?,
        address: json['address'] as String?,
        bio: json['bio'] as String?,
        profilePictureUrl: json['profilePictureUrl'] as String?,
      );

  Map<String, dynamic> toJson() => {
        if (firstName != null) 'firstName': firstName,
        if (lastName != null) 'lastName': lastName,
        if (phone != null) 'phone': phone,
        if (address != null) 'address': address,
        if (bio != null) 'bio': bio,
        if (profilePictureUrl != null) 'profilePictureUrl': profilePictureUrl,
      };
}
