import 'package:gorider/core/utils/exports.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch fresh transactions when screen is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isRegistered<WalletController>()) {
        Get.find<WalletController>().getTransactions();
      }
    });
  }

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
          child: walletController.fetchingTransactions &&
                  walletController.transactions.isEmpty
              ? SingleChildScrollView(
                  child: SkeletonLoaders.transactionItem(count: 5),
                )
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
                            child: customText("No transactions yet")),
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
