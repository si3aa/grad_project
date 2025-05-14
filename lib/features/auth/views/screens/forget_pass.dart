import 'package:Herfa/features/auth/views/widgets/submit_button.dart';
import 'package:Herfa/features/auth/views/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:Herfa/constants.dart';

class ForgetPass extends StatefulWidget {
  const ForgetPass({super.key});

  @override
  State<ForgetPass> createState() => _ForgetPassState();
}

class _ForgetPassState extends State<ForgetPass> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _smsController = TextEditingController();
  @override
  Widget build(BuildContext context) {
   
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: kPrimaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Forget Password",
          style: TextStyle(
              color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 30),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: size.height * 0.05),
                    Image.asset(
                      "assets/images/forget_1.png",
                      height: size.height * 0.3,
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Select which contact details should we use to reset your password",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    SizedBox(height: 20),
                    CustomTextField(
                      controller: _emailController,
                      label: "Email",
                      hintText: "Enter your email",
                      icon: Icons.email,
                      isPassword: false,
                    ),
                    SizedBox(height: 10),
                    CustomTextField(
                      controller: _smsController,
                      label: "Phone Number",
                      hintText: "Enter your phone number",
                      icon: Icons.phone,
                      isPassword: false,
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 20),
                    CustomButton(
                      text: "Submit",
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/verify');
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
