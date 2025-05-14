
import 'package:Herfa/features/auth/guest.dart';
import 'package:Herfa/features/auth/reset_pass.dart';
import 'package:Herfa/features/auth/splash.dart';
import 'package:Herfa/features/auth/success_screen.dart';
import 'package:Herfa/features/auth/welcom.dart';
import 'package:Herfa/ui/screens/home/add_new_post/views/new_post_screen.dart';
import 'package:Herfa/ui/screens/home/views/cart_screen.dart';
import 'package:Herfa/ui/screens/home/views/events_screen.dart';
import 'package:Herfa/ui/screens/home/views/home_screen.dart';
import 'package:Herfa/ui/screens/home/views/notification_sc.dart';
import 'package:Herfa/ui/screens/home/views/saved_screen.dart';
import 'package:flutter/material.dart';

class NavigationController {
  static Map<String, Widget Function(BuildContext)> routes = {
    '/': (context) => const SplashScreen(),
    '/welcome': (context) => const WelcomeScreen(),
    '/guest': (context) => const GuestScreen(),
    '/home': (context) => const HomeScreen(),
    '/reset_pass': (context) => const ResetPass(),
    '/success': (context) => const SuccessScreen(),
    '/notifications': (context) => const NotificationScreen(),
    '/saved': (context) => const SavedScreen(),
    '/new-post': (context) => const NewPostScreen(),
    '/events': (context) => const EventsScreen(),
    '/cart': (context) => const CartScreen(),
  };
}
