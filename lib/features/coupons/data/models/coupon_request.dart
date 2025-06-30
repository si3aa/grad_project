class CouponRequest {
  final String code;
  final String discountType;
  final double? discount;
  final double? maxDiscount;
  final int availableQuantity;
  final String expiryDate;
  final int productId;
  final double? minOrderAmount;
  final bool isActive;
  final double? fixedPrice;

  CouponRequest({
    required this.code,
    required this.discountType,
    this.discount,
    this.maxDiscount,
    required this.availableQuantity,
    required this.expiryDate,
    required this.productId,
    this.minOrderAmount,
    this.isActive = true,
    this.fixedPrice,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'code': code,
      'discountType': discountType,
      'availableQuantity': availableQuantity,
      'expiryDate': expiryDate,
      'productId': productId,
      'isActive': isActive,
    };

    // Add fields based on discount type
    switch (discountType) {
      case 'PERCENTAGE':
        if (discount != null) data['discount'] = discount;
        if (maxDiscount != null) data['maxDiscount'] = maxDiscount;
        if (minOrderAmount != null) data['minOrderAmount'] = minOrderAmount;
        break;
      case 'FIXED_PRICE':
        if (fixedPrice != null) data['fixedPrice'] = fixedPrice;
        break;
      case 'AMOUNT':
        if (discount != null) data['discount'] = discount;
        if (minOrderAmount != null) data['minOrderAmount'] = minOrderAmount;
        break;
    }

    return data;
  }

  // Factory constructors for different coupon types
  factory CouponRequest.percentage({
    required String code,
    required double discount,
    double? maxDiscount,
    required int availableQuantity,
    required String expiryDate,
    required int productId,
    double? minOrderAmount,
    bool isActive = true,
  }) {
    return CouponRequest(
      code: code,
      discountType: 'PERCENTAGE',
      discount: discount,
      maxDiscount: maxDiscount,
      availableQuantity: availableQuantity,
      expiryDate: expiryDate,
      productId: productId,
      minOrderAmount: minOrderAmount,
      isActive: isActive,
    );
  }

  factory CouponRequest.fixedPrice({
    required String code,
    required double fixedPrice,
    required int availableQuantity,
    required String expiryDate,
    required int productId,
    bool isActive = true,
  }) {
    return CouponRequest(
      code: code,
      discountType: 'FIXED_PRICE',
      fixedPrice: fixedPrice,
      availableQuantity: availableQuantity,
      expiryDate: expiryDate,
      productId: productId,
      isActive: isActive,
    );
  }

  factory CouponRequest.amount({
    required String code,
    required double discount,
    required int availableQuantity,
    required String expiryDate,
    required int productId,
    double? minOrderAmount,
    bool isActive = true,
  }) {
    return CouponRequest(
      code: code,
      discountType: 'AMOUNT',
      discount: discount,
      availableQuantity: availableQuantity,
      expiryDate: expiryDate,
      productId: productId,
      minOrderAmount: minOrderAmount,
      isActive: isActive,
    );
  }
}
