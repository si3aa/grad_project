import 'package:flutter/material.dart';
import 'package:Herfa/features/auth/data/data_source/local/auth_shared_pref_local_data_source.dart';
import 'package:Herfa/core/route_manger/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;
  final _authDataSource = AuthSharedPrefLocalDataSource();

  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0;
      });
    });
  }

  Future<void> _checkAuthAndNavigate() async {
    // Wait for the splash animation
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final token = await _authDataSource.getToken();
    if (token != null) {
      // User is already logged in, navigate to home
      Navigator.pushReplacementNamed(context, Routes.homeRoute);
    } else {
      // No token found, navigate to welcome screen
      Navigator.pushReplacementNamed(context, Routes.welcomeRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: const Duration(seconds: 3),
          child: Image.asset('assets/images/splash.png'),
        ),
      ),
    );
  }
}
