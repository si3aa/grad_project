import 'package:flutter/material.dart';

/// A text field for entering the product description.
class DescriptionField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const DescriptionField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Product Description',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        prefixIcon: const Icon(Icons.description),
        alignLabelWithHint: true,
      ),
      maxLines: 3,
      validator: (value) =>
          value == null || value.isEmpty ? 'Please enter product description' : null,
      onChanged: onChanged,
    );
  }
}