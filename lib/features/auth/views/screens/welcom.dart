import 'package:Herfa/features/auth/views/widgets/home_screen_conainer.dart';
import 'package:flutter/material.dart';
import 'package:Herfa/constants.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image:
                AssetImage("assets/images/background.jpg"), // Your image path
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Text(
              '" Welcome! "',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.w900,
                color: kPrimaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 60),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Text(
                'You can browse as a Guest to explore our handmade and craft products, but some features may require an account.',
                style: TextStyle(fontSize: 20, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 60),
            HomeHeader(),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
