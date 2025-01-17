

import '../../../utils/exports.dart';

class AppNavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      AppNavigationController(),
    );
    Get.put(
      DashboardController(),
    );
    Get.put(
      OrdersController(),
    );
    Get.put(
      WalletController(),
    );
    Get.put(
      SettingsController(),
    );
  }
}
