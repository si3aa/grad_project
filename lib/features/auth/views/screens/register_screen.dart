import 'dart:developer';

import 'package:Herfa/core/route_manger/routes.dart';
import 'package:Herfa/core/utils/ui_utils.dart';
import 'package:Herfa/features/auth/data/models/register_request.dart';
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

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _selectedRole; // 'USER' or 'MERCHANT'

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
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
                        title: 'REGISTER',
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
                                  buttonColor: kPrimaryColor,
                                  textColor: Colors.white,
                                  onPressed: () {},
                                ),
                                HeaderButton(
                                  text: 'Sign in',
                                  textColor: kPrimaryColor,
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(
                                      context,
                                      Routes.loginRoute,
                                    );
                                  },
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
                              "Create a new account",
                              style: TextStyle(
                                fontSize: screenWidth * 0.060,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 20),
                            LabelText(
                                labelText: "First Name", state: 'Required'),
                            const SizedBox(height: 10),
                            CustomTextField(
                              controller: _firstNameController,
                              label: "First Name",
                              hintText: "Enter your first name",
                              icon: Icons.person,
                              isPassword: false,
                              validator: Validator.validateFullName,
                            ),
                            const SizedBox(height: 20),
                            LabelText(
                                labelText: "Last Name", state: 'Required'),
                            const SizedBox(height: 10),
                            CustomTextField(
                              controller: _lastNameController,
                              label: "Last Name",
                              hintText: "Enter your last name",
                              icon: Icons.person,
                              isPassword: false,
                              validator: Validator.validateFullName,
                            ),
                            const SizedBox(height: 20),
                            LabelText(labelText: "Email", state: 'Required'),
                            const SizedBox(height: 10),
                            CustomTextField(
                              controller: _emailController,
                              label: "Email",
                              hintText: "Enter your email",
                              icon: Icons.email,
                              isPassword: false,
                              validator: Validator.validateEmail,
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
                            const SizedBox(height: 20),
                            Text(
                              "Choose account type:",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () =>
                                      setState(() => _selectedRole = 'USER'),
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: _selectedRole == 'USER'
                                          ? Colors.purple[100]
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: _selectedRole == 'USER'
                                            ? kPrimaryColor
                                            : Colors.grey,
                                        width: 2,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Icon(Icons.person, size: 32),
                                        Text("User"),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 24),
                                GestureDetector(
                                  onTap: () => setState(
                                      () => _selectedRole = 'MERCHANT'),
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: _selectedRole == 'MERCHANT'
                                          ? Colors.purple[100]
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: _selectedRole == 'MERCHANT'
                                            ? kPrimaryColor
                                            : Colors.grey,
                                        width: 2,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Icon(Icons.store, size: 32),
                                        Text("Seller"),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
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
                                    Routes.verifyRoute,
                                    arguments: {'email': _emailController.text},
                                  );
                                  _firstNameController.clear();
                                  _lastNameController.clear();
                                  _emailController.clear();
                                  _usernameController.clear();
                                  _passwordController.clear();
                                } else if (state is AuthError) {
                                  UiUtils.hideLoading(context);
                                  UiUtils.showMessage(state.errorMessage);
                                  log(state.errorMessage);
                                }
                              },
                              child: CustomButton(
                                text: "Register",
                                onPressed: () {
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    if (_selectedRole == null) {
                                      UiUtils.showMessage(
                                          'Please select an account type');
                                      return;
                                    }
                                    final request = RegisterRequest(
                                      firstName: _firstNameController.text,
                                      lastName: _lastNameController.text,
                                      email: _emailController.text,
                                      username: _usernameController.text,
                                      password: _passwordController.text,
                                      role: _selectedRole!,
                                    );
                                    context.read<AuthCubit>().register(request);
                                  }
                                },
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, Routes.loginRoute);
                              },
                              child: Text(
                                "Already have an account? Sign in",
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
