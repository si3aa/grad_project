import 'package:Herfa/core/route_manger/routes.dart';
import 'package:Herfa/features/auth/views/screens/forget_pass.dart';
import 'package:Herfa/features/auth/views/screens/guest.dart';
import 'package:Herfa/features/auth/views/screens/login_screen.dart';
import 'package:Herfa/features/auth/views/screens/reset_pass.dart';
import 'package:Herfa/features/auth/views/screens/register_screen.dart';
import 'package:Herfa/features/auth/views/screens/splash.dart';
import 'package:Herfa/features/auth/views/screens/success_screen.dart';
import 'package:Herfa/features/auth/views/screens/verify_otp_screen.dart';
import 'package:Herfa/features/auth/views/screens/welcom.dart';
import 'package:Herfa/ui/screens/home/cart_screen.dart';
import 'package:Herfa/ui/screens/home/events_screen.dart';
import 'package:Herfa/ui/screens/home/home_screen.dart';
import 'package:Herfa/ui/screens/home/new_post_screen.dart';
import 'package:Herfa/ui/screens/home/notification_sc.dart';
import 'package:Herfa/ui/screens/home/saved_screen.dart';
import 'package:Herfa/features/profile/views/screens/edit_profile_screen.dart';

import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    final arguments = settings.arguments as Map<String, dynamic>?;

    switch (settings.name) {
      case Routes.splashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case Routes.welcomeRoute:
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());
      case Routes.guestRoute:
        return MaterialPageRoute(builder: (_) => const GuestScreen());
      case Routes.signUpRoute:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case Routes.loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case Routes.forgetPassRoute:
        return MaterialPageRoute(builder: (_) => const ForgetPass());
      case Routes.homeRoute:
        final token = arguments?['token'] as String?;
        return MaterialPageRoute(builder: (_) => HomeScreen(token: token));
      case Routes.verifyRoute:
        return MaterialPageRoute(
          builder: (_) => VerifyOTPScreen.fromArguments(arguments ?? {}),
        );
      case Routes.resetPassRoute:
        return MaterialPageRoute(builder: (_) => const ResetPass());
      case Routes.successRoute:
        return MaterialPageRoute(
          builder: (_) => SuccessScreen(
            title: arguments?['title'] as String? ?? 'Success',
          ),
        );
      case Routes.notificationRoute:
        return MaterialPageRoute(builder: (_) => const NotificationScreen());
      case Routes.newPostRoute:
        return MaterialPageRoute(builder: (_) => const NewPostScreen());
      case Routes.savedRoute:
        return MaterialPageRoute(builder: (_) => const SavedScreen());
      case Routes.eventsRoute:
        return MaterialPageRoute(builder: (_) => const EventsScreen());
      case Routes.cartRoute:
        return MaterialPageRoute(builder: (_) => const CartScreen());
      case Routes.profileRoute:
        final token = arguments?['token'] as String?;
        if (token != null) {
          return MaterialPageRoute(
            builder: (_) => EditProfileScreen(token: token),
          );
        } else {
          return _undefinedRoute();
        }
      default:
        return _undefinedRoute();
    }
  }

  static Route<dynamic> _undefinedRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('No Route Found'),
        ),
        body: const Center(child: Text('No Route Found')),
      ),
    );
  }
}
