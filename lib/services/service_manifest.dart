
import 'package:go_logistics_driver/utils/exports.dart';

GetIt serviceLocator = GetIt.instance;

void setupServiceLocator() {
  serviceLocator.registerLazySingleton<AuthenticationService>(() => AuthenticationService());
  serviceLocator.registerLazySingleton<ProfileService>(() => ProfileService());

  // serviceLocator.registerLazySingleton<User>(() => UserImpl());
}