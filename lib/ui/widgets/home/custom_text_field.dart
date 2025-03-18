import 'package:flutter/material.dart';

class HomeCustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final Function(String)? onChanged;
  final TextInputType keyboardType;
  final int maxLines;

  const HomeCustomTextField({
    super.key,
    required this.label,
    required this.controller,
    this.onChanged,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        TextFormField(
          controller: controller,
          onChanged: onChanged,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
