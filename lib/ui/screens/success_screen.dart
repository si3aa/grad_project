import 'package:flutter/material.dart';
import 'package:g_p/constants.dart';
import 'package:g_p/ui/widgets/submit_button.dart';

class SuccessScreen extends StatelessWidget {
  final String title;
  const SuccessScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: kPrimaryColor, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Reset Success",
          style: TextStyle(
              color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 30),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
        child: Column(children: [
          SizedBox(height: size.height * 0.05),
          Image.asset("assets/images/sucess.png", height: size.height * 0.25),
          const Spacer(),
          const Text(
            "Reset successful !!",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          const Text(
            "You can now log in to your account👍",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
          const Spacer(),
          CustomButton(
            text: "Login Now",
            onPressed: () => {
              Navigator.pushNamed(context, '/login'),
            },
          ),
          const Spacer(),
        ]),
      ),
    );
  }
}
