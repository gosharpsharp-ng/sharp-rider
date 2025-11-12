import 'package:gorider/core/utils/exports.dart';
import 'package:gorider/modules/payouts/controllers/payout_controller.dart';

class PayoutBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(
      PayoutController(),
    );
  }
}