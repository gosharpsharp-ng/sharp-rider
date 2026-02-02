import 'package:gorider/core/utils/exports.dart';

class PerformanceBox extends StatelessWidget {
  final String title;
  final String value;
  final String assetIconUrl;
  final Gradient gradient;
  final Color iconColor;
  final Color iconBoxColor;

  const PerformanceBox({
    super.key,
    this.title = "Total orders",
    this.value = "930",
    required this.gradient,
    this.assetIconUrl = SvgAssets.courierIcon,
    this.iconBoxColor = AppColors.transparent,
    this.iconColor = AppColors.secondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.symmetric(vertical: 12.sp, horizontal: 5.sp),
      width: 1.sw,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: customText(
                  title,
                  color: AppColors.blackColor,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Satoshi",
                  fontSize: 12.sp,
                  overflow: TextOverflow.visible,
                ),
              ),
              Container(
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: iconBoxColor),
                padding: EdgeInsets.all(5.sp),
                child: SvgPicture.asset(
                  assetIconUrl,
                  height: 20.sp,
                  color: iconColor,
                  width: 20.sp,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 12.h,
          ),
          customText(
            value,
            color: AppColors.blackColor,
            fontWeight: FontWeight.w600,
            fontFamily: "Satoshi",
            fontSize: 25.sp,
            overflow: TextOverflow.visible,
          ),
        ],
      ),
    );
  }
}
