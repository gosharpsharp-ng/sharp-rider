
import 'package:go_logistics_driver/utils/exports.dart';

class WithdrawalBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WithdrawalController>(
          () => WithdrawalController(),
    );
  }
}
