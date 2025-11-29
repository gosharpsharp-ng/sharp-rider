import 'package:gorider/core/utils/exports.dart';

class DeliveriesBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DeliveriesController>(
      () => DeliveriesController(),
      fenix: true,
    );
  }
}
