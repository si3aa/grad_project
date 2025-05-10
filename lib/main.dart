import 'package:Herfa/ui/provider/controller.dart';
import 'package:Herfa/ui/provider/cubit/cart_cubit.dart';
import 'package:Herfa/ui/provider/cubit/content_cubit.dart';
import 'package:Herfa/ui/provider/cubit/event_cubit.dart';
import 'package:Herfa/ui/provider/cubit/home_cubit.dart';
import 'package:Herfa/ui/provider/cubit/new_post_cubit.dart';
import 'package:Herfa/ui/provider/cubit/notification_cubit.dart';
import 'package:Herfa/ui/screens/home/prduct/viewmodels/product_cubit.dart';
import 'package:Herfa/ui/provider/cubit/saved_cubit.dart';
import 'package:Herfa/ui/provider/cubit/search_cubit.dart';
import 'package:Herfa/ui/widgets/auth_widgets/navigation.dart';
import 'package:flutter/material.dart';
import 'package:Herfa/core/di/di.dart' as di;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

void main() {
  di.setupDependencies();
  runApp(
    MultiBlocProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ForgetPasswordController()),
        ChangeNotifierProvider(create: (context) => VerifyCodeController()),
        BlocProvider(create: (_) => di.sl<HomeCubit>()),
        BlocProvider(create: (_) => di.sl<ContentCubit>()),
        BlocProvider(create: (_) => di.sl<NotificationCubit>()),
        BlocProvider(create: (_) => di.sl<SavedCubit>()),
        BlocProvider(create: (_) => di.sl<SearchCubit>()),
        BlocProvider(create: (_) => di.sl<NewPostCubit>()),
        BlocProvider(create: (_) => di.sl<EventsCubit>()),
        BlocProvider(create: (_) => di.sl<CartCubit>()),
        BlocProvider(create: (_) => di.sl<ProductCubit>())
      ],
      child: const Herfa(),
    ),
  );
}

class Herfa extends StatelessWidget {
  const Herfa({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: NavigationController.routes,
    );
  }
}
