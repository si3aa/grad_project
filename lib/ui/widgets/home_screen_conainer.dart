import 'package:flutter/material.dart';
import 'package:Herfa/constants.dart';
import 'package:Herfa/ui/widgets/action_button.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      padding: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: Color(0xFF9999D2).withOpacity(0.7),
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ActionButton(
            text: 'Sign up',
            route: '/signUp',
            textColor: kPrimaryColor,
          ),
          ActionButton(
            text: 'Guest',
            route: '/guest',
            textColor: kPrimaryColor,
          ),
          ActionButton(
            text: 'Sign in',
            route: '/login',
            textColor: kPrimaryColor,
          ),
        ],
      ),
    );
  }
}
