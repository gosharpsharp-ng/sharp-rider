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
        body: RefreshIndicator(
          backgroundColor: AppColors.primaryColor,
          color: AppColors.whiteColor,
          onRefresh: () async {
            await walletController.getTransactions();
          },
          child: walletController.isLoading &&
                  walletController.transactions.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  controller: walletController.transactionsScrollController,
                  padding:
                      EdgeInsets.symmetric(horizontal: 8.sp, vertical: 12.sp),
                  children: [
                    if (walletController.transactions.isEmpty)
                      SizedBox(
                        height: 1.sh -
                            kToolbarHeight -
                            MediaQuery.of(context).padding.top,
                        child: Center(
                            child: walletController.fetchingTransactions
                                ? customText("Loading...")
                                : customText("No transactions yet")),
                      )
                    else ...[
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
                      if (walletController.fetchingTransactions)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: customText("Loading more...",
                                color: AppColors.blueColor),
                          ),
                        ),
                      if (walletController.transactions.length >=
                          walletController.totalTransactions)
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
