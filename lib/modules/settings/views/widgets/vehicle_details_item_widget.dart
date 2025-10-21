import 'package:gorider/core/utils/exports.dart';

class VehicleDetailItem extends StatelessWidget {
  final String title;
  final String value;
  final String titleIconAsset;
  final bool isVertical;
  const VehicleDetailItem(
      {super.key,
      this.title = "",
      this.value = "",
      this.isVertical = true,
      this.titleIconAsset = ""});

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
                Row(
                  children: [
                    Visibility(
                      visible: titleIconAsset.length > 1,
                      child: Container(
                        margin: EdgeInsets.only(right: 5.sp),
                        child: SvgPicture.asset(
                          titleIconAsset,
                          height: 15.sp,
                          width: 15.sp,
                        ),
                      ),
                    ),
                    customText(title,
                        color: AppColors.obscureTextColor,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.normal),
                  ],
                ),
                SizedBox(
                  height: 8.h,
                ),
                customText(
                  value,
                  color: AppColors.blackColor,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  overflow: TextOverflow.visible,
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Visibility(
                      visible: titleIconAsset.length > 1,
                      child: Container(
                        margin: EdgeInsets.only(right: 5.sp),
                        child: SvgPicture.asset(
                          titleIconAsset,
                          height: 15.sp,
                          width: 15.sp,
                        ),
                      ),
                    ),
                    customText("$title:",
                        color: AppColors.obscureTextColor,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.normal),
                  ],
                ),
                customText(
                  value,
                  color: AppColors.blackColor,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  overflow: TextOverflow.visible,
                ),
              ],
            ),
    );
  }
}
