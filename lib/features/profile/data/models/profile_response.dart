import 'profile_model.dart';

class ProfileResponse {
  final bool success;
  final String message;
  final ProfileModel? data;

  ProfileResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) =>
      ProfileResponse(
        success: json['success'] as bool,
        message: json['message'] as String,
        data: json['data'] != null ? ProfileModel.fromJson(json['data']) : null,
      );
}
