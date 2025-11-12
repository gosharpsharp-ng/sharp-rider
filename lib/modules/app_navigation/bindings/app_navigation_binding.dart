import 'package:gorider/core/utils/exports.dart';

class AppNavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      AppNavigationController(),
    );
    Get.put(
      DashboardController(),
    );
    // Initialize SettingsController first as it's a dependency for DeliveriesController
    Get.put(
      SettingsController(),
    );
    Get.put(
      DeliveriesController(),
    );
    Get.put(
      WalletController(),
    );
    Get.put(
      NotificationsController(),
    );
  }
}
