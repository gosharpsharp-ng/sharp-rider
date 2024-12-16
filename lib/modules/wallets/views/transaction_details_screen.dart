import 'package:go_logistics_driver/utils/exports.dart';

class TransactionDetailsScreen extends StatelessWidget {
  const TransactionDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WalletController>(builder: (walletController) {
        return Scaffold(
          appBar: defaultAppBar(
            bgColor: AppColors.backgroundColor,
            title: "Transaction details",
          ),
          backgroundColor: AppColors.backgroundColor,
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 12.sp),
            height: 1.sh,
            width: 1.sw,
            child:  SingleChildScrollView(
              child: Column(
                children: [
                  SectionBox(children: const [
                    TransactionDetailSummaryItem(
                      title: "Amount",
                      value: "N1,000",
                    ),
                    TransactionDetailSummaryItem(
                      title: "Transaction ID",
                      value: "ZFD237G56M3",
                    ),
                    TransactionDetailSummaryTypeItem(
                      title: "Transaction type",
                      value: "Withdrawal",
                    ),
                    TransactionDetailSummaryTypeItem(
                      title: "Payment Method",
                      value: "GoWallet",
                    ),
                    TransactionDetailSummaryItem(
                      title: "Date",
                      value: "Thu. Dec 5, 2024 7:15am",
                    ),
                    TransactionDetailSummaryStatusItem(
                      title: "Status",
                      value: "successful",
                    ),
                  ]),
                  SectionBox(children: const [
                    TransactionDetailSummaryItem(
                      title: "Sender's Name",
                      value: "Ayodeji Sebanjo",
                    ),
                    TransactionDetailSummaryItem(
                      title: "Phone Number",
                      value: "08162848289",
                    ),
                    TransactionDetailSummaryItem(
                      title: "Email",
                      value: "ayounie@gmail.com",
                    ),
                    TransactionDetailSummaryItem(
                      title: "Address",
                      isVertical: true,
                      value:
                      "Shop 7, Alaba international market, Alaba market Lagos.",
                    ),
                  ]),
                  SectionBox(children: const [
                    TransactionDetailSummaryItem(
                      title: "Receiver's Name",
                      value: "Maloung Doe",
                    ),
                    TransactionDetailSummaryItem(
                      title: "Phone Number",
                      value: "08036322653",
                    ),
                    TransactionDetailSummaryItem(
                      title: "Email",
                      value: "emekaleingo@gmail.com",
                    ),
                    TransactionDetailSummaryItem(
                      title: "Address",
                      isVertical: true,
                      value:
                      "Shop 7, Alaba international market, Alaba market Lagos.",
                    ),
                  ]),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
