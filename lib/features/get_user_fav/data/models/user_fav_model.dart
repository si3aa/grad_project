class UserFavModel {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String role;
  final bool verified;
  final String? otp;
  final String? otpExpiration;
  final String? resetOtp;
  final String? resetOtpExpiration;
  final ProfileModel profile;
  final int loyaltyPoints;
  final int walletBalance;
  final int reservedBalance;

  UserFavModel({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.verified,
    this.otp,
    this.otpExpiration,
    this.resetOtp,
    this.resetOtpExpiration,
    required this.profile,
    required this.loyaltyPoints,
    required this.walletBalance,
    required this.reservedBalance,
  });

  factory UserFavModel.fromJson(Map<String, dynamic> json) {
    return UserFavModel(
      id: _parseInt(json['id']),
      username: json['username']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      firstName: json['firstName']?.toString() ?? '',
      lastName: _capitalizeFirst(json['lastName']?.toString() ?? ''),
      role: json['role']?.toString() ?? '',
      verified: json['verified'] == true,
      otp: json['otp']?.toString(),
      otpExpiration: json['otpExpiration']?.toString(),
      resetOtp: json['resetOtp']?.toString(),
      resetOtpExpiration: json['resetOtpExpiration']?.toString(),
      profile: ProfileModel.fromJson(json['profile'] ?? {}),
      loyaltyPoints: _parseInt(json['loyaltyPoints']),
      walletBalance: _parseInt(json['walletBalance']),
      reservedBalance: _parseInt(json['reservedBalance']),
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      final parsed = double.tryParse(value);
      return parsed?.toInt() ?? 0;
    }
    return 0;
  }

  static String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'role': role,
      'verified': verified,
      'otp': otp,
      'otpExpiration': otpExpiration,
      'resetOtp': resetOtp,
      'resetOtpExpiration': resetOtpExpiration,
      'profile': profile.toJson(),
      'loyaltyPoints': loyaltyPoints,
      'walletBalance': walletBalance,
      'reservedBalance': reservedBalance,
    };
  }

  String get fullName {
    final trimmedFirstName = firstName.trim();
    final trimmedLastName = lastName.trim();

    if (trimmedFirstName.isEmpty && trimmedLastName.isEmpty) {
      return '';
    } else if (trimmedFirstName.isEmpty) {
      return trimmedLastName;
    } else if (trimmedLastName.isEmpty) {
      return trimmedFirstName;
    } else {
      return '$trimmedFirstName $trimmedLastName';
    }
  }
}

class ProfileModel {
  final int id;
  final String firstName;
  final String lastName;
  final String phone;
  final String address;
  final String bio;
  final String profilePictureUrl;

  ProfileModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.address,
    required this.bio,
    required this.profilePictureUrl,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: _parseInt(json['id']),
      firstName: json['firstName']?.toString() ?? '',
      lastName: _capitalizeFirst(json['lastName']?.toString() ?? ''),
      phone: json['phone']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      bio: json['bio']?.toString() ?? '',
      profilePictureUrl: json['profilePictureUrl']?.toString() ?? '',
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      final parsed = double.tryParse(value);
      return parsed?.toInt() ?? 0;
    }
    return 0;
  }

  static String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'address': address,
      'bio': bio,
      'profilePictureUrl': profilePictureUrl,
    };
  }

  String get fullName {
    final trimmedFirstName = firstName.trim();
    final trimmedLastName = lastName.trim();

    if (trimmedFirstName.isEmpty && trimmedLastName.isEmpty) {
      return '';
    } else if (trimmedFirstName.isEmpty) {
      return trimmedLastName;
    } else if (trimmedLastName.isEmpty) {
      return trimmedFirstName;
    } else {
      return '$trimmedFirstName $trimmedLastName';
    }
  }
}
