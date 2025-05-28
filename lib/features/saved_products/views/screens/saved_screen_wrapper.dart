import 'package:Herfa/features/saved_products/views/screens/saved_screen.dart';
import 'package:flutter/material.dart';

/// A wrapper widget for the SavedScreen
/// Since SavedProductCubit is now provided globally, this just returns the SavedScreen
class SavedScreenWrapper extends StatelessWidget {
  const SavedScreenWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SavedScreen();
  }
}
