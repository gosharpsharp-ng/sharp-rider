import 'package:go_logistics_driver/utils/exports.dart';

class SignInController extends GetxController {
  final authService = serviceLocator<AuthenticationService>();
  final signInFormKey = GlobalKey<FormState>();

  bool _isLoading = false;
  get isLoading => _isLoading;
  setLoadingState(bool val) {
    _isLoading = val;
    update();
  }

  bool signInPasswordVisibility = false;

  togglePasswordVisibility() {
    signInPasswordVisibility = !signInPasswordVisibility;
    update();
  }

  bool signInWithEmail = true;

  toggleSignInWithEmail() {
    signInWithEmail = !signInWithEmail;
    update();
  }

  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  signIn() async {
    if (signInFormKey.currentState!.validate()) {
      setLoadingState(true);
      dynamic data = {
        'login': loginController.text,
        'password': passwordController.text,
      };
      APIResponse response = await authService.login(data);
      showToast(message: response.message, isError: !response.success);
      setLoadingState(false);
      if (response.success) {
        final getStorage = GetStorage();
        getStorage.write("token", response.data['access_token']);
        // Get.toNamed(Routes.SIGNUP_OTP_SCREEN);
      }
    }
  }
}
