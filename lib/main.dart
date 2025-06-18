import 'package:Herfa/features/event/viewmodels/cubit/event_cubit.dart';
import 'package:Herfa/features/event/viewmodels/event_comment_cubit.dart';
import 'package:Herfa/features/event/data/repository/event_comment_repository.dart';
import 'package:Herfa/ui/provider/cubit/cart_cubit.dart';
import 'package:Herfa/ui/provider/cubit/content_cubit.dart';
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
import 'package:Herfa/features/event/data/repositories/event_repository.dart';
import 'package:Herfa/features/auth/data/data_source/local/auth_shared_pref_local_data_source.dart';
import 'package:Herfa/features/event_interest/data/repositories/event_interest_repository.dart';
import 'package:Herfa/features/event_interest/viewmodels/cubit/event_interest_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set bloc observer
  Bloc.observer = AppBlocObserver();
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://zygotic-marys-herfa-c2dd67a8.koyeb.app',
    ),
  );
  
  dio.interceptors.add(
    LogInterceptor(
      requestBody: true,
      responseBody: true,
      requestHeader: true,
      responseHeader: true,
      error: true,
      request: true,
      logPrint: (obj) => debugPrint(obj.toString()),
    ),
  );

  final authDataSource = AuthSharedPrefLocalDataSource();
  final eventRepository = EventRepository(
    dio: dio,
    authDataSource: authDataSource,
  );
  
  final eventInterestRepository = EventInterestRepository(
    dio: dio,
    authDataSource: authDataSource,
  );
  final eventCommentRepository = EventCommentRepository();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => HomeCubit()),
        BlocProvider(create: (_) => ContentCubit()),
        BlocProvider(create: (_) => NotificationCubit()),
        BlocProvider(create: (_) => SearchCubit()),
        BlocProvider(create: (_) => NewPostCubit()),
        BlocProvider(create: (_) => EventCubit(eventRepository)),
        BlocProvider(create: (_) => EventCommentCubit(eventCommentRepository)),
        BlocProvider(create: (_) => CartCubit()),
        BlocProvider(create: (_) => ProductCubit()),
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(
            create: (_) =>
                SavedProductCubit()..fetchSavedProductsWithDetails()),
        BlocProvider(
            create: (_) => EventInterestCubit(eventInterestRepository)),
        // SavedProductCubit is provided in the route generator for the SavedScreen
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
