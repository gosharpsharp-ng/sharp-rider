import 'package:gorider/core/utils/exports.dart';

class DeliveryHistoryWidget extends StatelessWidget {
  final DeliveryHistory history;
  const DeliveryHistoryWidget({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Icon(
          //   Icons.directions_bus_outlined,
          //   color: AppColors.primaryColor,
          //   size: 35.sp,
          // ),

          Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.blueColor.withOpacity(0.2)),
            padding: EdgeInsets.all(5.sp),
            child: SvgPicture.asset(
              SvgAssets.bikeIcon,
              height: 30.sp,
              color: AppColors.blueColor,
              width: 30.sp,
            ),
          ),
          SizedBox(
            width: 10.w,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customText(
                  "${formatDate(history.createdAt)} ${formatTime(history.createdAt)}",
                  fontSize: 13.sp,
                  color: AppColors.obscureTextColor,
                  overflow: TextOverflow.visible),
              SizedBox(
                height: 5.h,
              ),
              customText(
                "Tracking number: ${history.trackingId}",
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
                overflow: TextOverflow.visible,
              ),
              SizedBox(
                height: 5.h,
              ),
              customText(
                "Distance: ${history.distance}km",
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
                overflow: TextOverflow.visible,
              ),
              SizedBox(
                height: 5.h,
              ),
              Row(
                children: [
                  customText(
                    "Earnings: ",
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                    overflow: TextOverflow.visible,
                  ),
                  customText(
                    formatToCurrency(double.parse(history.earning)),
                    fontFamily: "Satoshi",
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                    overflow: TextOverflow.visible,
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
