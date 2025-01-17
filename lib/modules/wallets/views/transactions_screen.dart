

import 'package:go_logistics_driver/utils/exports.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WalletController>(builder: (walletController) {
      return Scaffold(
        appBar: defaultAppBar(
          bgColor: AppColors.backgroundColor,
          title: "Transactions",
        ),
        backgroundColor: AppColors.backgroundColor,
        body:  RefreshIndicator(
          color: AppColors.primaryColor,
          onRefresh: ()async{
            walletController.getAllTransactions();

          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 12.sp),
            height: 1.sh,
            width: 1.sw,
            child: Visibility(
              visible: walletController.transactions.isNotEmpty,
              replacement: Visibility(
                visible: walletController.isLoading &&
                    walletController.transactions.isEmpty,
                replacement: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: customText("No transactions yet"),
                    ),
                  ],
                ),
                child: Center(
                  child: customText("Loading...."),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ...List.generate(
                      walletController.transactions.length,
                          (i) => TransactionItem(
                        onTap: () {
                          walletController.setSelectedTransaction(
                              walletController.transactions[i]);
                          Get.toNamed(Routes.TRANSACTION_DETAILS_SCREEN);
                        },
                        transaction: walletController.transactions[i],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

