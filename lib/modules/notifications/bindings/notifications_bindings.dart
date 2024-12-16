

import 'package:go_logistics_driver/utils/exports.dart';


class NotificationsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationsController>(
          () => NotificationsController(),
    );
  }
}
