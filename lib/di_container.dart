import 'package:aichat/provider/CategoryController.dart';
import 'package:aichat/View/Screens/stores/AIChatStore.dart';
import 'package:aichat/provider/SubscriptionProvider.dart';
import 'package:aichat/provider/ProfileProvider.dart';
import 'package:aichat/provider/theme_provider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

GetIt sl = GetIt.instance;

Future<void> init() async {
  // Core
  // sl.registerLazySingleton(() => NetworkInfo(sl()));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => Connectivity());
  sl.registerFactory(() => ThemeProvider(sharedPreferences: sharedPreferences));
  sl.registerFactory(() => SubscriptionPlanProvider());
  sl.registerFactory(() => ProfileProvider());
  sl.registerFactory(() => AIChatStore());
  sl.registerFactory(() => CategoryController());
}
