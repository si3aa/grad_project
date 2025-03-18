import 'package:Herfa/ui/screens/auth/forget_pass.dart';
import 'package:Herfa/ui/screens/auth/guest.dart';
import 'package:Herfa/ui/screens/auth/login_page.dart';
import 'package:Herfa/ui/screens/auth/reset_pass.dart';
import 'package:Herfa/ui/screens/auth/sign_up.dart';
import 'package:Herfa/ui/screens/auth/splash.dart';
import 'package:Herfa/ui/screens/auth/success_screen.dart';
import 'package:Herfa/ui/screens/auth/verify_pass.dart';
import 'package:Herfa/ui/screens/auth/welcom.dart';
import 'package:Herfa/ui/screens/home/events_screen.dart';
import 'package:Herfa/ui/screens/home/home_screen.dart';
import 'package:Herfa/ui/screens/home/new_post_screen.dart';
import 'package:Herfa/ui/screens/home/notification_sc.dart';
import 'package:Herfa/ui/screens/home/saved_screen.dart';
import 'package:flutter/material.dart';

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
    '/notifications': (context) => const NotificationScreen(),
    '/saved': (context) => const SavedScreen(),
    '/new-post': (context) => const NewPostScreen(),
    '/events': (context) => const EventsScreen(),
  };
}
