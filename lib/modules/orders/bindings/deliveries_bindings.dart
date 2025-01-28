import 'package:go_logistics_driver/utils/exports.dart';

class DeliveriesBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(
      DeliveriesController(),
    );
  }
}
