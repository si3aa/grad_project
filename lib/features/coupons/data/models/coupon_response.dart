import 'package:Herfa/features/coupons/data/models/coupon_model.dart';

class CouponResponse {
  final bool success;
  final String message;
  final CouponModel? data;

  CouponResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory CouponResponse.fromJson(Map<String, dynamic> json) {
    return CouponResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? CouponModel.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}
