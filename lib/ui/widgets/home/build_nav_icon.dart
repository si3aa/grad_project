import 'package:Herfa/constants.dart';
import 'package:flutter/material.dart';

class BuildNavIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final String route;
  final bool isSelected;
  final VoidCallback onTap;

  const BuildNavIcon({
    super.key,
    required this.icon,
    required this.label,
    required this.route,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
        Navigator.pushReplacementNamed(context, route);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()..scale(isSelected ? 1.2 : 1.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? kPrimaryColor : Colors.grey,
              size: isSelected ? 28 : 24,
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? kPrimaryColor : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
