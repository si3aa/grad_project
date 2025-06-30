
class myUser {
  bool? success;
  String? message;
  Data? data;

  myUser({this.success, this.message, this.data});

  myUser.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? username;
  String? email;
  String? firstName;
  String? lastName;
  String? role;
  bool? verified;
  Null otp;
  String? otpExpiration;
  Null? resetOtp;
  Null? resetOtpExpiration;
  ProfileUserProfile? profile;
  int? loyaltyPoints;
  double? walletBalance;
  double? reservedBalance;

  Data({
    this.id,
    this.username,
    this.email,
    this.firstName,
    this.lastName,
    this.role,
    this.verified,
    this.otp,
    this.otpExpiration,
    this.resetOtp,
    this.resetOtpExpiration,
    this.profile,
    this.loyaltyPoints,
    this.walletBalance,
    this.reservedBalance,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    role = json['role'];
    verified = json['verified'];
    otp = json['otp'];
    otpExpiration = json['otpExpiration'];
    resetOtp = json['resetOtp'];
    resetOtpExpiration = json['resetOtpExpiration'];
    profile = json['profile'] != null
        ? ProfileUserProfile.fromJson(json['profile'])
        : null;
    loyaltyPoints = json['loyaltyPoints'];
    walletBalance = (json['walletBalance'] ?? 0).toDouble();
    reservedBalance = (json['reservedBalance'] ?? 0).toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = this.id;
    data['username'] = this.username;
    data['email'] = this.email;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['role'] = this.role;
    data['verified'] = this.verified;
    data['otp'] = this.otp;
    data['otpExpiration'] = this.otpExpiration;
    data['resetOtp'] = this.resetOtp;
    data['resetOtpExpiration'] = this.resetOtpExpiration;
    if (profile != null) {
      data['profile'] = profile!.toJson();
    }
    data['loyaltyPoints'] = this.loyaltyPoints;
    data['walletBalance'] = this.walletBalance;
    data['reservedBalance'] = this.reservedBalance;
    return data;
  }
}

class ProfileUserProfile {
  int? id;
  String? firstName;
  String? lastName;
  String? phone;
  String? address;
  String? bio;
  String? profilePictureUrl;

  ProfileUserProfile({
    this.id,
    this.firstName,
    this.lastName,
    this.phone,
    this.address,
    this.bio,
    this.profilePictureUrl,
  });

  ProfileUserProfile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    phone = json['phone'];
    address = json['address'];
    bio = json['bio'];
    profilePictureUrl = json['profilePictureUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = this.id;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['bio'] = this.bio;
    data['profilePictureUrl'] = this.profilePictureUrl;
    return data;
  }
}
