import 'package:gorider/core/utils/exports.dart';

class AppNavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      AppNavigationController(),
      permanent: true,
    );
    Get.put(
      DashboardController(),
      permanent: true,
    );
    // Initialize SettingsController first as it's a dependency for DeliveriesController
    Get.put(
      SettingsController(),
      permanent: true,
    );
    Get.put(
      DeliveriesController(),
      permanent: true,
    );
    Get.put(
      WalletController(),
      permanent: true,
    );
    Get.put(
      NotificationsController(),
      permanent: true,
    );
  }
}
