
import 'package:go_logistics_driver/utils/exports.dart';


class OnboardingBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingController>(
          () => OnboardingController(),
    );
  }
}
