import 'package:flutter/material.dart';

/// A text field for entering the product price.
class PriceField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<double> onChanged;

  const PriceField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Price',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        prefixIcon: const Icon(Icons.attach_money),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please enter price';
        if (double.tryParse(value) == null) return 'Please enter a valid number';
        return null;
      },
      onChanged: (value) => onChanged(double.tryParse(value) ?? 0),
    );
  }
}