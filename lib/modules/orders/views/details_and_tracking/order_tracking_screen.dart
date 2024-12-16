import 'package:go_logistics_driver/utils/exports.dart';

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrdersController>(
        builder: (ordersController){
        return Scaffold(
          appBar: defaultAppBar(
            bgColor: AppColors.backgroundColor,
            title: "Order Tracking",
          ),
          backgroundColor: AppColors.backgroundColor,
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 12.sp),
            height: 1.sh,
            width: 1.sw,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.sp, vertical: 10.sp),
                    margin:
                        EdgeInsets.symmetric(horizontal: 10.sp, vertical: 10.sp),
                    width: 1.sw,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        color: AppColors.backgroundColor),
                    child: Image.asset(PngAssets.mapIcon),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.sp, vertical: 10.sp),
                    margin:
                        EdgeInsets.symmetric(horizontal: 10.sp, vertical: 10.sp),
                    width: 1.sw,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        color: AppColors.primaryColor),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(4.sp),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.transparent,
                                border: Border.all(
                                    color: AppColors.whiteColor, width: 1.sp),
                              ),
                              child: SvgPicture.asset(
                                SvgAssets.parcelIcon,
                                color: AppColors.whiteColor,
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  customText(
                                    "Pick up Address",
                                    color: AppColors.whiteColor,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.normal,
                                    overflow: TextOverflow.visible,
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  customText(
                                    "Shop 7, Alaba international market, Alaba market Lagos.",
                                    color: AppColors.whiteColor,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    overflow: TextOverflow.visible,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        const DottedLine(
                          dashLength: 3,
                          dashGapLength: 3,
                          lineThickness: 2,
                          dashColor: AppColors.whiteColor,
                          // lineLength: 150,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(4.sp),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.transparent,
                                border: Border.all(
                                    color: AppColors.whiteColor, width: 1.sp),
                              ),
                              child: SvgPicture.asset(
                                SvgAssets.locationIcon,
                                color: AppColors.secondaryColor,
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  customText(
                                    "Drop off Address",
                                    color: AppColors.whiteColor,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.normal,
                                    overflow: TextOverflow.visible,
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  customText(
                                    "Shop 7, Alaba international market, Alaba market Lagos.",
                                    color: AppColors.whiteColor,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    overflow: TextOverflow.visible,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.sp, vertical: 10.sp),
                    margin:
                        EdgeInsets.symmetric(horizontal: 10.sp, vertical: 10.sp),
                    width: 1.sw,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        color: AppColors.whiteColor),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 15.r,
                              child: Image.asset(PngAssets.avatarIcon),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  customText(
                                    "Abraham Adams",
                                    color: AppColors.blackColor,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    overflow: TextOverflow.visible,
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  customText(
                                    "Courier",
                                    color: AppColors.obscureTextColor,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.normal,
                                    overflow: TextOverflow.visible,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        const DottedLine(
                          dashLength: 3,
                          dashGapLength: 3,
                          lineThickness: 2,
                          dashColor: AppColors.primaryColor,
                          // lineLength: 150,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            OrderTrackingMiniInfoItem(
                              title: "Order status",
                              value: "In transit",
                              isStatus: true,
                            ),
                            OrderTrackingMiniInfoItem(
                              title: "Package weight",
                              value: "840 kg",
                            ),
                            OrderTrackingMiniInfoItem(
                              title: "ETA",
                              value: "24 min",
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        const DottedLine(
                          dashLength: 3,
                          dashGapLength: 3,
                          lineThickness: 2,
                          dashColor: AppColors.primaryColor,
                          // lineLength: 150,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            customText("Shipping progress",
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.obscureTextColor),
                            customText("60%",
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.obscureTextColor),
                          ],
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                         LinearProgressIndicator(
                          value: 0.6,
                          minHeight: 8.h,
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(10.r),
                          backgroundColor: AppColors.fadedButtonPrimaryColor,
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomButton(
                            onPressed: () {
                              showAnyBottomSheet(
                                  isControlled: false,
                                  child: RatingBottomSheet());
                            },
                            // isBusy: signInProvider.isLoading,
                            title: "Rate",
                            width: 1.sw,
                            backgroundColor: AppColors.primaryColor,
                            fontColor: AppColors.whiteColor,
                          ),
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
