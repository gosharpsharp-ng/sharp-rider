
import 'package:go_logistics_driver/utils/exports.dart';
class DeliveryItemWidget extends StatelessWidget {
  const DeliveryItemWidget({super.key, required this.onSelected, required this.shipment});
  final Function onSelected;
  final DeliveryModel shipment;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: AppColors.transparent,
      highlightColor: AppColors.transparent,
      onTap: () {
        onSelected();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: AppColors.whiteColor,
        ),
        // height: 200.h,
        padding: EdgeInsets.symmetric(vertical: 8.sp, horizontal: 8.sp),
        margin: EdgeInsets.symmetric(vertical: 5.sp),
        width: 1.sw,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                color: getStatusColor(shipment.status),
              ),
              padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 3.sp),
              child: customText(
                shipment.status!.capitalizeFirst ?? "",
                fontWeight: FontWeight.normal,
                color: getStatusTextColor(shipment.status),
                fontSize: 12.sp,
                overflow: TextOverflow.visible,
              ),
            ),
            SizedBox(
              height: 5.sp,
            ),
            customText(
              shipment.items[0].name,
              fontWeight: FontWeight.w500,
              fontSize: 20.sp,
              overflow: TextOverflow.visible,
            ),
            SizedBox(
              height: 12.sp,
            ),
            Container(
              width: 1.sw,
              height: 0.15 *1.sh,
              child: Row(
                children: [
                  Container(
                    width: 20.sp,
                    margin: EdgeInsets.only(right: 5.sp),
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          SvgAssets.parcelIcon,
                        ),
                        const Expanded(
                          child: DottedLine(
                            dashLength: 3,
                            dashGapLength: 3,
                            lineThickness: 2,
                            dashColor: AppColors.primaryColor,
                            direction: Axis.vertical,
                            // lineLength: 150,
                          ),
                        ),
                        SvgPicture.asset(
                          SvgAssets.locationIcon,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: customText(
                                  shipment.originLocation.name,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12.sp,
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: customText(
                                  shipment.destinationLocation.name,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12.sp,
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        SvgAssets.rightChevronIcon,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 8.sp,
            ),
            customText("${formatDate( shipment.originLocation.createdAt)} ${formatTime( shipment.originLocation.createdAt)}",
                fontSize: 12.sp,
                color: AppColors.obscureTextColor,
                overflow: TextOverflow.visible),
            SizedBox(
              height: 8.sp,
            ),
          ],
        ),
      ),
    );
  }
}