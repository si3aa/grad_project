import 'package:flutter/material.dart';

/// A text field for entering the product name.
class ProductNameField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const ProductNameField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Product Name',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        prefixIcon: const Icon(Icons.shopping_bag_outlined),
      ),
      validator: (value) =>
          value == null || value.isEmpty ? 'Please enter product name' : null,
      onChanged: onChanged,
    );
  }
}