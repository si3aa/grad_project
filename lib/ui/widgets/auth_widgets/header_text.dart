import 'package:flutter/material.dart';
import 'package:Herfa/constants.dart';

class HeaderTitle extends StatelessWidget {
  final String title;
  const HeaderTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Image.asset(
            'assets/images/chevron-left.png',
          ),
        ),
     SizedBox(width: 75),
        Text(
          title,
          style: TextStyle(
              fontSize: 40,
              color: kPrimaryColor,
              decoration: TextDecoration.underline,
              decorationColor: kPrimaryColor,
              decorationThickness: 2),
        ),
        const Spacer(),
      ],
    );
  }
}
