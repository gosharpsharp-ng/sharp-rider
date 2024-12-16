

import 'package:go_logistics_driver/utils/exports.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WalletController>(builder: (walletController) {
        return Scaffold(
          appBar: defaultAppBar(
            bgColor: AppColors.backgroundColor,
            title: "Transaction history",
          ),
          backgroundColor: AppColors.backgroundColor,
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 12.sp),
            height: 1.sh,
            width: 1.sw,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TransactionItem(
                    onTap: () {
                      Get.to(const TransactionDetailsScreen());
                    },
                    transactionOrigin: "order",
                    transactionType: "Withdrawal",
                  ),
                  TransactionItem(
                    onTap: () {
                      Get.to(const TransactionDetailsScreen());
                    },
                  ),
                  TransactionItem(
                    transactionOrigin: "order",
                    onTap: () {
                      Get.to(const TransactionDetailsScreen());
                    },
                  ),
                  TransactionItem(
                    onTap: () {
                      Get.to(const TransactionDetailsScreen());
                    },
                    transactionOrigin: "wallet",
                    transactionType: "Credit",
                    title: "Money In",
                  ),

                  TransactionItem(
                    transactionOrigin: "order",
                    onTap: () {
                      Get.to(const TransactionDetailsScreen());
                    },
                  ), TransactionItem(
                    onTap: () {
                      Get.to(const TransactionDetailsScreen());
                    },
                    transactionOrigin: "order",
                    transactionType: "Withdrawal",
                  ),
                  TransactionItem(
                    onTap: () {
                      Get.to(const TransactionDetailsScreen());
                    },
                  ),
                  TransactionItem(
                    transactionOrigin: "order",
                    onTap: () {
                      Get.to(const TransactionDetailsScreen());
                    },
                  ),
                  TransactionItem(
                    onTap: () {
                      Get.to(const TransactionDetailsScreen());
                    },
                    transactionOrigin: "wallet",
                    transactionType: "Credit",
                    title: "Money In",
                  ),

                  TransactionItem(
                    transactionOrigin: "order",
                    onTap: () {
                      Get.to(const TransactionDetailsScreen());
                    },
                  ), TransactionItem(
                    onTap: () {
                      Get.to(const TransactionDetailsScreen());
                    },
                    transactionOrigin: "wallet",
                    transactionType: "Credit",
                    title: "Money In",
                  ),

                  TransactionItem(
                    transactionOrigin: "order",
                    onTap: () {
                      Get.to(const TransactionDetailsScreen());
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
