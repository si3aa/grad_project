import 'package:flutter_test/flutter_test.dart';
import 'package:Herfa/features/coupons/data/models/coupon_request.dart';

void main() {
  group('Coupon Creation Tests', () {
    test('should create percentage coupon request correctly', () {
      final request = CouponRequest.percentage(
        code: 'SALE20',
        discount: 20.0,
        maxDiscount: 100.0,
        availableQuantity: 10,
        expiryDate: '2025-06-30T23:59:59',
        productId: 1,
        minOrderAmount: 200.0,
      );

      expect(request.code, 'SALE20');
      expect(request.discountType, 'PERCENTAGE');
      expect(request.discount, 20.0);
      expect(request.maxDiscount, 100.0);
      expect(request.availableQuantity, 10);
      expect(request.productId, 1);
      expect(request.minOrderAmount, 200.0);
    });

    test('should create fixed price coupon request correctly', () {
      final request = CouponRequest.fixedPrice(
        code: 'FIXED299',
        fixedPrice: 299.0,
        availableQuantity: 15,
        expiryDate: '2025-06-30T23:59:59',
        productId: 1,
      );

      expect(request.code, 'FIXED299');
      expect(request.discountType, 'FIXED_PRICE');
      expect(request.fixedPrice, 299.0);
      expect(request.availableQuantity, 15);
      expect(request.productId, 1);
    });

    test('should create amount coupon request correctly', () {
      final request = CouponRequest.amount(
        code: 'FLAT60',
        discount: 60.0,
        availableQuantity: 30,
        expiryDate: '2025-06-30T23:59:59',
        productId: 1,
        minOrderAmount: 100.0,
      );

      expect(request.code, 'FLAT60');
      expect(request.discountType, 'AMOUNT');
      expect(request.discount, 60.0);
      expect(request.availableQuantity, 30);
      expect(request.productId, 1);
      expect(request.minOrderAmount, 100.0);
    });

    test('should convert percentage coupon to JSON correctly', () {
      final request = CouponRequest.percentage(
        code: 'SALE20',
        discount: 20.0,
        maxDiscount: 100.0,
        availableQuantity: 10,
        expiryDate: '2025-06-30T23:59:59',
        productId: 1,
        minOrderAmount: 200.0,
      );

      final json = request.toJson();

      expect(json['code'], 'SALE20');
      expect(json['discountType'], 'PERCENTAGE');
      expect(json['discount'], 20.0);
      expect(json['maxDiscount'], 100.0);
      expect(json['availableQuantity'], 10);
      expect(json['expiryDate'], '2025-06-30T23:59:59');
      expect(json['productId'], 1);
      expect(json['minOrderAmount'], 200.0);
      expect(json['isActive'], true);
    });

    test('should convert fixed price coupon to JSON correctly', () {
      final request = CouponRequest.fixedPrice(
        code: 'FIXED299',
        fixedPrice: 299.0,
        availableQuantity: 15,
        expiryDate: '2025-06-30T23:59:59',
        productId: 1,
      );

      final json = request.toJson();

      expect(json['code'], 'FIXED299');
      expect(json['discountType'], 'FIXED_PRICE');
      expect(json['fixedPrice'], 299.0);
      expect(json['availableQuantity'], 15);
      expect(json['expiryDate'], '2025-06-30T23:59:59');
      expect(json['productId'], 1);
      expect(json['isActive'], true);
      expect(json.containsKey('discount'), false);
      expect(json.containsKey('maxDiscount'), false);
    });

    test('should convert amount coupon to JSON correctly', () {
      final request = CouponRequest.amount(
        code: 'FLAT60',
        discount: 60.0,
        availableQuantity: 30,
        expiryDate: '2025-06-30T23:59:59',
        productId: 1,
        minOrderAmount: 100.0,
      );

      final json = request.toJson();

      expect(json['code'], 'FLAT60');
      expect(json['discountType'], 'AMOUNT');
      expect(json['discount'], 60.0);
      expect(json['availableQuantity'], 30);
      expect(json['expiryDate'], '2025-06-30T23:59:59');
      expect(json['productId'], 1);
      expect(json['minOrderAmount'], 100.0);
      expect(json['isActive'], true);
      expect(json.containsKey('maxDiscount'), false);
      expect(json.containsKey('fixedPrice'), false);
    });
  });
}
