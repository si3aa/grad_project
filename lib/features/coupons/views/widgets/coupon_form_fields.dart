import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CouponFormFields extends StatelessWidget {
  final String selectedDiscountType;
  final TextEditingController codeController;
  final TextEditingController discountController;
  final TextEditingController maxDiscountController;
  final TextEditingController fixedPriceController;
  final TextEditingController quantityController;
  final TextEditingController minOrderAmountController;

  const CouponFormFields({
    Key? key,
    required this.selectedDiscountType,
    required this.codeController,
    required this.discountController,
    required this.maxDiscountController,
    required this.fixedPriceController,
    required this.quantityController,
    required this.minOrderAmountController,
  }) : super(key: key);

  final Color kBrandColor = const Color(0xFF7C5CFC);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Coupon Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        _buildTextField(
          controller: codeController,
          label: 'Coupon Code',
          hint: 'e.g., SALE20',
          icon: Icons.qr_code_scanner,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a coupon code';
            }
            if (value.trim().length < 3) {
              return 'Coupon code must be at least 3 characters';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: quantityController,
          label: 'Available Quantity',
          hint: 'e.g., 100',
          icon: Icons.inventory_2_outlined,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter available quantity';
            }
            final quantity = int.tryParse(value);
            if (quantity == null || quantity <= 0) {
              return 'Please enter a valid quantity';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        ..._buildDynamicFields(),
      ],
    );
  }

  List<Widget> _buildDynamicFields() {
    switch (selectedDiscountType) {
      case 'PERCENTAGE':
        return [
          _buildTextField(
            controller: discountController,
            label: 'Discount Percentage',
            hint: 'e.g., 20',
            icon: Icons.percent,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            suffixText: '%',
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter discount percentage';
              }
              final discount = double.tryParse(value);
              if (discount == null || discount <= 0 || discount > 100) {
                return 'Please enter a valid percentage (1-100)';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: maxDiscountController,
            label: 'Maximum Discount (Optional)',
            hint: 'e.g., 100',
            icon: Icons.money_off,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            suffixText: 'EGP',
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: minOrderAmountController,
            label: 'Minimum Order Amount (Optional)',
            hint: 'e.g., 200',
            icon: Icons.shopping_cart_checkout,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            suffixText: 'EGP',
          ),
        ];
      case 'FIXED_PRICE':
        return [
          _buildTextField(
            controller: fixedPriceController,
            label: 'Fixed Price',
            hint: 'e.g., 299',
            icon: Icons.sell_outlined,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            suffixText: 'EGP',
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter fixed price';
              }
              final price = double.tryParse(value);
              if (price == null || price <= 0) {
                return 'Please enter a valid price';
              }
              return null;
            },
          ),
        ];
      case 'AMOUNT':
        return [
          _buildTextField(
            controller: discountController,
            label: 'Discount Amount',
            hint: 'e.g., 60',
            icon: Icons.local_atm_outlined,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            suffixText: 'EGP',
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter discount amount';
              }
              final amount = double.tryParse(value);
              if (amount == null || amount <= 0) {
                return 'Please enter a valid amount';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: minOrderAmountController,
            label: 'Minimum Order Amount (Optional)',
            hint: 'e.g., 100',
            icon: Icons.shopping_cart_checkout,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            suffixText: 'EGP',
          ),
        ];
      default:
        return [];
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    IconData? icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? suffixText,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: icon != null ? Icon(icon, color: kBrandColor) : null,
        suffixText: suffixText,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: kBrandColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }
}
