import 'package:flutter/material.dart';

/// A text field for entering the product description.
class DescriptionField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String? errorText;

  const DescriptionField({
    super.key,
    required this.controller,
    required this.onChanged,
    this.errorText,
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
        helperText: errorText == null ? 'Must be at least 20 characters' : null,
        errorText: errorText,
      ),
      maxLines: 3,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter product description';
        }
        if (value.length < 20) {
          return 'Description must be at least 20 characters';
        }
        return null;
      },
      onChanged: (value) {
        onChanged(value);
      },
    );
  }
}

