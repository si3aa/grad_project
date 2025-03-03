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

class VerifyCodeController extends ChangeNotifier {
  final int otpLength = 6;
  List<TextEditingController> otpControllers = [];
  List<FocusNode> focusNodes = [];
  int countdown = 30;
  bool isOtpFilled = false;

  VerifyCodeController() {
    _initializeControllers();
    _startCountdown();
  }

  void _initializeControllers() {
    otpControllers = List.generate(otpLength, (_) => TextEditingController());
    focusNodes = List.generate(otpLength, (_) => FocusNode());

    for (int i = 0; i < otpLength; i++) {
      otpControllers[i].addListener(() => _checkOtpFilled());
    }
  }

  void _checkOtpFilled() {
    isOtpFilled = otpControllers.every((c) => c.text.isNotEmpty);
    notifyListeners();
  }

  void onOtpChanged(String value, int index) {
    if (value.isNotEmpty && index < otpLength - 1) {
      FocusScope.of(focusNodes[index].context!)
          .requestFocus(focusNodes[index + 1]);
    }
    notifyListeners();
  }

  void onOtpBackspace(int index) {
    if (otpControllers[index].text.isEmpty && index > 0) {
      FocusScope.of(focusNodes[index].context!)
          .requestFocus(focusNodes[index - 1]);
    }
    notifyListeners();
  }

  void _startCountdown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (countdown > 0) {
        countdown--;
        notifyListeners();
        _startCountdown();
      }
    });
  }

  void resendOtp() {
    countdown = 30;
    notifyListeners();
    _startCountdown();
  }

  void submitOtp() {
    // ignore: unused_local_variable
    String otpCode = otpControllers.map((c) => c.text).join();
    // print("OTP Submitted: $otpCode");
  }

  @override
  void dispose() {
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void clearOtp() {
    for (var controller in otpControllers) {
      controller.clear();
    }
    isOtpFilled = false;
    notifyListeners();
    if (focusNodes.isNotEmpty) {
      FocusScope.of(focusNodes[0].context!).requestFocus(focusNodes[0]);
    }
  }
}
