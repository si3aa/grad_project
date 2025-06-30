class RefundRequestModel {
  final int id;
  final OrderModel order;
  final UserModel user;
  final String reasonType;
  final String reasonMessage;
  final List<String> imageUrls;
  final String status;
  final String createdAt;

  RefundRequestModel({
    required this.id,
    required this.order,
    required this.user,
    required this.reasonType,
    required this.reasonMessage,
    required this.imageUrls,
    required this.status,
    required this.createdAt,
  });

  factory RefundRequestModel.fromJson(Map<String, dynamic> json) {
    return RefundRequestModel(
      id: json['id'],
      order: OrderModel.fromJson(json['order']),
      user: UserModel.fromJson(json['user']),
      reasonType: json['reasonType'],
      reasonMessage: json['reasonMessage'],
      imageUrls: List<String>.from(json['imageUrls']),
      status: json['status'],
      createdAt: json['createdAt'],
    );
  }
}

class OrderModel {
  final int id;
  final String orderDate;
  final double totalPrice;
  final String status;
  final List<OrderDetailModel> orderDetails;
  final String paidAt;
  final List<String> appliedOffers;

  OrderModel({
    required this.id,
    required this.orderDate,
    required this.totalPrice,
    required this.status,
    required this.orderDetails,
    required this.paidAt,
    required this.appliedOffers,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      orderDate: json['orderDate'],
      totalPrice: json['totalPrice'].toDouble(),
      status: json['status'],
      orderDetails: (json['orderDetails'] as List)
          .map((detail) => OrderDetailModel.fromJson(detail))
          .toList(),
      paidAt: json['paidAt'],
      appliedOffers: List<String>.from(json['appliedOffers']),
    );
  }
}

class OrderDetailModel {
  final int id;
  final ProductModel product;
  final CouponModel? coupon;
  final int quantity;
  final double unitPrice;
  final dynamic bundle;

  OrderDetailModel({
    required this.id,
    required this.product,
    this.coupon,
    required this.quantity,
    required this.unitPrice,
    this.bundle,
  });

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailModel(
      id: json['id'],
      product: ProductModel.fromJson(json['product']),
      coupon:
          json['coupon'] != null ? CouponModel.fromJson(json['coupon']) : null,
      quantity: json['quantity'],
      unitPrice: json['unitPrice'].toDouble(),
      bundle: json['bundle'],
    );
  }
}

class ProductModel {
  final int id;
  final String name;
  final String shortDescription;
  final String longDescription;
  final double price;
  final int quantity;
  final String media;
  final bool active;
  final List<String> colors;
  final double discountedPrice;

  ProductModel({
    required this.id,
    required this.name,
    required this.shortDescription,
    required this.longDescription,
    required this.price,
    required this.quantity,
    required this.media,
    required this.active,
    required this.colors,
    required this.discountedPrice,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      shortDescription: json['shortDescription'],
      longDescription: json['longDescription'],
      price: json['price'].toDouble(),
      quantity: json['quantity'],
      media: json['media'],
      active: json['active'],
      colors: List<String>.from(json['colors']),
      discountedPrice: json['discountedPrice'].toDouble(),
    );
  }
}

class CouponModel {
  final int id;
  final String code;
  final String discountType;
  final double discount;
  final double maxDiscount;
  final int availableQuantity;
  final String expiryDate;
  final bool active;
  final double? fixedPrice;
  final String createdAt;
  final String updatedAt;
  final double? minOrderAmount;
  final dynamic userSegment;
  final ProductModel product;
  final UserModel createdBy;

  CouponModel({
    required this.id,
    required this.code,
    required this.discountType,
    required this.discount,
    required this.maxDiscount,
    required this.availableQuantity,
    required this.expiryDate,
    required this.active,
    this.fixedPrice,
    required this.createdAt,
    required this.updatedAt,
    this.minOrderAmount,
    this.userSegment,
    required this.product,
    required this.createdBy,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      id: json['id'],
      code: json['code'],
      discountType: json['discountType'],
      discount: json['discount'].toDouble(),
      maxDiscount: json['maxDiscount'].toDouble(),
      availableQuantity: json['availableQuantity'],
      expiryDate: json['expiryDate'],
      active: json['active'],
      fixedPrice: json['fixedPrice']?.toDouble(),
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      minOrderAmount: json['minOrderAmount']?.toDouble(),
      userSegment: json['userSegment'],
      product: ProductModel.fromJson(json['product']),
      createdBy: UserModel.fromJson(json['createdBy']),
    );
  }
}

class UserModel {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String role;
  final bool verified;
  final String? otp;
  final String otpExpiration;
  final String? resetOtp;
  final String? resetOtpExpiration;
  final ProfileModel profile;
  final int loyaltyPoints;
  final double walletBalance;
  final double reservedBalance;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.verified,
    this.otp,
    required this.otpExpiration,
    this.resetOtp,
    this.resetOtpExpiration,
    required this.profile,
    required this.loyaltyPoints,
    required this.walletBalance,
    required this.reservedBalance,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      role: json['role'],
      verified: json['verified'],
      otp: json['otp'],
      otpExpiration: json['otpExpiration'],
      resetOtp: json['resetOtp'],
      resetOtpExpiration: json['resetOtpExpiration'],
      profile: ProfileModel.fromJson(json['profile']),
      loyaltyPoints: json['loyaltyPoints'],
      walletBalance: json['walletBalance'].toDouble(),
      reservedBalance: json['reservedBalance'].toDouble(),
    );
  }
}

class ProfileModel {
  final int id;
  final String firstName;
  final String lastName;
  final String phone;
  final String address;
  final String bio;
  final String profilePictureUrl;

  ProfileModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.address,
    required this.bio,
    required this.profilePictureUrl,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phone: json['phone'],
      address: json['address'],
      bio: json['bio'],
      profilePictureUrl: json['profilePictureUrl'],
    );
  }
}

// Request model for creating refund
class RefundRequestCreateModel {
  final int orderId;
  final String reasonType;
  final String message;
  final List<String> imagePaths;

  RefundRequestCreateModel({
    required this.orderId,
    required this.reasonType,
    required this.message,
    required this.imagePaths,
  });

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'reasonType': reasonType,
      'message': message,
      'imagePaths': imagePaths,
    };
  }
}

// API Response wrapper
class RefundRequestResponse {
  final bool success;
  final String message;
  final RefundRequestModel? data;

  RefundRequestResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory RefundRequestResponse.fromJson(Map<String, dynamic> json) {
    return RefundRequestResponse(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null
          ? RefundRequestModel.fromJson(json['data'])
          : null,
    );
  }
}
