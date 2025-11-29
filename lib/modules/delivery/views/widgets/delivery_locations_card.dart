import 'package:gorider/core/utils/exports.dart';

class DeliveryLocationsCard extends StatelessWidget {
  const DeliveryLocationsCard({
    super.key,
    required this.pickupAddress,
    required this.dropoffAddress,
    this.margin,
  });

  final String pickupAddress;
  final String dropoffAddress;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.sp),
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: AppColors.whiteColor,
      ),
      child: Column(
        children: [
          // Pickup Location
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(8.sp),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryColor.withOpacity(0.1),
                ),
                child: SvgPicture.asset(
                  SvgAssets.parcelIcon,
                  colorFilter: const ColorFilter.mode(
                    AppColors.primaryColor,
                    BlendMode.srcIn,
                  ),
                  width: 18.sp,
                  height: 18.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customText(
                      "Pickup Address",
                      color: AppColors.obscureTextColor,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    SizedBox(height: 4.h),
                    customText(
                      pickupAddress.isNotEmpty
                          ? pickupAddress
                          : "Not specified",
                      color: AppColors.blackColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      overflow: TextOverflow.visible,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          DottedLine(
            dashLength: 4,
            dashGapLength: 4,
            lineThickness: 1.5,
            dashColor: AppColors.greyColor.withOpacity(0.5),
          ),
          SizedBox(height: 12.h),

          // Dropoff Location
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(8.sp),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.secondaryColor.withOpacity(0.1),
                ),
                child: SvgPicture.asset(
                  SvgAssets.locationIcon,
                  colorFilter: const ColorFilter.mode(
                    AppColors.secondaryColor,
                    BlendMode.srcIn,
                  ),
                  width: 18.sp,
                  height: 18.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customText(
                      "Destination",
                      color: AppColors.obscureTextColor,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    SizedBox(height: 4.h),
                    customText(
                      dropoffAddress.isNotEmpty
                          ? dropoffAddress
                          : "Not specified",
                      color: AppColors.blackColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      overflow: TextOverflow.visible,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
