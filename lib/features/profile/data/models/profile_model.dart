class ProfileModel {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? address;
  final String? bio;
  final String? profilePictureUrl;
  final String? userType; // 'merchant' or 'user'
  final String? email;

  ProfileModel({
    this.id,
    this.firstName,
    this.lastName,
    this.phone,
    this.address,
    this.bio,
    this.profilePictureUrl,
    this.userType,
    this.email,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        id: json['id'] ?? json['userId'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        phone: json['phone'],
        address: json['address'],
        bio: json['bio'],
        profilePictureUrl: json['profilePictureUrl'],
        userType: json['userType'],
        email: json['email'],
      );

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'phone': phone,
        'address': address,
        'bio': bio,
        'profilePictureUrl': profilePictureUrl,
        'userType': userType,
        'email': email,
      };
}
