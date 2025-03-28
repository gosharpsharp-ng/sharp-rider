import 'package:go_logistics_driver/utils/exports.dart';

class AuthProvider extends GetxService {
  Future<AuthProvider> init() async => this;
  GetStorage localStorage = GetStorage();

  setToken(String token) {
    localStorage.write('token', token);
  }

  // logout
  void logout({
    route = Routes.SIGN_IN,
    title = "Session expired",
    msg = 'To continue please sign in again',
    color = AppColors.obscureTextColor,
  }) {
    localStorage.remove('token');
    Get.offAllNamed(
      Routes.SIGN_IN,
    );
    if (title != '') {
      showToast(message: msg);
    }
  }
}
