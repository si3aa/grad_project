
class LoginResponse {
	final bool? success;
	final String? message;
	final String? token;

	const LoginResponse({this.success, this.message, this.token});

	factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
				success: json['success'] as bool?,
				message: json['message'] as String?,
				token: json['data'] as String?,
			);

	Map<String, dynamic> toJson() => {
				'success': success,
				'message': message,
				'data': token,
			};
}
