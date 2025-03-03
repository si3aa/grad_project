import 'package:flutter/material.dart';
import 'package:Herfa/ui/screens/forget_pass.dart';
import 'package:Herfa/ui/screens/guest.dart';
import 'package:Herfa/ui/screens/home_screen.dart';
import 'package:Herfa/ui/screens/login_page.dart';
import 'package:Herfa/ui/screens/reset_pass.dart';
import 'package:Herfa/ui/screens/sign_up.dart';
import 'package:Herfa/ui/screens/splash.dart';
import 'package:Herfa/ui/screens/success_screen.dart';
import 'package:Herfa/ui/screens/verify_pass.dart';
import 'package:Herfa/ui/screens/welcom.dart';

class NavigationController {
  static Map<String, Widget Function(BuildContext)> routes = {
    '/': (context) => const SplashScreen(),
    '/welcome': (context) => const WelcomeScreen(),
    '/guest': (context) => const GuestScreen(),
    '/login': (context) => const LoginPage(),
    '/signUp': (context) => const SignUp(),
    '/forget': (context) => const ForgetPass(),
    '/home': (context) => const HomeScreen(),
    '/verify': (context) => const VerifyCodeScreen(),
    '/reset_pass': (context) => const ResetPass(),
    '/success': (context) => const SuccessScreen(),
  };
}
