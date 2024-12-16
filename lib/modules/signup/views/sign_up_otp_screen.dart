import 'package:go_logistics_driver/utils/exports.dart';

class SignUpOtpScreen extends StatelessWidget {
  SignUpOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignUpController>(builder: (signUpController) {
      return Form(
        key: signUpController.signUpFormKey,
        child: Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: defaultAppBar(
              title: "Verify your email", bgColor: AppColors.backgroundColor),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 14.sp, vertical: 20.sp),
              child: TitleSectionBox(
                title:
                    "Enter the 4 digit OTP code sent to ${signUpController.phoneNumberController.text}",
                backgroundColor: AppColors.whiteColor,
                children: [
                  SizedBox(
                    height: 25.sp,
                  ),
                  CustomPinInput(
                      maxLength: 4, controller: signUpController.otpController),
                  SizedBox(
                    height: 30.sp,
                  ),
                  InkWell(
                    onTap: () {
                      (signUpController.isResendingOtp ||
                              signUpController.resendOTPAfter > 1)
                          ? null
                          : signUpController.sendOtp();
                    },
                    child: customText(
                      signUpController.isResendingOtp
                          ? 'Loading...'
                          : (signUpController.resendOTPAfter > 1)
                              ? "Resend OTP in ${signUpController.remainingTime}"
                              : "Resend OTP",
                      color: AppColors.primaryColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(
                    height: 50.sp,
                  ),
                  CustomButton(
                    onPressed: () {
                      signUpController.verifyOtp();
                    },
                    isBusy: signUpController.isLoading,
                    backgroundColor: AppColors.primaryColor,
                    title: "Verify",
                    fontColor: AppColors.whiteColor,
                    width: double.infinity,
                  ),
                  SizedBox(
                    height: 30.sp,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
