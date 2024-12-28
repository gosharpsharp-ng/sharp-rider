
import 'package:go_logistics_driver/modules/app_navigation/views/app_navigation_screen.dart';
import 'package:go_logistics_driver/utils/exports.dart';

class NewPasswordEntryScreen extends StatelessWidget {
  const NewPasswordEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      // key: signInProvider.signInFormKey,
      child: Scaffold(
        appBar: defaultAppBar(
          bgColor: AppColors.backgroundColor,
          title: "New Password",
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
                        title: "Password",
                        label: "Enter your password",
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
                        height: 10.sp,
                      ),
                      CustomRoundedInputField(
                        title: "Confirm password",
                        label: "Confirm your password",
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

                        },
                        // isBusy: signInProvider.isLoading,
                        title: "Submit",
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
