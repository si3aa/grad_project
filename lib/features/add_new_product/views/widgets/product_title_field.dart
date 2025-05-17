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
        helperText: 'Must be at least 10 characters',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter product title';
        }
        if (value.length < 10) {
          return 'Title must be at least 10 characters';
        }
        return null;
      },
      onChanged: onChanged,
    );
  }
}
