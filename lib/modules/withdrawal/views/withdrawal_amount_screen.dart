
import 'package:go_logistics_driver/utils/exports.dart';

class WithdrawalAmountScreen extends StatelessWidget {
  const WithdrawalAmountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      // key: signInProvider.signInFormKey,
      child: Scaffold(
        appBar: defaultAppBar(
          bgColor: AppColors.backgroundColor,
          title: "Payment",
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
                      const CustomRoundedInputField(
                        title: "Amount",
                        label: "1,500-5,000,000",
                        showLabel: true,
                        isNumber: true,
                        hasTitle: true,
                        // controller: signInProvider.emailController,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: InkWell(
                          onTap: () {
                            // Get.to(const ForgotPasswordEmailScreen());
                          },
                          child: customText("Current Balance: 10,000.00",
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 12.sp),
                        ),
                      ),
                      SizedBox(
                        height: 10.sp,
                      ),
                      const CustomRoundedInputField(
                        title: "Notes",
                        label: "What’s this for (Optional)",
                        showLabel: true,
                        hasTitle: true,
                        maxLines: 4,
                        // controller: signInProvider.emailController,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),

                      SizedBox(
                        height: 15.h,
                      ),
                      CustomButton(
                        onPressed: () {
                          showAnyBottomSheet(
                              isControlled: false,
                              child: WithdrawalPinBottomSheet());
                        },
                        // isBusy: signInProvider.isLoading,
                        title: "Confirm to pay",
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
