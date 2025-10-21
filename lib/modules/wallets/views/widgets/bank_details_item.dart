import 'package:gorider/core/utils/exports.dart';

class BankDetailsItem extends StatelessWidget {
  final String title;
  final String value;
  final bool isVertical;
  final bool isCurrency;
  const BankDetailsItem(
      {super.key,
      this.title = "",
      this.value = "",
      this.isVertical = true,
      this.isCurrency = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 0.w, vertical: 3.h),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.r),
          color: AppColors.whiteColor),
      child: isVertical
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText(title,
                    color: AppColors.obscureTextColor,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.normal),
                SizedBox(
                  height: 8.h,
                ),
                customText(
                  value,
                  color: AppColors.blackColor,
                  fontSize: 15.sp,
                  fontFamily: isCurrency
                      ? GoogleFonts.montserrat().fontFamily!
                      : 'Satoshi',
                  fontWeight: FontWeight.w500,
                  overflow: TextOverflow.visible,
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText("$title:",
                    color: AppColors.obscureTextColor,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.normal),
                customText(
                  value,
                  color: AppColors.blackColor,
                  fontFamily: isCurrency
                      ? GoogleFonts.montserrat().fontFamily!
                      : 'Satoshi',
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  overflow: TextOverflow.visible,
                ),
              ],
            ),
    );
  }
}
