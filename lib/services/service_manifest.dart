
import 'package:go_logistics_driver/utils/exports.dart';

GetIt serviceLocator = GetIt.instance;

void setupServiceLocator() {
  serviceLocator.registerLazySingleton<AuthenticationService>(() => AuthenticationService());
  serviceLocator.registerLazySingleton<ProfileService>(() => ProfileService());
  serviceLocator.registerLazySingleton<ShipmentService>(() => ShipmentService());
  serviceLocator.registerLazySingleton<WalletsService>(() => WalletsService());

  // serviceLocator.registerLazySingleton<User>(() => UserImpl());
}