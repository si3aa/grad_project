import 'package:flutter/material.dart';

/// A text field for entering the product quantity.
class QuantityField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<int> onChanged;

  const QuantityField({
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
        labelText: 'Quantity',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        prefixIcon: const Icon(Icons.inventory),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please enter quantity';
        if (int.tryParse(value) == null) return 'Please enter a valid number';
        return null;
      },
      onChanged: (value) => onChanged(int.tryParse(value) ?? 0),
    );
  }
}