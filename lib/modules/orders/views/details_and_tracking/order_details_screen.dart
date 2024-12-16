import 'package:go_logistics_driver/utils/exports.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrdersController>(
        builder: (ordersController){
        return Scaffold(
          appBar: defaultAppBar(
            bgColor: AppColors.backgroundColor,
            title: "Order details",
          ),
          backgroundColor: AppColors.backgroundColor,
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 5.sp, vertical: 15.sp),
            height: 1.sh,
            width: 1.sw,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 0.sp, vertical: 5.sp),
                    margin: EdgeInsets.symmetric(horizontal: 6.w),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        color: AppColors.whiteColor),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TitleSectionBox(
                          backgroundColor: AppColors.backgroundColor,
                          title: "Parcel Image(s)",
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Container(
                                    width: 1.sw*0.8,
                                    height: 180.h,
                                    margin: EdgeInsets.only(right: 12.w),
                                    decoration:  BoxDecoration(
                                      image: const DecorationImage(
                                        image: AssetImage(PngAssets.parcel),repeat: ImageRepeat.noRepeat,fit: BoxFit.cover
                                      ),
                                      borderRadius: BorderRadius.circular(12.r)
                                    ),
                                  ), Container(
                                    width: 1.sw*0.8,
                                    height: 180.h,
                                    margin: EdgeInsets.only(right: 12.w),
                                    decoration:  BoxDecoration(
                                      image: const DecorationImage(
                                        image: AssetImage(PngAssets.parcel),repeat: ImageRepeat.noRepeat,fit: BoxFit.cover
                                      ),
                                      borderRadius: BorderRadius.circular(12.r)
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        const TitleSectionBox(
                          backgroundColor: AppColors.backgroundColor,
                          title: "Sender",
                          children: [
                            OrderSummaryDetailItem(
                              titleIconAsset: SvgAssets.profileIcon,
                              title: "Sender",
                              value: "Chinonye Nnamdi",
                            ),
                            OrderSummaryDetailItem(
                              titleIconAsset: SvgAssets.locationIcon,
                              title: "Pick up address",
                              value:
                                  "Shop 7, Alaba international market, Alaba market Lagos.",
                            ),
                            OrderSummaryDetailItem(
                              titleIconAsset: SvgAssets.contactIcon,
                              title: "Contact",
                              value: "+234 (0) 8162848289",
                            ),
                          ],
                        ),
                        const TitleSectionBox(
                          backgroundColor: AppColors.backgroundColor,
                          title: "Receiver",
                          children: [
                            OrderSummaryDetailItem(
                              titleIconAsset: SvgAssets.profileIcon,
                              title: "Receiver",
                              value: "James Abiodun",
                            ),
                            OrderSummaryDetailItem(
                              titleIconAsset: SvgAssets.locationIcon,
                              title: "Drop off address",
                              value:
                                  "Shop 7, Alaba international market, Alaba market Lagos.",
                            ),
                            OrderSummaryDetailItem(
                              titleIconAsset: SvgAssets.contactIcon,
                              title: "Contact",
                              value: "08162848289",
                            ),
                          ],
                        ),
                        TitleSectionBox(
                          backgroundColor: AppColors.backgroundColor,
                          title: "Order information",
                          children: [
                            const OrderSummaryDetailItem(
                              title: "Item name",
                              value: "Electronics",
                            ),
                            const OrderSummaryDetailItem(
                              title: "Category",
                              value: "Electronics",
                            ),
                            const OrderSummaryDetailItem(
                              isVertical: false,
                              title: "Quantity",
                              value: "4",
                            ),
                            const OrderSummaryDetailItem(
                              titleIconAsset: SvgAssets.courierIcon,
                              title: "Courier type",
                              value: "Bike",
                            ),
                            CopyAbleAndClickAbleOrderSummaryDetailItem(
                              title: "Tracking ID",
                              onCopy: () {},
                              onClick: () {
                                // Get.to(const OrderTrackingScreen());
                              },
                              clickableTitle: "Track",
                              value: "1hyr64rktty",
                            ),
                            ClickAbleOrderSummaryDetailItem(
                              title: "Invoice number",
                              onClick: () {
                                Get.to(const OrderInvoiceDetailsScreen());
                              },
                              clickableTitle: "View Invoice",
                              value: "0xfferrw123455",
                            ),
                            const OrderSummaryStatusDetailItem(
                              title: "Status",
                              value: "In transit",
                            ),
                            const OrderSummaryDetailItem(
                              title: "Total amount",
                              value: "#7,000",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomButton(
                      onPressed: () {
                        // Get.to(const OrderTrackingScreen());
                      },
                      // isBusy: signInProvider.isLoading,
                      title: "View on Map",
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
          ),
        );
      }
    );
  }
}
