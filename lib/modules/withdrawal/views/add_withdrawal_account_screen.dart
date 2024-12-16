import 'package:go_logistics_driver/modules/app_navigation/views/app_navigation_screen.dart';
import 'package:go_logistics_driver/utils/exports.dart';

class AddWithdrawalAccountScreen extends StatelessWidget {
  const AddWithdrawalAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      // key: signInProvider.signInFormKey,
      child: Scaffold(
        appBar: defaultAppBar(
          bgColor: AppColors.backgroundColor,
          title: "Add Bank Account",
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
                      ClickableCustomRoundedInputField(
                        title: "Update Package Status",
                        label: "Select",
                        readOnly: true,
                        showLabel: true,
                        hasTitle: true,
                        suffixWidget: IconButton(
                          onPressed: () {},
                          icon: SvgPicture.asset(
                            SvgAssets.downChevronIcon,
                            // h: 20.sp,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        // controller: signInProvider.emailController,
                      ),
                      SizedBox(
                        height: 10.sp,
                      ),
                      const CustomRoundedInputField(
                        title: "Account number",
                        label: "77335521",
                        showLabel: true,
                        hasTitle: true,
                        // controller: signInProvider.passwordController,
                      ),
                      SizedBox(
                        height: 10.sp,
                      ),
                      const CustomRoundedInputField(
                        title: "Account name",
                        label: "Dennis Mathew",
                        showLabel: true,
                        hasTitle: true,
                        // controller: signInProvider.passwordController,
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      CustomButton(
                        onPressed: () {},
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
