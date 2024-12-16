import 'dart:async';


import 'package:go_logistics_driver/utils/exports.dart';

class SignUpController extends GetxController {
  late Timer _otpResendTimer;
  int resendOTPAfter = 120;
  String remainingTime = "";

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

  final authService = serviceLocator<AuthenticationService>();
  final signUpFormKey = GlobalKey<FormState>();
  final signOTPFormKey = GlobalKey<FormState>();

  bool isLoading = false;
  setLoadingState(bool val) {
    isLoading = val;
    update();
  }

  bool isResendingOtp = false;
  setIsResendingOTPState(bool val) {
    isResendingOtp = val;
    update();
  }

  bool signUpPasswordVisibility = false;

  togglePasswordVisibility() {
    signUpPasswordVisibility = !signUpPasswordVisibility;
    update();
  }

  bool signUpConfirmPasswordVisibility = false;

  toggleConfirmPasswordVisibility() {
    signUpConfirmPasswordVisibility = !signUpConfirmPasswordVisibility;
    update();
  }

  TextEditingController otpController = TextEditingController();
  verifyOtp() async {
    if (signUpFormKey.currentState!.validate()) {
      setLoadingState(true);
      dynamic data = {
        'otp': firstNameController.text,
        'password': passwordController.text,
      };
      APIResponse response = await authService.verifyPhoneOtp(data);
      showToast(message: response.message, isError: !response.success);
      setLoadingState(false);
      if (response.success) {
        Get.offAndToNamed(Routes.SIGN_IN);
      }
    }
  }

  sendOtp() async {
    setIsResendingOTPState(true);
    dynamic data = {
      'login': phoneNumberController.text,
    };
    APIResponse response = await authService.sendOtp(data);
    showToast(message: response.message, isError: !response.success);
    setIsResendingOTPState(false);
    if(response.success){
      _startOtpResendTimer();
    }
  }

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cPasswordController = TextEditingController();
  signUp() async {
    if (signUpFormKey.currentState!.validate()) {
      setLoadingState(true);
      dynamic data = {
        'fname': firstNameController.text,
        'lname': lastNameController.text,
        'email': emailController.text,
        'phone': phoneNumberController.text,
        'as_rider': false,
        'password': passwordController.text,
      };
      APIResponse response = await authService.signup(data);
      showToast(message: response.message, isError: !response.success);
      setLoadingState(false);
      if (response.success) {
        _startOtpResendTimer();
        Get.toNamed(Routes.SIGNUP_OTP_SCREEN);
      }
    }
  }
}
