
import 'package:go_logistics_driver/utils/exports.dart';


class SplashBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(
          () => SplashController(),
    );
  }
}
