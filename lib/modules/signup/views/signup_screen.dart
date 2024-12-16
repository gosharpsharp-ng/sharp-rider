import 'package:go_logistics_driver/utils/exports.dart';

class SignUpScreen extends GetView<SignUpController> {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignUpController>(builder: (signUpController) {
      return Form(
        key: signUpController.signUpFormKey,
        child: Scaffold(
          appBar: defaultAppBar(
            bgColor: AppColors.backgroundColor,
          ),
          backgroundColor: AppColors.backgroundColor,
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 2.sp, vertical: 12.sp),
            height: 1.sh,
            width: 1.sw,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10.sp, right: 10.sp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customText("Create an account",
                            color: AppColors.blackColor,
                            fontSize: 25.sp,
                            fontWeight: FontWeight.w600),
                        SizedBox(
                          height: 5.sp,
                        ),
                        customText(
                            "Please fill in the fields below to create your account",
                            color: AppColors.blackColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.normal),
                        SizedBox(
                          height: 5.sp,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 10.sp, vertical: 20.sp),
                    margin: EdgeInsets.only(left: 10.sp, right: 10.sp),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        color: AppColors.whiteColor),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomRoundedInputField(
                          title: "First name",
                          label: "John",
                          showLabel: true,
                          hasTitle: true,
                          controller: signUpController.firstNameController,
                        ),
                        CustomRoundedInputField(
                          title: "Last name",
                          label: "Doe",
                          showLabel: true,
                          hasTitle: true,
                          controller: signUpController.lastNameController,
                        ),
                        CustomRoundedInputField(
                          title: "Email",
                          label: "meter.me@gmail.com",
                          showLabel: true,
                          hasTitle: true,
                          controller: signUpController.emailController,
                        ),
                        CustomRoundedInputField(
                          title: "Phone number",
                          label: "07056543254",
                          showLabel: true,
                          // isPhone: true,
                          hasTitle: true,
                          controller: signUpController.phoneNumberController,
                        ),
                        SizedBox(
                          height: 10.sp,
                        ),
                        CustomRoundedInputField(
                          title: "Password",
                          label: "Create your 8-digit password",
                          showLabel: true,
                          obscureText:
                          signUpController.signUpPasswordVisibility,
                          hasTitle: true,
                          controller: signUpController.passwordController,
                          suffixWidget: IconButton(
                            onPressed: () {
                              signUpController.togglePasswordVisibility();
                            },
                            icon: Icon(
                              signUpController.signUpPasswordVisibility
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              size: 20.sp,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        CustomRoundedInputField(
                          title: "Confirm Password",
                          label: "Retype your 8-digit password",
                          showLabel: true,
                          obscureText:
                          signUpController.signUpConfirmPasswordVisibility,
                          hasTitle: true,
                          controller: signUpController.cPasswordController,
                          suffixWidget: IconButton(
                            onPressed: () {
                              signUpController
                                  .toggleConfirmPasswordVisibility();
                            },
                            icon: Icon(
                              signUpController.signUpConfirmPasswordVisibility
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              size: 20.sp,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }else if(value != signUpController.passwordController.text){
                              return 'Password mismatch';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 15.sp,
                        ),
                        CustomButton(
                          onPressed: () {
                            signUpController.signUp();
                          },
                          isBusy: signUpController.isLoading,
                          title: "Sign up",
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
                            customText("You have an account?",
                                color: AppColors.obscureTextColor,
                                fontSize: 15.sp),
                            SizedBox(
                              width: 12.w,
                            ),
                            InkWell(
                              onTap: () {
                                Get.toNamed(Routes.SIGN_IN);
                              },
                              child: customText("Login",
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15.sp),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
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
