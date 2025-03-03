import 'package:flutter/material.dart';
import 'package:g_p/constants.dart';
import 'package:g_p/ui/provider/controller.dart';
import 'package:g_p/ui/screens/verify_pass.dart';
import 'package:g_p/ui/widgets/header_container.dart';
import 'package:g_p/ui/widgets/header_text.dart';
import 'package:g_p/ui/widgets/label_text_field.dart';
import 'package:g_p/ui/widgets/submit_button.dart';
import 'package:g_p/ui/widgets/text_field.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _nameController = TextEditingController();
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
                                text: 'Sign in',
                                textColor: kPrimaryColor,
                              ),
                              HeaderButton(
                                text: 'Sign up',
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
                            "Crate New Account",
                            style: TextStyle(
                              fontSize: screenWidth * 0.060,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 20),
                          LabelText(labelText: "Name", state: 'Required'),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              hintText: "Enter a temporary name",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
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
                            text: "Sign up",
                            loginController: _controller,
                            onPressed: () => {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VerifyCodeScreen(
                                    isNewAccount: false,
                                    imagePath: "assets/images/verify_big.png",
                                  ),
                                ),
                              ),
                            },
                          ),
                          const SizedBox(height: 10),
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
