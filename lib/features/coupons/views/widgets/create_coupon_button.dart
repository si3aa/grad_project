import 'package:flutter/material.dart';
import 'package:Herfa/core/constants/colors.dart';
import 'package:Herfa/features/coupons/views/screens/create_coupon_screen.dart';

class CreateCouponButton extends StatelessWidget {
  final int productId;
  final String productName;
  final VoidCallback? onCouponCreated;

  const CreateCouponButton({
    Key? key,
    required this.productId,
    required this.productName,
    this.onCouponCreated,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => _navigateToCreateCoupon(context),
      icon: const Icon(Icons.local_offer, color: Colors.white),
      label: const Text(
        'Create Coupon',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  void _navigateToCreateCoupon(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateCouponScreen(
          productId: productId,
          productName: productName,
        ),
      ),
    );

    // Callback when coupon is created successfully
    if (result == true && onCouponCreated != null) {
      onCouponCreated!();
    }
  }
}
