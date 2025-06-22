import 'package:Herfa/ui/widgets/auth_widgets/label_text_field.dart';
import 'package:Herfa/ui/widgets/auth_widgets/submit_button.dart';
import 'package:Herfa/ui/widgets/auth_widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:Herfa/constants.dart';
import 'package:Herfa/core/widgets/back_to_home_button.dart';

class ResetPass extends StatefulWidget {
  const ResetPass({super.key});

  @override
  State<ResetPass> createState() => _ResetPassState();
}

class _ResetPassState extends State<ResetPass> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackToHomeButton(),
        title: Text(
          "Reset Password",
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
            child: Column(children: [
              SizedBox(height: size.height * 0.05),
              Image.asset("assets/images/update_pass.png",
                  height: size.height * 0.25),
              const SizedBox(height: 20),
              const Text(
                "Reset your password",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Here’s a tip: Use a combination of Numbers, Uppercase, lowercase and Special characters",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              const SizedBox(height: 20),
              LabelText(labelText: "Password", state: 'Required'),
              const SizedBox(height: 10),
              CustomTextField(
                controller: _passwordController,
                label: "Password",
                hintText: "Enter your password",
                icon: Icons.lock,
                isPassword: true,
              ),
              const SizedBox(height: 10),
              LabelText(labelText: "Confirm Password", state: 'Required'),
              const SizedBox(height: 10),
              CustomTextField(
                controller: _confirmPasswordController,
                label: "Confirm Password",
                hintText: "Enter your password",
                icon: Icons.lock,
                isPassword: true,
              ),
              const SizedBox(height: 10),
              CustomButton(
                text: "Reset",
                
                onPressed: () => {
                  Navigator.pushReplacementNamed(context, '/success'),
                },
              ),
              const SizedBox(height: 10),
            ]),
          ),
        ),
      ),
    );
  }
   @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
