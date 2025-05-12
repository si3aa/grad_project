
class VerifyResponse {
	final bool? success;
	final String? message;
	final dynamic data;

	const VerifyResponse({this.success, this.message, this.data});

	factory VerifyResponse.fromJson(Map<String, dynamic> json) {
		return VerifyResponse(
			success: json['success'] as bool?,
			message: json['message'] as String?,
			data: json['data'] as dynamic,
		);
	}

}
