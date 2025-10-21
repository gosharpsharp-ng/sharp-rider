import 'package:gorider/core/utils/exports.dart';
import '../controllers/payout_controller.dart';

class PayoutBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PayoutController>(() => PayoutController());
  }
}
