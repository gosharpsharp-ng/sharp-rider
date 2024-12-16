

import 'package:go_logistics_driver/utils/exports.dart';


class PasswordResetBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PasswordResetController>(
          () => PasswordResetController(),
    );
  }
}
