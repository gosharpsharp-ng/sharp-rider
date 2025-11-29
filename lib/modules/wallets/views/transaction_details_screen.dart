import 'package:gorider/core/utils/exports.dart';

class TransactionDetailsScreen extends StatelessWidget {
  const TransactionDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WalletController>(builder: (walletController) {
      final transaction = walletController.selectedTransaction;

      if (transaction == null) {
        return Scaffold(
          appBar: defaultAppBar(
            bgColor: AppColors.backgroundColor,
            title: "Transaction Details",
            implyLeading: true,
          ),
          body: Center(
            child: customText(
              "No transaction selected",
              fontSize: 16.sp,
              color: AppColors.greyColor,
            ),
          ),
        );
      }

      return Scaffold(
        appBar: defaultAppBar(
          bgColor: AppColors.backgroundColor,
          title: "Transaction Details",
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
                    TransactionDetailSummaryItem(
                      title: "Amount",
                      value: formatToCurrency(
                        double.tryParse(transaction.amount) ?? 0.0,
                      ),
                    ),
                    TransactionDetailSummaryItem(
                      title: "Reference",
                      value: transaction.paymentReference,
                    ),
                    TransactionDetailSummaryStatusItem(
                      title: "Status",
                      value: transaction.status.capitalizeFirst ?? '',
                    ),
                    TransactionDetailSummaryTypeItem(
                      title: "Transaction Type",
                      value: transaction.type.capitalize ?? "",
                    ),
                    const TransactionDetailSummaryItem(
                      title: "Payment Method",
                      value: "GoWallet",
                    ),
                    TransactionDetailSummaryItem(
                      title: "Date",
                      value:
                          "${formatDate(transaction.createdAt)} ${formatTime(transaction.createdAt)}",
                    ),
                    if (transaction.description.isNotEmpty)
                      TransactionDetailSummaryItem(
                        title: "Description",
                        value: transaction.description,
                        isVertical: true,
                      ),
                  ],
                ),

                SizedBox(height: 10.h),
              ],
            ),
          ),
        ),
      );
    });
  }
}
