import 'package:flutter/material.dart';

class LoginController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void login(BuildContext context) {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "Please Enter Email and Password",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            )),
      );
      return;
    }

    if (email == "mahmoud@gmail.com" && password == "123456") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Login Successful!",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Invalid Credentials",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
  }
}

class ForgetPasswordController extends ChangeNotifier {
  String selectedMethod = "email"; // Default selection

  TextEditingController emailController = TextEditingController();
  TextEditingController smsController = TextEditingController();
  void submit() {
    if (selectedMethod == "email" && emailController.text.isEmpty) {
      // print("Please enter an email");
    } else if (selectedMethod == "sms" && smsController.text.isEmpty) {
      // print("Please enter a phone number");
    } else {
      // print("Submitting via $selectedMethod: ${selectedMethod == 'email' ? emailController.text : smsController.text}");
    }
  }
}

