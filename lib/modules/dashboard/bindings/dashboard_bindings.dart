
import 'package:go_logistics_driver/utils/exports.dart';

class DashboardBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(
      DashboardController(),
    );
  }
}
