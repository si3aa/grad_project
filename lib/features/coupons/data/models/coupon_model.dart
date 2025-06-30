import 'package:Herfa/features/auth/data/models/user_model.dart';
import 'package:Herfa/features/get_product/data/models/all_product_data_model.dart';

class CouponModel {
  final int id;
  final String code;
  final String discountType;
  final double discount;
  final double? maxDiscount;
  final int availableQuantity;
  final String expiryDate;
  final bool active;
  final double? fixedPrice;
  final String createdAt;
  final String updatedAt;
  final double? minOrderAmount;
  final String? userSegment;
  final AllproductDataModel product;
  final UserModel? createdBy;

  CouponModel({
    required this.id,
    required this.code,
    required this.discountType,
    required this.discount,
    this.maxDiscount,
    required this.availableQuantity,
    required this.expiryDate,
    required this.active,
    this.fixedPrice,
    required this.createdAt,
    required this.updatedAt,
    this.minOrderAmount,
    this.userSegment,
    required this.product,
    this.createdBy,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      id: json['id'],
      code: json['code'],
      discountType: json['discountType'],
      discount: json['discount']?.toDouble() ?? 0.0,
      maxDiscount: json['maxDiscount']?.toDouble(),
      availableQuantity: json['availableQuantity'],
      expiryDate: json['expiryDate'],
      active: json['active'],
      fixedPrice: json['fixedPrice']?.toDouble(),
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      minOrderAmount: json['minOrderAmount']?.toDouble(),
      userSegment: json['userSegment'],
      product: AllproductDataModel.fromJson(json['product']),
      createdBy: json['createdBy'] != null
          ? UserModel.fromJson(json['createdBy'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'discountType': discountType,
      'discount': discount,
      'maxDiscount': maxDiscount,
      'availableQuantity': availableQuantity,
      'expiryDate': expiryDate,
      'active': active,
      'fixedPrice': fixedPrice,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'minOrderAmount': minOrderAmount,
      'userSegment': userSegment,
      'product': product.toJson(),
      'createdBy': createdBy?.toJson(),
    };
  }
}
