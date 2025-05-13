
import 'user_model.dart';

class RegisterResponse {
  final bool? success;
  final String? message;
  final UserModel? user;

  const RegisterResponse({this.success, this.message, this.user});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      user: json['data'] == null
          ? null
          : UserModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }


}
