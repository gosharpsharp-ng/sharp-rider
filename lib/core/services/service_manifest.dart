import 'package:gorider/core/services/courier/courier_type_service.dart';
import 'package:gorider/core/utils/exports.dart';

GetIt serviceLocator = GetIt.instance;

void setupServiceLocator() {
  serviceLocator.registerLazySingleton<AuthenticationService>(
      () => AuthenticationService());
  serviceLocator.registerLazySingleton<ProfileService>(() => ProfileService());
  serviceLocator
      .registerLazySingleton<DeliveryService>(() => DeliveryService());
  serviceLocator
      .registerLazySingleton<CourierTypeService>(() => CourierTypeService());
  serviceLocator.registerLazySingleton<WalletsService>(() => WalletsService());

  // serviceLocator.registerLazySingleton<User>(() => UserImpl());
}
