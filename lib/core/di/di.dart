import 'package:Herfa/ui/provider/cubit/content_cubit.dart';
import 'package:Herfa/ui/provider/cubit/home_cubit.dart';
import 'package:Herfa/ui/provider/cubit/notification_cubit.dart';
import 'package:Herfa/ui/provider/cubit/saved_cubit.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

void setupDependencies() {
  sl.registerLazySingleton(() => HomeCubit());
  sl.registerLazySingleton(() => ContentCubit());
  sl.registerLazySingleton(() => NotificationCubit());
  sl.registerLazySingleton(() => SavedCubit());
}
