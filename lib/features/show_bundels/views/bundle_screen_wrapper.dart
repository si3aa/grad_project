import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Herfa/features/show_bundels/data/bundle_repository.dart';
import 'package:Herfa/features/show_bundels/viewmodels/bundle_cubit.dart';
import 'package:Herfa/features/show_bundels/views/bundle_screen.dart';

class BundleScreenWrapper extends StatelessWidget {
  const BundleScreenWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BundleCubit(BundleRepository()),
      child: const BundleScreen(),
    );
  }
}
