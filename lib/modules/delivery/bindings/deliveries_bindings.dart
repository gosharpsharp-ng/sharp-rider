import 'package:gorider/core/utils/exports.dart';

class DeliveriesBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(
      DeliveriesController(),
    );
  }
}
