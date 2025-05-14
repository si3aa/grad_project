import 'package:Herfa/constants.dart';
import 'package:Herfa/core/route_manger/routes.dart';
import 'package:Herfa/core/utils/ui_utils.dart';

import 'package:Herfa/features/auth/viewmodel/cubit/auth_cubit.dart';
import 'package:Herfa/features/auth/views/widgets/otp_input.dart';
import 'package:Herfa/features/auth/views/widgets/verify_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class VerifyOTPScreen extends StatefulWidget {
  final String email;
  final String? imagePath;
  final bool isNewAccount;

  const VerifyOTPScreen({
    super.key,
    required this.email,
    this.imagePath = 'assets/images/verify.png',
    this.isNewAccount = true,
  });

  factory VerifyOTPScreen.fromArguments(Map<String, dynamic> arguments) {
    return VerifyOTPScreen(
      email: arguments['email'] as String,
      isNewAccount: arguments['isNewAccount'] ?? true,
    );
  }

  @override
  State<VerifyOTPScreen> createState() => _VerifyOTPScreenState();
}

class _VerifyOTPScreenState extends State<VerifyOTPScreen> {
  final _otpController = TextEditingController();
  int _countdown = 60;
  bool _isOtpFilled = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
    _otpController.addListener(_checkOtpFilled);
  }

  void _startCountdown() {
    Future.delayed(Duration(seconds: 1), () {
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
        _startCountdown();
      }
    });
  }

  void _checkOtpFilled() {
    setState(() {
      _isOtpFilled = _otpController.text.length == 6;
    });
  }

  void _resendOtp() {
    setState(() {
      _countdown = 60;
      _otpController.clear();
      _isOtpFilled = false;
    });
    _startCountdown();
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

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
                Image.asset(widget.imagePath!, height: size.height * 0.25),
                const SizedBox(height: 20),
                const Text(
                  "Check your email",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  "We just sent an OTP to your registered email address",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                SizedBox(height: size.height * 0.02),
                OtpTextField(controller: _otpController),
                const SizedBox(height: 10),
                Text(
                  "00:${_countdown.toString().padLeft(2, '0')}s",
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    if (_countdown == 0) {
                      _resendOtp();
                    }
                  },
                  child: Text(
                    "Resend",
                    style: TextStyle(
                      color: _countdown == 0 ? Colors.black : Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                BlocListener<AuthCubit, AuthState>(
                  listener: (context, state) {
                        if (state is AuthLoading) {
                                  UiUtils.showLoading(context);
                                }
                    if (state is AuthSuccess) {
                       UiUtils.hideLoading(context);
                      if (widget.isNewAccount) {
                        Navigator.pushReplacementNamed(
                          context,
                          Routes.successRoute,
                          arguments: {
                            'title': 'Your Account was successfully Created!',
                          },
                        );
                      } else {
                        Navigator.pushReplacementNamed(
                          context,
                          Routes.resetPassRoute,
                        );
                      }
                      _otpController.clear();
                    } else if (state is AuthError) {
                      UiUtils.showMessage(state.errorMessage);
                      UiUtils.hideLoading(context);
                      }
                  },
                  child: SubmitButton(
                    text: "Verify OTP",
                    isEnabled: _isOtpFilled,
                    onPressed: _isOtpFilled
                        ? () {
                            context.read<AuthCubit>().verifyOtp(
                                  widget.email,
                                  _otpController.text,
                                );
                          }
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
