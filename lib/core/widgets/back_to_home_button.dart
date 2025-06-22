import 'package:flutter/material.dart';
import 'package:Herfa/core/route_manger/routes.dart';

/// A reusable back arrow button that always navigates to the home screen.
class BackToHomeButton extends StatelessWidget {
  const BackToHomeButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.of(context).pushNamedAndRemoveUntil(
          Routes.homeRoute,
          (route) => false,
        );
      },
    );
  }
}
