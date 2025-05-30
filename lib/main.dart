import 'package:Herfa/ui/provider/cubit/cart_cubit.dart';
import 'package:Herfa/ui/provider/cubit/content_cubit.dart';
import 'package:Herfa/ui/provider/cubit/event_cubit.dart';
import 'package:Herfa/ui/provider/cubit/home_cubit.dart';
import 'package:Herfa/ui/provider/cubit/notification_cubit.dart';
import 'package:Herfa/features/get_product/viewmodels/product_cubit.dart';
import 'package:Herfa/ui/provider/cubit/search_cubit.dart';

import 'package:Herfa/features/add_new_product/viewmodels/cubit/new_post_viewmodel.dart';
import 'package:Herfa/features/saved_products/viewmodels/cubit/saved_product_cubit.dart';
import 'package:Herfa/core/route_manger/routes.dart';
import 'package:Herfa/core/route_manger/route_generator.dart';
import 'package:Herfa/core/app_bloc_observer.dart';
import 'package:Herfa/features/auth/viewmodel/cubit/auth_cubit.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set bloc observer
  Bloc.observer = AppBlocObserver();
  LogInterceptor(
      responseBody: true,
      error: true,
      requestHeader: true,
      responseHeader: true,
      request: true,
      requestBody: true);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => HomeCubit()),
        BlocProvider(create: (_) => ContentCubit()),
        BlocProvider(create: (_) => NotificationCubit()),
        BlocProvider(create: (_) => SearchCubit()),
        BlocProvider(create: (_) => NewPostCubit()),
        BlocProvider(create: (_) => EventsCubit()),
        BlocProvider(create: (_) => CartCubit()),
        BlocProvider(create: (_) => ProductCubit()),
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(
            create: (_) =>
                SavedProductCubit()..fetchSavedProductsWithDetails()),
      ],
      child: const Herfa(),
    ),
  );
}

class Herfa extends StatelessWidget {
  const Herfa({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: RouteGenerator.getRoute,
        initialRoute: Routes.splashScreen,
      ),
    );
  }
}
