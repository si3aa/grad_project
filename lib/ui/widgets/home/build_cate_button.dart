import 'package:Herfa/core/constants/colors.dart' as app_colors;
import 'package:flutter/material.dart';

class CategoryButton extends StatelessWidget {
  final String title;
  final String route;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool isBundle;

  const CategoryButton({
    super.key,
    required this.title,
    required this.route,
    this.isSelected = false,
    this.onTap,
    this.isBundle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          // ignore: deprecated_member_use
          backgroundColor: isBundle
              ? (isSelected ? Colors.white : app_colors.kSecondaryColor)
              : (isSelected ? Colors.black : app_colors.kPrimaryColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: onTap,
        child: Text(
          title,
          style: TextStyle(
              color: isBundle
                  ? (isSelected ? app_colors.kSecondaryColor : Colors.white)
                  : Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
