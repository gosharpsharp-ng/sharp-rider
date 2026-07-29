import 'package:gorider/core/utils/exports.dart';

class ResetPasswordEmailEntry extends StatelessWidget {
  const ResetPasswordEmailEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PasswordResetController>(
        builder: (passwordResetController) {
      return Form(
        key: passwordResetController.resetPasswordRequestFormKey,
        child: Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: defaultAppBar(
              title: "Reset password", bgColor: AppColors.backgroundColor),
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 2.sp, vertical: 12.sp),
            height: 1.sh,
            width: 1.sw,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 10.sp, vertical: 20.sp),
                    margin: EdgeInsets.only(left: 10.sp, right: 10.sp),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      color: AppColors.whiteColor,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 5.sp,
                        ),
                        CustomRoundedInputField(
                          title: "Email",
                          label: "meterme@gmail.com",
                          showLabel: true,
                          isRequired: true,
                          isPhone: false,
                          useCustomValidator: true,
                          hasTitle: true,
                          keyboardType: TextInputType.emailAddress,
                          controller: passwordResetController.loginController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an email';
                            } else if (!validateEmail(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        CustomButton(
                          onPressed: () {
                            passwordResetController.sendPasswordResetOTP();
                          },
                          isBusy: passwordResetController.isLoading,
                          title: "Get OTP",
                          width: 1.sw,
                          backgroundColor: AppColors.primaryColor,
                          fontColor: AppColors.whiteColor,
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                      ],
                    ),
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
