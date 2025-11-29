import 'package:gorider/core/utils/exports.dart';

class PayoutRequestScreen extends StatelessWidget {
  const PayoutRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PayoutController>(
      builder: (payoutController) {
        return Form(
          key: payoutController.payoutRequestFormKey,
          child: Scaffold(
            appBar: defaultAppBar(
              implyLeading: true,
              bgColor: AppColors.backgroundColor,
              title: "Request Payout",
              centerTitle: false,
            ),
            body: Container(
              height: 1.sh,
              width: 1.sw,
              color: AppColors.backgroundColor,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SectionBox(
                      backgroundColor: AppColors.whiteColor,
                      children: [
                        SizedBox(height: 15.h),

                        // Available Balance Section
                        Container(
                          padding: EdgeInsets.all(16.sp),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: AppColors.primaryColor.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              customText(
                                "Available Balance",
                                fontSize: 14.sp,
                                color: AppColors.greyColor,
                                fontWeight: FontWeight.w500,
                              ),
                              SizedBox(height: 4.h),
                              customText(
                                formatToCurrency(
                                  payoutController.availableBalance,
                                ),
                                fontSize: 24.sp,
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 24.h),

                        // Amount Input
                        CustomRoundedInputField(
                          title: "Amount",
                          label: "Enter amount to withdraw",
                          showLabel: true,
                          hasTitle: true,
                          controller: payoutController.amountController,
                          keyboardType: TextInputType.number,
                          validator: payoutController.validateAmount,
                          suffixWidget: Padding(
                            padding: EdgeInsets.all(8.sp),
                            child: customText(
                              "₦",
                              fontSize: 18.sp,
                              color: AppColors.greyColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        SizedBox(height: 16.h),

                        // Payout Limits Info
                        Container(
                          padding: EdgeInsets.all(12.sp),
                          decoration: BoxDecoration(
                            color: AppColors.amberColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: AppColors.amberColor,
                                size: 16.sp,
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: customText(
                                  "Min: ${formatToCurrency(payoutController.minimumPayoutAmount)} • Max: ${formatToCurrency(payoutController.maximumPayoutAmount)}",
                                  fontSize: 12.sp,
                                  color: AppColors.amberColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 15.h),
                      ],
                    ),

                    SizedBox(height: 20.h),

                    // Submit Button
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.sp),
                      child: CustomButton(
                        onPressed: () {
                          payoutController.submitPayoutRequest();
                        },
                        isBusy: payoutController.isSubmittingRequest,
                        title: "Request Payout",
                        width: 1.sw,
                        backgroundColor: AppColors.primaryColor,
                        fontColor: AppColors.whiteColor,
                      ),
                    ),

                    SizedBox(height: 16.h),

                    // // Link to Payout History
                    // GestureDetector(
                    //   onTap: () {
                    //     Get.offNamed(Routes.PAYOUT_HISTORY_SCREEN);
                    //   },
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       customText(
                    //         "View Payout History",
                    //         fontSize: 14.sp,
                    //         color: AppColors.primaryColor,
                    //         fontWeight: FontWeight.w600,
                    //       ),
                    //       SizedBox(width: 4.w),
                    //       Icon(
                    //         Icons.arrow_forward_ios,
                    //         color: AppColors.primaryColor,
                    //         size: 14.sp,
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    //
                    // SizedBox(height: 15.h),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
