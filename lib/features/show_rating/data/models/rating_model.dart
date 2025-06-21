class RatingResponse {
  final bool success;
  final String message;
  final double data;

  RatingResponse(
      {required this.success, required this.message, required this.data});

  factory RatingResponse.fromJson(Map<String, dynamic> json) {
    return RatingResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] is int)
          ? (json['data'] as int).toDouble()
          : (json['data'] ?? 0.0).toDouble(),
    );
  }
}
