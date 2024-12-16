import 'package:go_logistics_driver/utils/exports.dart';

class TransactionItem extends StatelessWidget {
  final String transactionType;
  final String transactionOrigin;
  final String title;
  final String date;
  final String time;
  final String amount;
  final Function onTap;
  const TransactionItem(
      {super.key,
      this.transactionType = "Withdrawal",
      required this.onTap,
      this.transactionOrigin = "Wallet",
      this.amount = "₦3,000",
      this.title = "GO3xcd435d0oadk3",
      this.time = "9:30am",
      this.date = "Tue 23 April, 2024"});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 5.w),
      margin: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.w),
      decoration: BoxDecoration(color: AppColors.whiteColor,borderRadius: BorderRadius.circular(10.r)),
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            transactionOrigin.toLowerCase() == "wallet"
                ? SvgPicture.asset(SvgAssets.walletTransactionIcon)
                : SvgPicture.asset(SvgAssets.orderTransactionIcon),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric( horizontal: 8.w),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        customText(title,
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 15.sp,
                            overflow: TextOverflow.visible),
                        customText(
                          time,
                          color: AppColors.obscureTextColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 12.sp,
                        ),
                      ],
                    ),
                    SizedBox(height: 5.h,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        customText(
                          date,
                          color: AppColors.obscureTextColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 12.sp,
                        ),
                        customText(amount,
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.w600,
                            fontFamily: GoogleFonts.montserrat().fontFamily!,
                            fontSize: 15.sp,
                            overflow: TextOverflow.visible),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            transactionType.toLowerCase() == "withdrawal"
                ? SvgPicture.asset(SvgAssets.outflowCircleIcon)
                : SvgPicture.asset(SvgAssets.inflowCircleIcon),
          ],
        ),
      ),
    );
  }
}
