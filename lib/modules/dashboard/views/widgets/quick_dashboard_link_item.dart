import 'package:gorider/core/utils/exports.dart';

class QuickDashboardLinkItem extends StatelessWidget {
  final Function onPressed;
  final String title;
  final String assetIconUrl;
  final Gradient gradient;

  const QuickDashboardLinkItem({
    super.key,
    this.title = "Transactions history",
    this.assetIconUrl = SvgAssets.courierIcon,
    required this.onPressed,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: AppColors.transparent,
      splashColor: AppColors.transparent,
      onTap: () {
        onPressed();
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 2.w),
        padding: EdgeInsets.symmetric(vertical: 18.sp, horizontal: 15.sp),
        width: 1.sw,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(
              assetIconUrl,
              height: 20.sp,
              color: AppColors.blackColor,
              width: 20.sp,
            ),
            SizedBox(
              height: 12.h,
            ),
            Row(
              children: [
                Expanded(
                  child: customText(
                    title,
                    color: AppColors.blackColor,
                    fontWeight: FontWeight.w600,
                    fontFamily: GoogleFonts.inter().fontFamily!,
                    fontSize: 12.sp,
                    overflow: TextOverflow.visible,
                  ),
                ),
                SvgPicture.asset(
                  SvgAssets.rightChevronIcon,
                  height: 12.sp,
                  width: 12.sp,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
