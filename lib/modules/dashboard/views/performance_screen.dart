import 'package:go_logistics_driver/modules/dashboard/views/widgets/delivery_history_widget.dart';
import 'package:go_logistics_driver/utils/exports.dart';

class PerformanceScreen extends StatelessWidget {
  const PerformanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DeliveriesController>(builder: (ordersController) {
      return Scaffold(
        appBar: flatAppBar(
          bgColor: AppColors.backgroundColor,
          navigationColor: AppColors.backgroundColor,
        ),
        backgroundColor: AppColors.backgroundColor,
        body: Scaffold(
          appBar: defaultAppBar(
              title: "Performance", bgColor: AppColors.backgroundColor),
          body: Container(
            padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 8.w),
            height: 1.sh,
            width: 1.sw,
            color: AppColors.backgroundColor,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  SizedBox(
                    width: 1.sw,
                    child: Row(
                      children: [
                        Expanded(
                          child: PerformanceBox(
                            assetIconUrl: SvgAssets.parcelIcon,
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFFFF6E3),
                                Color(0xFFFFFFFF),
                              ],
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                            ),
                            title: "Total Orders",
                            value:
                                "${ordersController.riderStatsModel?.totalOrders ?? 0}",
                            iconColor: AppColors.foundationColor,
                            iconBoxColor: AppColors.foundationBgColor,
                          ),
                        ),
                        Expanded(
                          child: PerformanceBox(
                            assetIconUrl: SvgAssets.bikeIcon,
                            title: "Distance Traveled",
                            value:
                                "${ordersController.riderStatsModel?.totalDistance ?? 0}km",
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFE3EDFF),
                                Color(0xFFFFFFFF),
                              ],
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                            ),
                            iconColor: AppColors.blueColor,
                            iconBoxColor: AppColors.transparent,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Container(
                    width: 1.sw,
                    margin: EdgeInsets.symmetric(horizontal: 2.w),
                    padding: EdgeInsets.symmetric(
                        vertical: 18.sp, horizontal: 15.sp),
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFE7FFE3),
                            Color(0xFFFFFFFF),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(14.r)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customText("Total Income",
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 20.sp,
                            overflow: TextOverflow.visible),
                        SizedBox(
                          height: 20.h,
                        ),
                        customText(
                            formatToCurrency(double.parse(ordersController
                                        .riderStatsModel?.totalEarnings
                                        .toString() ??
                                    "0") ??
                                0),
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.w600,
                            fontFamily: GoogleFonts.montserrat().fontFamily!,
                            fontSize: 25.sp,
                            overflow: TextOverflow.visible),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Container(
                    width: 1.sw,
                    margin: EdgeInsets.symmetric(horizontal: 2.w),
                    padding: EdgeInsets.symmetric(
                        vertical: 18.sp, horizontal: 15.sp),
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFFFF6E3),
                            Color(0xFFFFFFFF),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(14.r)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customText("Total Rating",
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 20.sp,
                            overflow: TextOverflow.visible),
                        SizedBox(
                          height: 10.h,
                        ),
                        RatingBarIndicator(
                          rating: ordersController
                                  .riderRatingStatsModel?.averageRating ??
                              0.0,
                          itemBuilder: (context, index) => Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 12.sp,
                          ),
                          itemCount: 5,
                          itemSize: 30.0,
                          direction: Axis.horizontal,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            customText(
                                "${ordersController.riderRatingStatsModel?.reviews.length ?? 0}",
                                color: AppColors.blackColor,
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp,
                                overflow: TextOverflow.visible),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: customText("Earnings History",
                            fontWeight: FontWeight.w500,
                            fontSize: 18.sp,
                            color: AppColors.blackColor),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  ordersController.riderStatsModel != null
                      ? Column(
                          children: [
                            ordersController.riderStatsModel!.shipments.isEmpty
                                ? SizedBox(
                                    width: 1.sw,
                                    height: 1.sh * 0.4,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        customText(
                                          ordersController.fetchingDeliveries
                                              ? "Loading..."
                                              : "You have not handled any delivery",
                                        ),
                                      ],
                                    ),
                                  )
                                : Column(children: [
                                    ...List.generate(
                                      ordersController
                                          .riderStatsModel!.shipments.length,
                                      (i) => DeliveryHistoryWidget(
                                        history: ordersController
                                            .riderStatsModel!.shipments[i],
                                      ),
                                    ),
                                  ]),
                          ],
                        )
                      : SizedBox.shrink(),
                  SizedBox(
                    height: 15.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
