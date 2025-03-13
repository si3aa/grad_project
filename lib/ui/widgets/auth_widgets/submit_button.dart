import 'package:flutter/material.dart';
import 'package:Herfa/constants.dart';
import 'package:Herfa/ui/provider/controller.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final TextEditingController? controller;
  final LoginController? loginController;

  const CustomButton(
      {super.key,
      required this.text,
      required this.onPressed,
      this.controller,
      this.loginController});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: screenWidth * 0.8,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          controller?.clear();
          loginController?.emailController.clear();
          loginController?.passwordController.clear();
          onPressed();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.w900),
        ),
      ),
    );
  }
}
