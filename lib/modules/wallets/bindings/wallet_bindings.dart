import 'package:go_logistics_driver/utils/exports.dart';


class WalletBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WalletController>(
          () => WalletController(),
    );
  }
}
