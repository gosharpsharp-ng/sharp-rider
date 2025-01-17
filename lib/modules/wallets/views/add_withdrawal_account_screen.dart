import 'package:go_logistics_driver/modules/wallets/views/widgets/bank_selection_bottom_sheet.dart';
import 'package:go_logistics_driver/utils/exports.dart';

class AddWithdrawalAccountScreen extends StatelessWidget {
  const AddWithdrawalAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WalletController>(builder: (walletController) {
      return Form(
        key: walletController.payoutAccountFormKey,
        child: Scaffold(
          appBar: defaultAppBar(
            bgColor: AppColors.backgroundColor,
            title: "Add Bank Account",
          ),
          backgroundColor: AppColors.backgroundColor,
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 2.sp, vertical: 12.sp),
            height: 1.sh,
            width: 1.sw,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 10.sp, vertical: 20.sp),
                    margin: EdgeInsets.only(left: 10.sp, right: 10.sp),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        color: AppColors.whiteColor),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ClickableCustomRoundedInputField(
                          title: "Select bank",
                          label: "Select",
                          readOnly: true,
                          showLabel: true,
                          hasTitle: true,
                          controller: walletController.bankNameController,
                          onPressed: () {
                            if (walletController.originalBanks.isEmpty) {
                              walletController.getBankList();
                            }
                            showAnyBottomSheet(child: BankSelectionBottomSheet(
                                onBankSelected: (BankModel selectedBank) {
                              walletController.setSelectedBank(selectedBank);
                            }));
                          },
                          suffixWidget: IconButton(
                            onPressed: () {
                              if (walletController.originalBanks.isEmpty) {
                                walletController.getBankList();
                              }
                              showAnyBottomSheet(child:
                                  BankSelectionBottomSheet(
                                      onBankSelected: (BankModel selectedBank) {
                                walletController.setSelectedBank(selectedBank);
                              }));
                            },
                            icon: SvgPicture.asset(
                              SvgAssets.downChevronIcon,
                              // h: 20.sp,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          // controller: signInProvider.emailController,
                        ),
                        SizedBox(
                          height: 10.sp,
                        ),
                        CustomRoundedInputField(
                          title: "Account number",
                          label: "77335521",
                          showLabel: true,
                          hasTitle: true,
                          useCustomValidator: true,
                          keyboardType: TextInputType.number,
                          controller: walletController.accountNumberController,
                          onChanged: (value) {
                            if (RegExp(r'^\d{10}$').hasMatch(value)) {
                              walletController.verifyPayoutBank();
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Value is required';
                            }

                            if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                              return 'The value must be exactly 10 digits';
                            }
                            return null; // Return null if validation passes
                          },
                        ),
                        SizedBox(
                          height: 10.sp,
                        ),
                        CustomRoundedInputField(
                          title: "Account name",
                          label: "Dennis Mathew",
                          showLabel: true,
                          readOnly: true,
                          hasTitle: true,
                          isRequired: true,
                          controller: walletController.resolvedBankAccountName,
                          // controller: signInProvider.passwordController,
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        CustomButton(
                          onPressed: () {
                            walletController.updatePayoutAccount();
                          },
                          // isBusy: signInProvider.isLoading,
                          title: "Submit",
                          width: 1.sw,
                          backgroundColor: AppColors.primaryColor,
                          fontColor: AppColors.whiteColor,
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                      ],
                    ),
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
