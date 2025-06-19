import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final String text;
  final String route;
  final Color buttonColor;
  final Color textColor;

  const ActionButton({
    super.key,
    required this.text,
    required this.route,
    this.buttonColor = Colors.white,
    required this.textColor,
  }); 

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
        decoration: BoxDecoration(
          color: buttonColor,
          shape: BoxShape.circle,
        ),
        child: Text(
          text,
          style: TextStyle(
              color: textColor, fontSize: 20.0, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
