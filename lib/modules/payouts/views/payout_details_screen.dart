import 'package:gorider/core/utils/exports.dart';
import 'widgets/payout_detail_summary_item.dart';

class PayoutDetailsScreen extends StatelessWidget {
  const PayoutDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PayoutController>(
      builder: (payoutController) {
        final payout = payoutController.selectedPayoutRequest;

        if (payout == null) {
          return Scaffold(
            appBar: defaultAppBar(
              bgColor: AppColors.backgroundColor,
              title: "Payout Details",
              implyLeading: true,
            ),
            body: Center(
              child: customText(
                "No payout selected",
                fontSize: 16.sp,
                color: AppColors.greyColor,
              ),
            ),
          );
        }

        return Scaffold(
          appBar: defaultAppBar(
            bgColor: AppColors.backgroundColor,
            title: "Payout Details",
            implyLeading: true,
            centerTitle: false,
          ),
          backgroundColor: AppColors.backgroundColor,
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 2.sp, vertical: 12.sp),
            height: 1.sh,
            width: 1.sw,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Main Details Section
                  SectionBox(
                    children: [
                      PayoutDetailSummaryItem(
                        title: "Amount",
                        value: formatToCurrency(payout.amountDouble),
                      ),
                      PayoutDetailSummaryItem(
                        title: "Reference",
                        value: payout.ref,
                      ),
                      PayoutDetailSummaryStatusItem(
                        title: "Status",
                        value: payout.statusDisplayText,
                        status: payout.status,
                      ),
                      PayoutDetailSummaryItem(
                        title: "Payment Method",
                        value: payout.paymentMethodDisplayText,
                      ),
                      PayoutDetailSummaryItem(
                        title: "Requested Date",
                        value:
                            "${formatDate(payout.requestedAt)} ${formatTime(payout.requestedAt)}",
                      ),
                      if (payout.processedAt != null)
                        PayoutDetailSummaryItem(
                          title: "Processed Date",
                          value:
                              "${formatDate(payout.processedAt!)} ${formatTime(payout.processedAt!)}",
                        ),
                      if (payout.note != null && payout.note!.isNotEmpty)
                        PayoutDetailSummaryItem(
                          title: "Note",
                          value: payout.note!,
                          isVertical: true,
                        ),
                    ],
                  ),

                  SizedBox(height: 12.h),

                  // Wallet Information
                  if (payout.wallet != null)
                    SectionBox(
                      children: [
                        // Section Header
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 12.h,
                          ),
                          child: customText(
                            "Wallet Information",
                            fontSize: 16.sp,
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        PayoutDetailSummaryItem(
                          title: "Current Balance",
                          value: payout.wallet!.formattedBalance,
                        ),
                      ],
                    ),

                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
