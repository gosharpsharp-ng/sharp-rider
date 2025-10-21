import 'package:gorider/core/utils/exports.dart';
import 'package:intl_phone_field/phone_number.dart';

class PersonalInfoStep extends GetView<SignUpController> {
  const PersonalInfoStep({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignUpController>(
      builder: (controller) {
        return Form(
          key: controller.signUpFormKey,
          child: Container(
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
                        SizedBox(height: 5.sp),
                        customText(
                            "Please fill in the fields below to create your rider account",
                            color: AppColors.blackColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.normal),
                        SizedBox(height: 5.sp),
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
                          isRequired: true,
                          hasTitle: true,
                          controller: controller.firstNameController,
                        ),
                        CustomRoundedInputField(
                          title: "Last name",
                          label: "Doe",
                          showLabel: true,
                          isRequired: true,
                          hasTitle: true,
                          controller: controller.lastNameController,
                        ),
                        CustomRoundedInputField(
                          title: "Email",
                          label: "rider@example.com",
                          showLabel: true,
                          isRequired: true,
                          useCustomValidator: true,
                          keyboardType: TextInputType.emailAddress,
                          hasTitle: true,
                          controller: controller.emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an email';
                            } else if (!validateEmail(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        CustomRoundedPhoneInputField(
                          title: "Phone number",
                          label: "7061032122",
                          onChanged: (PhoneNumber phone) {
                            if (phone.number.isNotEmpty &&
                                phone.number.startsWith('0')) {
                              final updatedNumber =
                                  phone.number.replaceFirst(RegExp(r'^0'), '');
                              controller.phoneNumberController.value =
                                  TextEditingValue(
                                text: updatedNumber,
                                selection: TextSelection.collapsed(
                                    offset: updatedNumber.length),
                              );
                              controller.setPhoneNumber(PhoneNumber(
                                countryISOCode: phone.countryISOCode,
                                countryCode: phone.countryCode,
                                number: updatedNumber,
                              ));
                              controller.setFilledPhoneNumber(PhoneNumber(
                                countryISOCode: phone.countryISOCode,
                                countryCode: phone.countryCode,
                                number: updatedNumber,
                              ));
                            } else {
                              controller.setFilledPhoneNumber(phone);
                            }
                          },
                          keyboardType: TextInputType.phone,
                          validator: (phone) {
                            if (phone == null || phone.completeNumber.isEmpty) {
                              return "Phone number is required";
                            }
                            final regex = RegExp(r'^\+234[1-9]\d{9}$');
                            if (!regex.hasMatch(phone.completeNumber)) {
                              return "Phone number must be 10 digits long";
                            }
                            if (controller.phoneNumberController.text.isEmpty) {
                              return "Phone number is required";
                            }
                            return null;
                          },
                          isPhone: true,
                          hasTitle: true,
                          controller: controller.phoneNumberController,
                        ),
                        CustomRoundedInputField(
                          title: "Password",
                          label: "Create your password (min 8 characters)",
                          showLabel: true,
                          isRequired: true,
                          useCustomValidator: true,
                          hasTitle: true,
                          obscureText: !controller.signUpPasswordVisibility,
                          controller: controller.passwordController,
                          suffixWidget: IconButton(
                            onPressed: () {
                              controller.togglePasswordVisibility();
                            },
                            icon: Icon(
                              !controller.signUpPasswordVisibility
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              size: 20.sp,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            } else if (value.length < 8) {
                              return 'Password must contain at least 8 characters';
                            }
                            return null;
                          },
                        ),
                        CustomRoundedInputField(
                          title: "Confirm Password",
                          label: "Retype your password",
                          showLabel: true,
                          isRequired: true,
                          useCustomValidator: true,
                          obscureText: !controller.signUpConfirmPasswordVisibility,
                          hasTitle: true,
                          controller: controller.cPasswordController,
                          suffixWidget: IconButton(
                            onPressed: () {
                              controller.toggleConfirmPasswordVisibility();
                            },
                            icon: Icon(
                              !controller.signUpConfirmPasswordVisibility
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              size: 20.sp,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            } else if (value !=
                                controller.passwordController.text) {
                              return 'Passwords do not match';
                            } else if (value.length < 8) {
                              return 'Password must contain at least 8 characters';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 15.sp),
                        CustomButton(
                          onPressed: () {
                            if (controller.validateStep1()) {
                              controller.nextStep();
                            }
                          },
                          isBusy: controller.isLoading,
                          title: "Next",
                          width: 1.sw,
                          backgroundColor: AppColors.primaryColor,
                          fontColor: AppColors.whiteColor,
                        ),
                        SizedBox(height: 15.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            customText("Already have an account?",
                                color: AppColors.obscureTextColor,
                                fontSize: 15.sp),
                            SizedBox(width: 12.w),
                            InkWell(
                              onTap: () {
                                Get.offAllNamed(Routes.SIGN_IN);
                              },
                              child: customText("Login",
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15.sp),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
