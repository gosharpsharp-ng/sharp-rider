import 'package:gorider/core/utils/exports.dart';

class WalletWidget extends StatelessWidget {
  final String balance;
  final String title;
  final bool canWithdraw;
  const WalletWidget(
      {super.key,
      required this.balance,
      required this.title,
      this.canWithdraw = false});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WalletController>(builder: (walletController) {
      return Container(
        width: 1.sw * 0.85,
        margin: EdgeInsets.symmetric(horizontal: 5.w),
        padding: EdgeInsets.symmetric(vertical: 18.sp, horizontal: 15.sp),
        decoration: BoxDecoration(
            color: AppColors.deepPrimaryColor,
            borderRadius: BorderRadius.circular(14.r)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                customText(title,
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                    overflow: TextOverflow.visible),
                SizedBox(
                  width: 10.w,
                ),
                InkWell(
                  highlightColor: AppColors.transparent,
                  onTap: () {
                    walletController.toggleWalletBalanceVisibility();
                  },
                  child: Icon(
                    walletController.walletBalanceVisibility
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: AppColors.whiteColor,
                    size: 18.sp,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                WalletBalanceText(
                    balance: walletController.availableBalance),
                canWithdraw
                    ? CustomColouredTextButton(
                        onPressed: () {
                          Get.toNamed(Routes.WITHDRAWAL_AMOUNT_SCREEN);
                        },
                        bgColor: AppColors.primaryColor,
                        title: '',
                        child: Center(
                            child: Row(
                          children: [
                            customText(
                              "Withdraw",
                              color: AppColors.whiteColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 12.sp,
                            ),
                            SizedBox(width: 12.sp),
                            SvgPicture.asset(SvgAssets.downArrowIcon),
                          ],
                        )),
                      )
                    : Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 14.sp, vertical: 8.sp)),
              ],
            ),
            SizedBox(
              height: 5.h,
            ),
          ],
        ),
      );
    });
  }
}

class WalletBalanceText extends StatelessWidget {
  final String balance;
  const WalletBalanceText({super.key, required this.balance});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WalletController>(builder: (walletController) {
      return customText(
          walletController.walletBalanceVisibility
              ? formatToCurrency(
                  double.parse(balance),
                )
              : "*****",
          color: AppColors.whiteColor,
          fontWeight: FontWeight.w600,
          fontFamily: GoogleFonts.montserrat().fontFamily!,
          fontSize: 24.sp,
          overflow: TextOverflow.visible);
    });
  }
}
