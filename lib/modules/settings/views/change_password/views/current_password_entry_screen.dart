import 'package:go_logistics_driver/utils/exports.dart';

class CurrentPasswordEntryScreen extends StatelessWidget {
  const CurrentPasswordEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      // key: signInProvider.signInFormKey,
      child: Scaffold(
        appBar: defaultAppBar(
          bgColor: AppColors.backgroundColor,
          title: "Current Password",
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
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.sp, vertical: 20.sp),
                  margin: EdgeInsets.only(left: 10.sp, right: 10.sp),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      color: AppColors.whiteColor),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CustomRoundedInputField(
                        title: "Current Password",
                        label: "Enter your current password",
                        showLabel: true,
                        // obscureText: signInProvider.signInPasswordVisibility,
                        hasTitle: true,
                        // controller: signInProvider.passwordController,
                        suffixWidget: IconButton(
                          onPressed: () {
                            // signInProvider.togglePasswordVisibility();
                          },
                          icon: Icon(
                            // signInProvider.signInPasswordVisibility
                            //     ? Icons.visibility_outlined
                            //     :
                            Icons.visibility_off_outlined,
                            size: 20.sp,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      CustomButton(
                        onPressed: () {
                          Get.to(NewPasswordEntryScreen());
                        },
                        // isBusy: signInProvider.isLoading,
                        title: "Continue",
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
  }
}
