
import 'package:go_logistics_driver/utils/exports.dart';

class SignUpBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignUpController>(() => SignUpController());
  }
}