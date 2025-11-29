import 'package:gorider/core/utils/exports.dart';

class DeliveryTrackingIdWidget extends StatelessWidget {
  const DeliveryTrackingIdWidget({
    super.key,
    required this.trackingId,
    this.backgroundColor,
    this.showIcon = true,
  });

  final String trackingId;
  final Color? backgroundColor;
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 12.sp),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: backgroundColor ?? AppColors.backgroundColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (showIcon) ...[
                Icon(
                  Icons.electric_moped,
                  color: AppColors.primaryColor,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
              ],
              customText(
                "Tracking ID:",
                color: AppColors.obscureTextColor,
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
          Row(
            children: [
              customText(
                trackingId,
                color: AppColors.primaryColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(width: 8.w),
              InkWell(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: trackingId));
                  showToast(message: "Tracking ID copied!");
                },
                child: Icon(
                  Icons.copy_rounded,
                  color: AppColors.primaryColor,
                  size: 18.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
