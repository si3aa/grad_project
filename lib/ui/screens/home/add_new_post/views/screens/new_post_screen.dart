import 'package:Herfa/ui/screens/home/add_new_post/viewmodels/cubit/new_post_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Herfa/ui/screens/home/add_new_post/views/screens/new_post_view.dart';

class NewPostScreen extends StatelessWidget {
  const NewPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NewPostCubit(),
      child: const NewPostView(),
    );
  }
}