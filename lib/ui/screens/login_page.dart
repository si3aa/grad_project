import 'package:flutter/material.dart';
import 'package:Herfa/constants.dart';
import 'package:Herfa/ui/provider/controller.dart';
import 'package:Herfa/ui/widgets/header_container.dart';
import 'package:Herfa/ui/widgets/header_text.dart';
import 'package:Herfa/ui/widgets/label_text_field.dart';
import 'package:Herfa/ui/widgets/submit_button.dart';
import 'package:Herfa/ui/widgets/text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginController _controller = LoginController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: backgroundImage),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    HeaderTitle(
                      title: 'LOGIN',
                    ),
                    const SizedBox(height: 80),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        // ignore: deprecated_member_use
                        color: Color(0x0fffffff).withOpacity(0.4),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              HeaderButton(
                                text: 'Sign up',
                                textColor: kPrimaryColor,
                              ),
                              HeaderButton(
                                text: 'Sign in',
                                buttonColor: kPrimaryColor,
                                textColor: Colors.white,
                              ),
                              HeaderButton(
                                text: 'Guest',
                                textColor: kPrimaryColor,
                              ),
                            ],
                          ),
                          Text(
                            "Sign in to your account",
                            style: TextStyle(
                              fontSize: screenWidth * 0.060,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 20),
                          LabelText(labelText: "Email", state: 'Required'),
                          const SizedBox(height: 10),
                          CustomTextField(
                            controller: _controller.emailController,
                            label: "Email",
                            hintText: "Enter your email",
                            icon: Icons.email,
                            isPassword: false,
                          ),
                          const SizedBox(height: 20),
                          LabelText(labelText: "Password", state: 'Required'),
                          const SizedBox(height: 10),
                          CustomTextField(
                            controller: _controller.passwordController,
                            label: "Password",
                            hintText: "Enter your password",
                            icon: Icons.lock,
                            isPassword: true,
                          ),
                          const SizedBox(height: 30),
                          CustomButton(
                              text: "Login",
                              loginController: _controller,
                              onPressed: () => {
                                    Navigator.pushNamed(context, '/home'),
                                  }),
                          const SizedBox(height: 10),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/forget');
                            },
                            child: Text(
                              "Forget password ?",
                              style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: screenWidth * 0.05,
                                decoration: TextDecoration.underline,
                                decorationColor: kPrimaryColor,
                                decorationThickness: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
