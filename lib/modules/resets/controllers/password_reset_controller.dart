import 'package:go_logistics_driver/utils/exports.dart';

class PasswordResetController extends GetxController {
  // final authService = serviceLocator<AuthenticationService>();
  final resetPasswordRequestFormKey = GlobalKey<FormState>();
  final resetPasswordFormKey = GlobalKey<FormState>();
  final restPasswordOtpFormKey = GlobalKey<FormState>();
  TextEditingController otpController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  get isLoading => _isLoading;
  setLoadingState(bool val) {
    _isLoading = val;
    update();
  }

  // sendPasswordResetOTP() async {
  //   if (resetPasswordRequestFormKey.currentState!.validate()) {
  //     setLoadingState(true);
  //     dynamic data = {
  //       'email': emailController.text,
  //     };
  //     APIResponse response = await authService.sendPasswordResetOTP(data);
  //     showToast(message: response.message, isError: !response.success);
  //     setLoadingState(false);
  //     if (response.success) {
  //       final getStorage = GetStorage();
  //       getStorage.write("token", response.data['access_token']);
  //       Get.toNamed(Routes.SIGNUP_OTP_SCREEN);
  //     }
  //   }
  // }
  //
  // verifyPasswordResetOTP() async {
  //   if (restPasswordOtpFormKey.currentState!.validate()) {
  //     setLoadingState(true);
  //     dynamic data = {
  //       'otp': otpController.text,
  //       'email': emailController.text,
  //     };
  //     APIResponse response = await authService.verifyPasswordResetOTP(data);
  //     showToast(message: response.message, isError: !response.success);
  //     setLoadingState(false);
  //     if (response.success) {
  //       final getStorage = GetStorage();
  //       getStorage.write("token", response.data['access_token']);
  //       Get.toNamed(Routes.SIGNUP_SUCCESS_SCREEN);
  //     }
  //   }
  // }
  //
  // resetPassword() async {
  //   if (resetPasswordFormKey.currentState!.validate()) {
  //     setLoadingState(true);
  //     dynamic data = {
  //       'otp': otpController.text,
  //       'email': emailController.text,
  //     };
  //     APIResponse response = await authService.resetPassword(data);
  //     showToast(message: response.message, isError: !response.success);
  //     setLoadingState(false);
  //     if (response.success) {
  //       final getStorage = GetStorage();
  //       getStorage.write("token", response.data['access_token']);
  //       Get.toNamed(Routes.SIGNUP_SUCCESS_SCREEN);
  //     }
  //   }
  // }
}
