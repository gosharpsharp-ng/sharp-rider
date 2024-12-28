import 'package:go_logistics_driver/utils/exports.dart';

import 'package:intl_phone_field/phone_number.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignInController>(builder: (signInController) {
      return Form(
        key: signInController.signInFormKey,
        child: Scaffold(
          appBar: defaultAppBar(
            bgColor: AppColors.backgroundColor,
            title: "Login",
          ),
          backgroundColor: AppColors.backgroundColor,
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
                        color: AppColors.whiteColor),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 5.sp,
                        ),
                        InkWell(
                          onTap: () {
                            signInController.toggleSignInWithEmail();
                          },
                          child: customText(
                            "Sign in with ${signInController.signInWithEmail ? 'Phone' : 'Email'} instead",
                            fontSize: 14.sp,
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: 15.sp,
                        ),
                        signInController.signInWithEmail
                            ? CustomRoundedInputField(
                          title: "Email",
                          label: "meterme@gmail.com",
                          showLabel: true,
                          isRequired: true,
                          isPhone: signInController.signInWithEmail
                              ? false
                              : true,
                          useCustomValidator: true,
                          hasTitle: true,
                          keyboardType: TextInputType.emailAddress,
                          controller: signInController.loginController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an email';
                            } else if (!validateEmail(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        )
                            : CustomRoundedPhoneInputField(
                          title: "Phone number",
                          label: "+2347061032122",
                          onChanged: (PhoneNumber phone) {
                            if (phone.number.startsWith('0')) {
                              final updatedNumber =
                              phone.number.replaceFirst('0', '');

                              PhoneNumber num = PhoneNumber(
                                  countryISOCode: phone.countryISOCode,
                                  countryCode: phone.countryCode,
                                  number: updatedNumber);
                              signInController.setPhoneNumber(num);
                            }
                          },
                          keyboardType: TextInputType.phone,
                          validator: (phone) {
                            if (phone == null ||
                                phone.completeNumber.isEmpty) {
                              return "Phone number is required";
                            }
                            // Regex: `+` followed by 1 to 3 digits (country code), then 10 digits (phone number)
                            final regex = RegExp(r'^\+234[1-9]\d{9}$');
                            if (!regex.hasMatch(phone.completeNumber)) {
                              return "Phone number must start with +234 and be 10 digits long";
                            }

                            return null; // Valid phone number
                          },
                          isPhone: true,
                          hasTitle: true,
                          controller: signInController.loginController,
                        ),
                        SizedBox(
                          height: 10.sp,
                        ),
                        CustomRoundedInputField(
                          title: "Password",
                          label: "Enter your password",
                          showLabel: true,
                          isRequired: true,
                          useCustomValidator: true,
                          obscureText:
                          !signInController.signInPasswordVisibility,
                          hasTitle: true,
                          controller: signInController.passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                          suffixWidget: IconButton(
                            onPressed: () {
                              signInController.togglePasswordVisibility();
                            },
                            icon: Icon(
                              !signInController.signInPasswordVisibility
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              size: 20.sp,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () {
                              Get.toNamed(
                                  Routes.RESET_PASSWORD_EMAIL_ENTRY_SCREEN);
                            },
                            child: customText("Forgot your password?",
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 15.sp),
                          ),
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        CustomButton(
                          onPressed: () {
                            signInController.signIn();
                          },
                          isBusy: signInController.isLoading,
                          title: "Log in",
                          width: 1.sw,
                          backgroundColor: AppColors.primaryColor,
                          fontColor: AppColors.whiteColor,
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            customText("Don't have an account?",
                                color: AppColors.obscureTextColor,
                                fontSize: 15.sp),
                            SizedBox(
                              width: 12.w,
                            ),
                            InkWell(
                              onTap: () {
                                Get.toNamed(Routes.SIGNUP_SCREEN);
                              },
                              child: customText("Create an account",
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15.sp),
                            ),
                          ],
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
