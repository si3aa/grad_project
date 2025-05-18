import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:Herfa/core/route_manger/routes.dart';
import 'dart:developer' as developer;

class HomeAppBar extends StatelessWidget {
  final String? token;
  final String? userName;

  const HomeAppBar({super.key, this.token, this.userName});

  @override
  Widget build(BuildContext context) {
    developer.log('HomeAppBar token: $token', name: 'HomeAppBar');
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            GestureDetector(
              onTap: () async {
                developer.log('Profile button tapped, token: $token',
                    name: 'HomeAppBar');
                if (token != null && token!.isNotEmpty) {
                  developer.log('Navigating to profile with token',
                      name: 'HomeAppBar');
                  Navigator.pushNamed(
                    context,
                    Routes.profileRoute,
                    arguments: {'token': token},
                  );
                } else {
                  developer.log('No token available for profile navigation',
                      name: 'HomeAppBar');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'You must be logged in to view your profile.')),
                  );
                }
              },
              child: Image.asset("assets/images/arrow-small-left.png"),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Welcome 👋",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                Text(
                  userName ?? "...",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Logout',
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('token');
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    Routes.loginRoute,
                    (route) => false,
                  );
                }
              },
            ),
          ],
        ),
      ),
      const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          "We have prepared new products for you",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    ]);
  }
}
