import 'dart:developer';

import 'package:Herfa/core/route_manger/routes.dart';
import 'package:Herfa/core/utils/ui_utils.dart';
import 'package:Herfa/features/auth/data/models/login_request.dart';
import 'package:Herfa/features/auth/viewmodel/cubit/auth_cubit.dart';
import 'package:Herfa/ui/widgets/auth_widgets/header_container.dart';
import 'package:Herfa/ui/widgets/auth_widgets/header_text.dart';
import 'package:Herfa/ui/widgets/auth_widgets/label_text_field.dart';
import 'package:Herfa/ui/widgets/auth_widgets/submit_button.dart';
import 'package:Herfa/ui/widgets/auth_widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:Herfa/constants.dart';
import 'package:Herfa/core/utils/validator.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
                child: Form(
                  key: _formKey,
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
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(
                                      context,
                                      Routes.signUpRoute,
                                    );
                                  },
                                ),
                                HeaderButton(
                                  text: 'Sign in',
                                  buttonColor: kPrimaryColor,
                                  textColor: Colors.white,
                                  onPressed: () {},
                                ),
                                HeaderButton(
                                  text: 'Guest',
                                  textColor: kPrimaryColor,
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      Routes.guestRoute,
                                    );
                                  },
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
                            LabelText(labelText: "Username", state: 'Required'),
                            const SizedBox(height: 10),
                            CustomTextField(
                              controller: _usernameController,
                              label: "Username",
                              hintText: "Enter your username",
                              icon: Icons.person,
                              isPassword: false,
                              validator: Validator.validateUsername,
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
                              validator: Validator.validatePassword,
                            ),
                            const SizedBox(height: 30),
                            BlocListener<AuthCubit, AuthState>(
                              listener: (context, state) {
                                if (state is AuthLoading) {
                                  UiUtils.showLoading(context);
                                }
                                if (state is AuthSuccess) {
                                  UiUtils.hideLoading(context);
                                  Navigator.pushNamed(
                                    context,
                                    Routes.homeRoute,
                                  );

                                  _usernameController.clear();
                                  _passwordController.clear();
                                } else if (state is AuthError) {
                                  UiUtils.hideLoading(context);
                                  UiUtils.showMessage(state.errorMessage);
                                  log(state.errorMessage);
                                }
                              },
                              child: CustomButton(
                                text: "Login",
                                onPressed: () {
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    final request = LoginRequest(
                                      username: _usernameController.text,
                                      password: _passwordController.text,
                                    );
                                    context.read<AuthCubit>().login(request);
                                  }
                                },
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, Routes.forgetPassRoute);
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
          ),
        ],
      ),
    );
  }
}
