

import 'package:Herfa/core/route_manger/routes.dart';
import 'package:Herfa/features/add_new_product/views/screens/new_post_screen.dart';
import 'package:Herfa/features/auth/forget_pass.dart';
import 'package:Herfa/features/auth/guest.dart';
import 'package:Herfa/features/auth/reset_pass.dart';
import 'package:Herfa/features/auth/splash.dart';
import 'package:Herfa/features/auth/success_screen.dart';
import 'package:Herfa/features/auth/views/screens/login_screen.dart';
import 'package:Herfa/features/auth/views/screens/register_screen.dart';
import 'package:Herfa/features/auth/views/screens/verify_otp_screen.dart';
import 'package:Herfa/features/auth/welcom.dart';
import 'package:Herfa/features/get_product/views/widgets/product_class.dart';
import 'package:Herfa/features/get_product/views/product_detail_screen.dart';
import 'package:Herfa/ui/screens/home/views/cart_screen.dart';
import 'package:Herfa/ui/screens/home/views/events_screen.dart';
import 'package:Herfa/ui/screens/home/views/home_screen.dart';
import 'package:Herfa/ui/screens/home/views/notification_sc.dart';
import 'package:Herfa/ui/screens/home/views/saved_screen.dart';
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
        return MaterialPageRoute(builder: (_) => const HomeScreen());
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
      case Routes.productDetailRoute:
        final product = arguments?['product'] as Product?;
        if (product != null) {
          return MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product: product),
          );
        }
        return _undefinedRoute();
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
