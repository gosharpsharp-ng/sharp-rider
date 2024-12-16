
import 'package:go_logistics_driver/utils/exports.dart';


class SettingsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsController>(
          () => SettingsController(),
    );
  }
}
