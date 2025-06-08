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

import 'package:Herfa/features/saved_products/viewmodels/cubit/saved_product_cubit.dart';
import 'package:Herfa/features/saved_products/views/screens/saved_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A wrapper widget that provides the SavedProductCubit to the SavedScreen
/// This ensures that the SavedScreen always has access to the cubit it needs
class SavedScreenWrapper extends StatelessWidget {
  const SavedScreenWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SavedProductCubit(),
      child: const SavedScreen(),
    );
  }
}
