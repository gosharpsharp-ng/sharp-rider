import 'package:gorider/core/utils/exports.dart';

class PayoutBindings extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<PayoutController>()) {
      Get.put<PayoutController>(PayoutController(), permanent: true);
    }
  }
}