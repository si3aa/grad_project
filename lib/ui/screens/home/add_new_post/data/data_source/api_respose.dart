/// Represents an API response with success status, message, and optional data.
class ApiResponse {
  /// Indicates if the API request was successful
  final bool success;

  /// Message describing the result or error
  final String message;

  /// Optional data returned by the API
  final Map<String, dynamic>? data;

  /// Creates an [ApiResponse] instance.
  const ApiResponse({
    required this.success,
    required this.message,
    this.data,
  });

  /// Creates an [ApiResponse] from a JSON map.
  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'] as Map<String, dynamic>?,
    );
  }

  /// Converts the [ApiResponse] to a JSON map.
  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'data': data,
      };
}