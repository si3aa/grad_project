import 'package:flutter/material.dart';

class HeaderButton extends StatelessWidget {
  final String text;
  final Color buttonColor;
  final Color textColor;
  final VoidCallback? onPressed; // Add onPressed callback

  const HeaderButton({
    super.key,
    required this.text,
    this.buttonColor = Colors.white,
    required this.textColor,
    this.onPressed, // Make onPressed optional
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed, // Handle tap events
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
        decoration: BoxDecoration(
          color: buttonColor,
          shape: BoxShape.circle,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}