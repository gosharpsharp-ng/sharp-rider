import 'package:go_logistics_driver/utils/exports.dart';
import 'package:intl/intl.dart';

class WithdrawalAmountScreen extends StatelessWidget {
  const WithdrawalAmountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WalletController>(builder: (walletController) {
      return Form(
        key: walletController.withdrawFromWalletFormKey,
        child: Scaffold(
          appBar: defaultAppBar(
            bgColor: AppColors.backgroundColor,
            title: "Withdraw from Wallet",
          ),
          backgroundColor: AppColors.backgroundColor,
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 2.sp, vertical: 12.sp),
            height: 1.sh,
            width: 1.sw,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TitleSectionBox(
                    title:
                        "Enter the amount you want to withdraw from your wallet",
                    children: [
                      SizedBox(
                        height: 15.sp,
                      ),
                      CustomRoundedInputField(
                        title: "Amount",
                        label: "50,000",
                        showLabel: true,
                        isRequired: true,
                        isNumber: true,
                        useCustomValidator: true,
                        keyboardType: TextInputType.number,
                        hasTitle: true,
                        controller: walletController.amountEntryController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an amount';
                          }
                          // Remove currency symbols and commas for validation
                          String cleanedValue =
                              value.replaceAll(RegExp(r'[^\d]'), '');
                          if (cleanedValue.isEmpty ||
                              double.tryParse(cleanedValue) == null) {
                            return 'Please enter a valid number';
                          }

                          // Parse the value and check if it is greater than 1000
                          double numericValue = double.parse(cleanedValue);
                          if (numericValue <
                              double.parse(walletController
                                  .walletBalanceData!.balance)) {
                            return 'Amount must be equal or less than ${walletController.walletBalanceData!.balance}';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          // Remove all non-digit characters
                          String newValue =
                              value.replaceAll(RegExp(r'[^0-9]'), '');
                          if (value.isEmpty || newValue == '00') {
                            walletController.amountEntryController.clear();
                            return;
                          }
                          double value1 = int.parse(newValue) / 100;
                          value = NumberFormat.currency(
                            locale: 'en_NG',
                            symbol: '₦',
                            decimalDigits: 2,
                          ).format(value1);
                          walletController.amountEntryController.value =
                              TextEditingValue(
                            text: value,
                            selection:
                                TextSelection.collapsed(offset: value.length),
                          );
                        },
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      CustomButton(
                        onPressed: () async {
                          walletController.withdrawFromWallet();
                        },
                        isBusy: walletController.isLoading,
                        title: "Continue",
                        width: 1.sw,
                        backgroundColor: AppColors.primaryColor,
                        fontColor: AppColors.whiteColor,
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
