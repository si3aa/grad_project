class UserImageModel {
  final bool success;
  final String message;
  final String imageUrl;

  UserImageModel({
    required this.success,
    required this.message,
    required this.imageUrl,
  });

  factory UserImageModel.fromJson(Map<String, dynamic> json) {
    return UserImageModel(
      success: json['success'] ?? false,
      message: json['message']?.toString() ?? '',
      imageUrl: json['data']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': imageUrl,
    };
  }
}
