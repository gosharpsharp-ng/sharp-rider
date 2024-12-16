import 'package:go_logistics_driver/modules/orders/views/details_and_tracking/order_pre_acceptance_details_screen.dart';
import 'package:go_logistics_driver/utils/exports.dart';

class OrderItemWidget extends StatelessWidget {
  const OrderItemWidget({super.key, this.status="Pending"});
  final String status;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: AppColors.transparent,
      highlightColor: AppColors.transparent,
      onTap: () {
        if(status== "Pending"){
          Get.to(const OrderPreAcceptanceDetailsScreen());
        }else{
          Get.to(const OrderDetailsScreen());
        }
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color:  status== "Pending"?AppColors.pendingBgColor:AppColors.successBgColor,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 3.sp),
                  child: customText(
                    status,
                    fontWeight: FontWeight.w500,
                    color:  status== "Pending"?AppColors.pendingTexColor:AppColors.successTexColor,
                    fontSize: 12.sp,
                    overflow: TextOverflow.visible,
                  ),
                ),
                customText("Thu. Nov 28, 2024 12:33 pm",
                    fontSize: 12.sp,
                    color: AppColors.obscureTextColor,
                    overflow: TextOverflow.visible),
              ],
            ),
            SizedBox(
              height: 5.sp,
            ),
            customText(
              "Rice bag from Rayfield to Uni-jos",
              fontWeight: FontWeight.w500,
              fontSize: 16.sp,
              overflow: TextOverflow.visible,
            ),
            SizedBox(
              height: 12.sp,
            ),
            Container(
              width: 1.sw,
              height: 70.h,
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
                                  "PRTV round-about, Rayfield, Jos",
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14.sp,
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
                                  "University of Jos, Main Campus",
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14.sp,
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
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Row(
                  //       mainAxisAlignment: MainAxisAlignment.start,
                  //       children: [
                  //         SvgPicture.asset(
                  //           SvgAssets.parcelIcon,
                  //         ),
                  //         SizedBox(
                  //           width: 5.sp,
                  //         ),
                  //         Expanded(
                  //             child: customText("Pick up location address",
                  //                 fontWeight: FontWeight.w600,
                  //                 fontSize: 13.sp,
                  //                 overflow: TextOverflow.visible)),
                  //       ],
                  //     ),
                  //     SizedBox(
                  //       height: 3.sp,
                  //     ),
                  //     Row(
                  //       children: [
                  //         SizedBox(
                  //           width: 5.sp,
                  //         ),
                  //         CircleAvatar(
                  //           radius: 2.r,
                  //           backgroundColor: AppColors.primaryColor,
                  //         ),
                  //         SizedBox(
                  //           width: 3.sp,
                  //         ),
                  //         Expanded(
                  //             child: customText("Thu. Nov 28, 2024 12:33 pm",
                  //                 fontSize: 11.sp,
                  //                 color: AppColors.obscureTextColor,
                  //                 overflow: TextOverflow.visible)),
                  //       ],
                  //     ),
                  //     Container(
                  //       margin: EdgeInsets.only(left: 8.sp),
                  //       child: DottedDivider(
                  //         length: 15.sp,
                  //         dotSize: 2.sp,
                  //         spacing: 2.sp,
                  //         color: AppColors.obscureTextColor,
                  //       ),
                  //     ),
                  //     Row(
                  //       mainAxisAlignment: MainAxisAlignment.start,
                  //       children: [
                  //         SvgPicture.asset(
                  //           SvgAssets.locationIcon,
                  //         ),
                  //         SizedBox(
                  //           width: 5.sp,
                  //         ),
                  //         Expanded(
                  //           child: customText(
                  //             "Drop off location address",
                  //             fontWeight: FontWeight.w600,
                  //             fontSize: 13.sp,
                  //             overflow: TextOverflow.visible,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //     SizedBox(
                  //       height: 5.sp,
                  //     ),
                  //     Row(
                  //       children: [
                  //         SizedBox(
                  //           width: 5.sp,
                  //         ),
                  //         CircleAvatar(
                  //           radius: 2.r,
                  //           backgroundColor: AppColors.primaryColor,
                  //         ),
                  //         SizedBox(
                  //           width: 3.sp,
                  //         ),
                  //         Expanded(
                  //           child: customText(
                  //             "Thu. Nov 28, 2024 12:33 pm",
                  //             color: AppColors.obscureTextColor,
                  //             fontSize: 11.sp,
                  //             overflow: TextOverflow.visible,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //     SizedBox(
                  //       height: 11.sp,
                  //     ),
                  //     // Row(
                  //     //   mainAxisAlignment: MainAxisAlignment.start,
                  //     //   children: [
                  //     //     SvgPicture.asset(
                  //     //       SvgAssets.time,
                  //     //     ),
                  //     //     SizedBox(
                  //     //       width: 5.sp,
                  //     //     ),
                  //     //     // customText("Tuesday, 28th August, 2024",
                  //     //     //     fontSize: 12.sp),
                  //     //
                  //     //     customText(formatRideDate(rideRequest.rideDetails.rideDate), fontSize: 12.sp),
                  //     //     SizedBox(
                  //     //       width: 8.sp,
                  //     //     ),
                  //     //     SvgPicture.asset(
                  //     //       SvgAssets.time,
                  //     //     ),
                  //     //     SizedBox(
                  //     //       width: 2.sp,
                  //     //     ),
                  //     //     customText(
                  //     //       formatRideTime(rideRequest.rideDetails.rideDate),
                  //     //       fontSize: 12.sp,
                  //     //     ),
                  //     //   ],
                  //     // ),
                  //   ],
                  // ),
                ],
              ),
            ),
            SizedBox(
              height: 8.sp,
            ),
          ],
        ),
      ),
    );
  }
}
