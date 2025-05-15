import 'package:flutter/material.dart';

/// A text field for entering the product title.
class ProductTitleField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const ProductTitleField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Product Title',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        prefixIcon: const Icon(Icons.title),
      ),
      validator: (value) =>
          value == null || value.isEmpty ? 'Please enter product title' : null,
      onChanged: onChanged,
    );
  }
}