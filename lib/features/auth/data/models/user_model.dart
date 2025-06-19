class UserModel {
  final int? id;
  final String? username;
  final String? email;
  final String? firstName;
  final String? lastName;
  final bool? verified;
  final String? otp;
  final DateTime? otpExpiration;
  final dynamic resetOtp;
  final dynamic resetOtpExpiration;

  const UserModel({
    this.id,
    this.username,
    this.email,
    this.firstName,
    this.lastName,
    this.verified,
    this.otp,
    this.otpExpiration,
    this.resetOtp,
    this.resetOtpExpiration,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as int?,
        username: json['username'] as String?,
        email: json['email'] as String?,
        firstName: json['firstName'] as String?,
        lastName: json['lastName'] as String?,
        verified: json['verified'] as bool?,
        otp: json['otp'] as String?,
        otpExpiration: json['otpExpiration'] == null
            ? null
            : DateTime.parse(json['otpExpiration'] as String),
        resetOtp: json['resetOtp'] as dynamic,
        resetOtpExpiration: json['resetOtpExpiration'] as dynamic,
      );
}
