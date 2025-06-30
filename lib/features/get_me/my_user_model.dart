// ignore_for_file: unnecessary_question_mark

class myUser {
  bool? success;
  String? message;
  Data? data;

  myUser({this.success, this.message, this.data});

  myUser.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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

  int? loyaltyPoints;
  double? walletBalance;
  

  Data(
      {this.id,
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
    
      this.loyaltyPoints,
      this.walletBalance,
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
    
    loyaltyPoints = json['loyaltyPoints'];
    walletBalance = json['walletBalance'];
    
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
    
    data['loyaltyPoints'] = this.loyaltyPoints;
    data['walletBalance'] = this.walletBalance;
    
    return data;
  }
}
