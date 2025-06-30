class ProfileOrderModel {
  final int id;
  final String orderDate;
  final double totalPrice;
  final String status;
  final List<ProfileOrderDetail> orderDetails;
  final String? paidAt;
  final List<String> appliedOffers;

  ProfileOrderModel({
    required this.id,
    required this.orderDate,
    required this.totalPrice,
    required this.status,
    required this.orderDetails,
    this.paidAt,
    required this.appliedOffers,
  });

  factory ProfileOrderModel.fromJson(Map<String, dynamic> json) =>
      ProfileOrderModel(
        id: json['id'],
        orderDate: json['orderDate'],
        totalPrice: (json['totalPrice'] ?? 0).toDouble(),
        status: json['status'],
        orderDetails: (json['orderDetails'] as List)
            .map((e) => ProfileOrderDetail.fromJson(e))
            .toList(),
        paidAt: json['paidAt'],
        appliedOffers:
            (json['appliedOffers'] as List).map((e) => e.toString()).toList(),
      );
}

class ProfileOrderDetail {
  final int id;
  final ProfileProduct product;
  final ProfileCoupon? coupon;
  final int quantity;
  final double unitPrice;
  final dynamic bundle;

  ProfileOrderDetail({
    required this.id,
    required this.product,
    this.coupon,
    required this.quantity,
    required this.unitPrice,
    this.bundle,
  });

  factory ProfileOrderDetail.fromJson(Map<String, dynamic> json) =>
      ProfileOrderDetail(
        id: json['id'],
        product: ProfileProduct.fromJson(json['product']),
        coupon: json['coupon'] != null
            ? ProfileCoupon.fromJson(json['coupon'])
            : null,
        quantity: json['quantity'],
        unitPrice: (json['unitPrice'] ?? 0).toDouble(),
        bundle: json['bundle'],
      );
}

class ProfileProduct {
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

  ProfileProduct({
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

  factory ProfileProduct.fromJson(Map<String, dynamic> json) => ProfileProduct(
        id: json['id'],
        name: json['name'],
        shortDescription: json['shortDescription'],
        longDescription: json['longDescription'],
        price: (json['price'] ?? 0).toDouble(),
        quantity: json['quantity'],
        media: json['media'],
        active: json['active'],
        colors: (json['colors'] as List).map((e) => e.toString()).toList(),
        discountedPrice: (json['discountedPrice'] ?? 0).toDouble(),
      );
}

class ProfileCoupon {
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
  final ProfileProduct product;
  final ProfileCreatedBy createdBy;

  ProfileCoupon({
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

  factory ProfileCoupon.fromJson(Map<String, dynamic> json) => ProfileCoupon(
        id: json['id'],
        code: json['code'],
        discountType: json['discountType'],
        discount: (json['discount'] ?? 0).toDouble(),
        maxDiscount: (json['maxDiscount'] ?? 0).toDouble(),
        availableQuantity: json['availableQuantity'],
        expiryDate: json['expiryDate'],
        active: json['active'],
        fixedPrice: json['fixedPrice'] != null
            ? (json['fixedPrice'] as num).toDouble()
            : null,
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt'],
        minOrderAmount: json['minOrderAmount'] != null
            ? (json['minOrderAmount'] as num).toDouble()
            : null,
        userSegment: json['userSegment'],
        product: ProfileProduct.fromJson(json['product']),
        createdBy: ProfileCreatedBy.fromJson(json['createdBy']),
      );
}

class ProfileCreatedBy {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String role;
  final bool verified;
  final dynamic otp;
  final String otpExpiration;
  final dynamic resetOtp;
  final dynamic resetOtpExpiration;
  final ProfileUserProfile profile;
  final int loyaltyPoints;
  final double walletBalance;
  final double reservedBalance;

  ProfileCreatedBy({
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

  factory ProfileCreatedBy.fromJson(Map<String, dynamic> json) =>
      ProfileCreatedBy(
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
        profile: ProfileUserProfile.fromJson(json['profile']),
        loyaltyPoints: json['loyaltyPoints'],
        walletBalance: (json['walletBalance'] ?? 0).toDouble(),
        reservedBalance: (json['reservedBalance'] ?? 0).toDouble(),
      );
}

class ProfileUserProfile {
  final int id;
  final String firstName;
  final String lastName;
  final String phone;
  final String address;
  final String bio;
  final String profilePictureUrl;

  ProfileUserProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.address,
    required this.bio,
    required this.profilePictureUrl,
  });

  factory ProfileUserProfile.fromJson(Map<String, dynamic> json) =>
      ProfileUserProfile(
        id: json['id'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        phone: json['phone'],
        address: json['address'],
        bio: json['bio'],
        profilePictureUrl: json['profilePictureUrl'],
      );
}
