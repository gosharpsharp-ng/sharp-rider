import 'package:gorider/core/utils/exports.dart';

class PasswordResetController extends GetxController {
  late Timer _otpResendTimer;
  int resendOTPAfter = 120;
  String remainingTime = "";
  final authService = serviceLocator<AuthenticationService>();
  final resetPasswordRequestFormKey = GlobalKey<FormState>();
  final resetPasswordFormKey = GlobalKey<FormState>();
  final restPasswordOtpFormKey = GlobalKey<FormState>();
  TextEditingController otpController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  void _startOtpResendTimer() {
    resendOTPAfter = 120;
    const oneSec = Duration(seconds: 1);
    _otpResendTimer = Timer.periodic(oneSec, (Timer timer) {
      update();
      if (resendOTPAfter > 0) {
        resendOTPAfter--;
        remainingTime = getFormattedResendOTPTime(resendOTPAfter);
        update();
      } else {
        update();
        _otpResendTimer.cancel();
        update();
      }
    });
  }

  bool passwordVisibility = false;

  togglePasswordVisibility() {
    passwordVisibility = !passwordVisibility;
    update();
  }

  bool confirmPasswordVisibility = false;

  toggleConfirmPasswordVisibility() {
    confirmPasswordVisibility = !confirmPasswordVisibility;
    update();
  }

  bool _isLoading = false;
  get isLoading => _isLoading;
  setLoadingState(bool val) {
    _isLoading = val;
    update();
  }

  sendPasswordResetOTP() async {
    if (resetPasswordRequestFormKey.currentState!.validate()) {
      setLoadingState(true);
      dynamic data = {
        'identifier': loginController.text,
      };
      APIResponse response = await authService.sendOtp(data);
      showToast(
          message: response.message, isError: response.status != "success");
      setLoadingState(false);
      if (response.status == "success") {
        _startOtpResendTimer();
        Get.toNamed(Routes.RESET_PASSWORD_OTP_SCREEN);
      }
    }
  }

  bool isResendingOtp = false;
  setIsResendingOTPState(bool val) {
    isResendingOtp = val;
    update();
  }

  resendPasswordResetOTP() async {
    setIsResendingOTPState(true);
    dynamic data = {
      'identifier': loginController.text,
    };
    APIResponse response = await authService.sendOtp(data);
    showToast(message: response.message, isError: response.status != "success");
    setIsResendingOTPState(false);
    if (response.status == "success") {
      _startOtpResendTimer();
    }
  }

  Future<void> validateOtpField() async {
    if (restPasswordOtpFormKey.currentState!.validate()) {
      // Navigate directly to password screen - OTP will be verified during password reset
      Get.toNamed(Routes.RESET_PASSWORD_NEW_PASSWORD_SCREEN);
    }
  }

  TextEditingController loginController = TextEditingController();

  resetPassword() async {
    if (resetPasswordFormKey.currentState!.validate()) {
      setLoadingState(true);
      dynamic data = {
        'identifier': loginController.text,
        'otp': otpController.text,
        'password': newPasswordController.text,
        'password_confirmation': confirmPasswordController.text,
      };
      APIResponse response = await authService.resetPassword(data);
      setLoadingState(false);

      if (response.status == "success") {
        showToast(message: response.message, isError: false);
        otpController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();
        loginController.clear();
        Get.offAllNamed(Routes.SIGN_IN);
      } else {
        // Check if error is OTP-related
        String errorMessage = response.message.toLowerCase();
        if (errorMessage.contains('otp') ||
            errorMessage.contains('code') ||
            errorMessage.contains('expired') ||
            errorMessage.contains('invalid code')) {
          // OTP error - navigate back to OTP screen
          showToast(message: response.message, isError: true);
          Get.back(); // Go back to OTP entry screen
        } else {
          // Password validation error - show on current screen
          showToast(message: response.message, isError: true);
        }
      }
    }
  }
}
