import 'package:gorider/core/utils/exports.dart';
import 'package:gorider/modules/settings/controllers/faq_controller.dart';

class FaqBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FaqController());
  }
}
