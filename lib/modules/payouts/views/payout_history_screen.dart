import 'package:gorider/core/utils/exports.dart';
import 'package:gorider/modules/payouts/views/widgets/payout_item.dart';

class PayoutHistoryScreen extends StatelessWidget {
  const PayoutHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PayoutController>(builder: (payoutController) {
      return Scaffold(
        appBar: defaultAppBar(
          bgColor: AppColors.backgroundColor,
          title: "Payout History",
        ),
        backgroundColor: AppColors.backgroundColor,
        body: RefreshIndicator(
          backgroundColor: AppColors.primaryColor,
          color: AppColors.whiteColor,
          onRefresh: () async {
            await payoutController.getPayoutHistory();
          },
          child: payoutController.fetchingPayouts &&
                  payoutController.payoutRequests.isEmpty
              ? SingleChildScrollView(
                  child: SkeletonLoaders.payoutItem(count: 5),
                )
              : ListView(
                  controller: payoutController.payoutHistoryScrollController,
                  padding:
                      EdgeInsets.symmetric(horizontal: 8.sp, vertical: 12.sp),
                  children: [
                    if (payoutController.payoutRequests.isEmpty)
                      SizedBox(
                        height: 1.sh -
                            kToolbarHeight -
                            MediaQuery.of(context).padding.top,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.account_balance_wallet_outlined,
                                size: 80.sp,
                                color: AppColors.greyColor,
                              ),
                              SizedBox(height: 16.h),
                              customText(
                                "No payout history",
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                              SizedBox(height: 8.h),
                              customText(
                                "Your payout requests will appear here",
                                fontSize: 14.sp,
                                color: AppColors.greyColor,
                              ),
                            ],
                          ),
                        ),
                      )
                    else ...[
                      ...List.generate(
                        payoutController.payoutRequests.length,
                        (i) => PayoutItem(
                          payoutRequest: payoutController.payoutRequests[i],
                          onTap: () {
                            payoutController.setSelectedPayoutRequest(
                                payoutController.payoutRequests[i]);
                            // Navigate to payout details screen when created
                            // Get.toNamed(Routes.PAYOUT_DETAILS_SCREEN);
                          },
                        ),
                      ),
                      if (payoutController.fetchingPayouts)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: customText("Loading more...",
                                color: AppColors.blueColor),
                          ),
                        ),
                      if (payoutController.payoutRequests.length >=
                          payoutController.totalPayouts)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: customText("No more data to load",
                                color: AppColors.blueColor),
                          ),
                        ),
                    ]
                  ],
                ),
        ),
      );
    });
  }
}
