import 'package:gorider/core/utils/exports.dart';

class BankSelectionBottomSheet extends StatelessWidget {
  const BankSelectionBottomSheet({super.key, required this.onBankSelected});
  final Function(BankModel) onBankSelected;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WalletController>(builder: (walletController) {
      return Container(
        padding: EdgeInsets.only(
            top: 20.sp, bottom: 12.sp, left: 14.sp, right: 14.sp),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0.sp),
            topRight: Radius.circular(10.0.sp),
          ),
        ),
        height: 440.h,
        child: Column(
          children: [
            Container(
              child: CustomOutlinedRoundedInputField(
                labelColor: AppColors.blackColor,
                cursorColor: AppColors.blackColor,
                label: "Search",
                controller: walletController.banksFilterController,
                prefixWidget: const Icon(
                  Icons.search,
                  color: AppColors.blackColor,
                  // size: 14.sp,
                ),
                onChanged: (val) {
                  walletController.filterBanks(val.toString());
                },
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Container(
              height: 340.h,
              width: 1.sw,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: walletController.filteredBanks.isEmpty
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.start,
                  mainAxisAlignment: walletController.filteredBanks.isEmpty
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
                  children: walletController.filteredBanks.isEmpty
                      ? [
                          walletController.isLoadingBanks
                              ? customText("Loading...",
                                  fontWeight: FontWeight.bold)
                              : InkWell(
                                  onTap: () {
                                    walletController.getBankList();
                                  },
                                  child: Column(
                                    children: [
                                      customText("Reload"),
                                      const Icon(Icons.refresh)
                                    ],
                                  ),
                                )
                        ]
                      : walletController.filteredBanks.map((bank) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                              onBankSelected(bank);
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 5.sp),
                              child: customText(bank.name,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.blackColor),
                            ),
                          );
                        }).toList(),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
