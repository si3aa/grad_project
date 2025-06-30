import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Herfa/features/coupons/data/models/coupon_request.dart';
import 'package:Herfa/features/coupons/viewmodels/cubit/coupon_cubit.dart';
import 'package:Herfa/features/coupons/viewmodels/states/coupon_state.dart';
import 'package:Herfa/features/coupons/views/widgets/coupon_type_selector.dart';
import 'package:Herfa/features/coupons/views/widgets/coupon_form_fields.dart';

class CreateCouponScreen extends StatefulWidget {
  final int productId;
  final String productName;

  const CreateCouponScreen({
    Key? key,
    required this.productId,
    required this.productName,
  }) : super(key: key);

  @override
  State<CreateCouponScreen> createState() => _CreateCouponScreenState();
}

class _CreateCouponScreenState extends State<CreateCouponScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _discountController = TextEditingController();
  final _maxDiscountController = TextEditingController();
  final _fixedPriceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _minOrderAmountController = TextEditingController();

  String _selectedDiscountType = 'PERCENTAGE';
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 30));
  bool _isActive = true;

  // This color is from merchant profile screen, more vibrant
  final Color kBrandColor = const Color(0xFF7C5CFC);

  @override
  void dispose() {
    _codeController.dispose();
    _discountController.dispose();
    _maxDiscountController.dispose();
    _fixedPriceController.dispose();
    _quantityController.dispose();
    _minOrderAmountController.dispose();
    super.dispose();
  }

  void _createCoupon() {
    if (!_formKey.currentState!.validate()) return;

    CouponRequest request;

    switch (_selectedDiscountType) {
      case 'PERCENTAGE':
        request = CouponRequest.percentage(
          code: _codeController.text.trim(),
          discount: double.parse(_discountController.text),
          maxDiscount: _maxDiscountController.text.isNotEmpty
              ? double.parse(_maxDiscountController.text)
              : null,
          availableQuantity: int.parse(_quantityController.text),
          expiryDate: _selectedDate.toIso8601String(),
          productId: widget.productId,
          minOrderAmount: _minOrderAmountController.text.isNotEmpty
              ? double.parse(_minOrderAmountController.text)
              : null,
          isActive: _isActive,
        );
        break;

      case 'FIXED_PRICE':
        request = CouponRequest.fixedPrice(
          code: _codeController.text.trim(),
          fixedPrice: double.parse(_fixedPriceController.text),
          availableQuantity: int.parse(_quantityController.text),
          expiryDate: _selectedDate.toIso8601String(),
          productId: widget.productId,
          isActive: _isActive,
        );
        break;

      case 'AMOUNT':
        request = CouponRequest.amount(
          code: _codeController.text.trim(),
          discount: double.parse(_discountController.text),
          availableQuantity: int.parse(_quantityController.text),
          expiryDate: _selectedDate.toIso8601String(),
          productId: widget.productId,
          minOrderAmount: _minOrderAmountController.text.isNotEmpty
              ? double.parse(_minOrderAmountController.text)
              : null,
          isActive: _isActive,
        );
        break;

      default:
        return;
    }

    context.read<CouponCubit>().createCoupon(request);
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: kBrandColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Create New Coupon'),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocListener<CouponCubit, CouponState>(
        listener: (context, state) {
          if (state is CouponSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.response.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, true);
          } else if (state is CouponError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Info
                _buildProductInfoCard(),

                const SizedBox(height: 24),

                // Coupon Type Selector
                CouponTypeSelector(
                  selectedType: _selectedDiscountType,
                  onTypeChanged: (type) {
                    setState(() {
                      _selectedDiscountType = type;
                      // Clear fields when type changes
                      _discountController.clear();
                      _maxDiscountController.clear();
                      _fixedPriceController.clear();
                      _minOrderAmountController.clear();
                    });
                  },
                ),

                const SizedBox(height: 24),

                // Coupon Form Fields
                CouponFormFields(
                  selectedDiscountType: _selectedDiscountType,
                  codeController: _codeController,
                  discountController: _discountController,
                  maxDiscountController: _maxDiscountController,
                  fixedPriceController: _fixedPriceController,
                  quantityController: _quantityController,
                  minOrderAmountController: _minOrderAmountController,
                ),

                const SizedBox(height: 24),

                // Expiry Date
                _buildDateField(),

                const SizedBox(height: 16),

                // Active Toggle
                _buildActiveToggle(),

                const SizedBox(height: 32),

                // Create Button
                _buildCreateButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!)),
      child: Row(
        children: [
          Icon(Icons.inventory_2_outlined, color: kBrandColor, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Creating Coupon For:',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.productName,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Expiry Date',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _selectDate,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, color: kBrandColor),
                const SizedBox(width: 12),
                Text(
                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                const Icon(Icons.arrow_drop_down, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActiveToggle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.power_settings_new,
              color: _isActive ? kBrandColor : Colors.grey),
          const SizedBox(width: 12),
          const Text(
            'Coupon Active',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const Spacer(),
          Switch(
            value: _isActive,
            onChanged: (value) {
              setState(() {
                _isActive = value;
              });
            },
            activeColor: kBrandColor,
          ),
        ],
      ),
    );
  }

  Widget _buildCreateButton() {
    return BlocBuilder<CouponCubit, CouponState>(
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: state is CouponLoading ? null : _createCoupon,
            style: ElevatedButton.styleFrom(
                backgroundColor: kBrandColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
                shadowColor: kBrandColor.withOpacity(0.4)),
            child: state is CouponLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ))
                : const Text(
                    'Generate Coupon',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        );
      },
    );
  }
}
