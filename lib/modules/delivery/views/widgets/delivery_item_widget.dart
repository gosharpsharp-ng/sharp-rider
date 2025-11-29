import 'package:gorider/core/utils/exports.dart';

class DeliveryItemWidget extends StatelessWidget {
  const DeliveryItemWidget({
    super.key,
    required this.onSelected,
    required this.shipment,
  });
  final Function onSelected;
  final DeliveryModel shipment;

  // /// Get pickup address - tries displayName first, falls back to raw name
  // String get pickupAddress {
  //   final location = shipment.originLocation;
  //   // First try displayName (strips prefix)
  //   if (location.displayName.isNotEmpty) {
  //     return location.displayName;
  //   }
  //   // Fall back to raw name if available
  //   if (location.name != null && location.name!.isNotEmpty) {
  //     return location.name!;
  //   }
  //   return 'Not specified';
  // }

  // /// Get dropoff address - tries displayName first, falls back to raw name
  // String get dropoffAddress {
  //   final location = shipment.destinationLocation;
  //   // First try displayName (strips prefix)
  //   if (location.displayName.isNotEmpty) {
  //     return location.displayName;
  //   }
  //   // Fall back to raw name if available
  //   if (location.name != null && location.name!.isNotEmpty) {
  //     return location.name!;
  //   }
  //   return 'Not specified';
  // }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onSelected(),
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: AppColors.whiteColor,
        ),
        padding: EdgeInsets.all(12.sp),
        margin: EdgeInsets.symmetric(vertical: 5.sp),
        width: 1.sw,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row: Status badge + Amount + Chevron
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.r),
                    color: getStatusColor(shipment.status),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 8.sp, vertical: 4.sp),
                  child: customText(
                    shipment.status?.capitalizeFirst ?? "",
                    fontWeight: FontWeight.w500,
                    color: getStatusTextColor(shipment.status),
                    fontSize: 11.sp,
                  ),
                ),
                const Spacer(),
                customText(
                  formatToCurrency(double.tryParse(shipment.cost) ?? 0),
                  fontWeight: FontWeight.w600,
                  fontSize: 15.sp,
                  color: AppColors.primaryColor,
                ),
                SizedBox(width: 8.w),
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.obscureTextColor,
                  size: 20.sp,
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // Tracking ID Row
            Row(
              children: [
                Icon(
                  Icons.local_shipping_outlined,
                  color: AppColors.obscureTextColor,
                  size: 16.sp,
                ),
                SizedBox(width: 6.w),
                customText(
                  shipment.trackingId,
                  fontWeight: FontWeight.w500,
                  fontSize: 13.sp,
                  color: AppColors.blackColor,
                ),
                SizedBox(width: 8.w),
                InkWell(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: shipment.trackingId));
                    showToast(message: "Tracking ID copied!");
                  },
                  child: Icon(
                    Icons.copy_rounded,
                    color: AppColors.primaryColor,
                    size: 16.sp,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // Locations Section - Commented out for now (API list endpoint doesn't include locations)
            // Container(
            //   padding: EdgeInsets.all(10.sp),
            //   decoration: BoxDecoration(
            //     color: AppColors.backgroundColor,
            //     borderRadius: BorderRadius.circular(8.r),
            //   ),
            //   child: Row(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       // Location Icons Column
            //       Column(
            //         children: [
            //           Container(
            //             width: 24.sp,
            //             height: 24.sp,
            //             decoration: BoxDecoration(
            //               color: AppColors.primaryColor.withOpacity(0.1),
            //               shape: BoxShape.circle,
            //             ),
            //             child: Icon(
            //               Icons.radio_button_checked,
            //               color: AppColors.primaryColor,
            //               size: 14.sp,
            //             ),
            //           ),
            //           Container(
            //             width: 2,
            //             height: 24.h,
            //             color: AppColors.primaryColor.withOpacity(0.3),
            //           ),
            //           Container(
            //             width: 24.sp,
            //             height: 24.sp,
            //             decoration: BoxDecoration(
            //               color: AppColors.greenColor.withOpacity(0.1),
            //               shape: BoxShape.circle,
            //             ),
            //             child: Icon(
            //               Icons.location_on,
            //               color: AppColors.greenColor,
            //               size: 14.sp,
            //             ),
            //           ),
            //         ],
            //       ),
            //       SizedBox(width: 10.w),
            //
            //       // Location Details Column
            //       Expanded(
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             // Pickup Location
            //             Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 customText(
            //                   "Pickup",
            //                   fontSize: 10.sp,
            //                   fontWeight: FontWeight.w400,
            //                   color: AppColors.obscureTextColor,
            //                 ),
            //                 SizedBox(height: 2.h),
            //                 customText(
            //                   pickupAddress,
            //                   fontSize: 12.sp,
            //                   fontWeight: FontWeight.w500,
            //                   color: AppColors.blackColor,
            //                   overflow: TextOverflow.ellipsis,
            //                   maxLines: 2,
            //                 ),
            //               ],
            //             ),
            //             SizedBox(height: 12.h),
            //
            //             // Dropoff Location
            //             Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 customText(
            //                   "Dropoff",
            //                   fontSize: 10.sp,
            //                   fontWeight: FontWeight.w400,
            //                   color: AppColors.obscureTextColor,
            //                 ),
            //                 SizedBox(height: 2.h),
            //                 customText(
            //                   dropoffAddress,
            //                   fontSize: 12.sp,
            //                   fontWeight: FontWeight.w500,
            //                   color: AppColors.blackColor,
            //                   overflow: TextOverflow.ellipsis,
            //                   maxLines: 2,
            //                 ),
            //               ],
            //             ),
            //           ],
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // SizedBox(height: 10.h),

            // Footer: Date/Time + Distance
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      color: AppColors.obscureTextColor,
                      size: 14.sp,
                    ),
                    SizedBox(width: 4.w),
                    customText(
                      "${formatDate(shipment.createdAt)} ${formatTime(shipment.createdAt)}",
                      fontSize: 11.sp,
                      color: AppColors.obscureTextColor,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.straighten_rounded,
                      color: AppColors.obscureTextColor,
                      size: 14.sp,
                    ),
                    SizedBox(width: 4.w),
                    customText(
                      shipment.distance.isNotEmpty ? shipment.distance : '--',
                      fontSize: 11.sp,
                      color: AppColors.obscureTextColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
