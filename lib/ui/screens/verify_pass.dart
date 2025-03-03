import 'package:flutter/material.dart';
import 'package:g_p/constants.dart';
import 'package:g_p/ui/provider/controller.dart';
import 'package:g_p/ui/screens/success_screen.dart';
import 'package:g_p/ui/widgets/otp_input.dart';
import 'package:provider/provider.dart';
import '../widgets/verify_button.dart';

class VerifyCodeScreen extends StatelessWidget {
  final String? imagePath;
  final bool? isNewAccount;

  const VerifyCodeScreen({
    super.key,
    this.imagePath = 'assets/images/verify.png',
     this.isNewAccount =true,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<VerifyCodeController>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: kPrimaryColor, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Verify Code",
          style: TextStyle(
              color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 30),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
            child: Column(
              children: [
                SizedBox(height: size.height * 0.05),
                Image.asset(imagePath!, height: size.height * 0.25),
                const SizedBox(height: 20),
                const Text(
                  "Check your mail",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  "We just sent an OTP to your registered email address",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                SizedBox(height: size.height * 0.02),
                OtpTextField(controller: controller),
                const SizedBox(height: 10),
                Text(
                  "00:${controller.countdown}s",
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    if (controller.countdown == 0) {
                      controller.resendOtp();
                      controller.clearOtp();
                    }
                  },
                  child: Text(
                    "Resend",
                    style: TextStyle(
                      color: controller.countdown == 0
                          ? Colors.black
                          : Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SubmitButton(
                  text: "Verify OTP",
                  isEnabled: controller.isOtpFilled,
                  onPressed: controller.isOtpFilled
                      ? () {
                          controller.submitOtp();
                          if (isNewAccount!) {
                            Navigator.pushReplacementNamed(
                                context, '/reset_pass');
                          } else {
                             Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SuccessScreen(
                                    title: 'Your Account was successfully Created !',
                                  ),
                                ),
                              );
                          }
                          Provider.of<VerifyCodeController>(context,
                                  listen: false)
                              .clearOtp();
                        }
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
