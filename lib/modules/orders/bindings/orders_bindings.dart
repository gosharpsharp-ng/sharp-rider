
import 'package:go_logistics_driver/utils/exports.dart';


class OrdersBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrdersController>(
          () => OrdersController(),
    );
  }
}
