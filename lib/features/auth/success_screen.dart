import 'package:Herfa/ui/widgets/auth_widgets/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:Herfa/constants.dart';

class SuccessScreen extends StatelessWidget {
  final String title;
  const SuccessScreen({super.key, this.title = 'Reset Success'});

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
          'Success',
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
          Text(
            title,
            textAlign: TextAlign.center,
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
              Navigator.pushReplacementNamed(context, '/login'),
            },
          ),
          const Spacer(),
        ]),
      ),
    );
  }
}
