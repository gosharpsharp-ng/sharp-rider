import 'package:go_logistics_driver/modules/orders/views/widgets/order_item_accordion.dart';
import 'package:go_logistics_driver/utils/exports.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrdersController>(builder: (ordersController) {
      return Scaffold(
        appBar: defaultAppBar(
          bgColor: AppColors.backgroundColor,
          title: "Order details",
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.r),
              topRight: Radius.circular(12.r),
            ),
            color: AppColors.whiteColor,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ['accepted', 'picked', 'delivered']
                          .contains(ordersController.selectedShipment!.status)
                      ? CustomButton(
                          onPressed: () {
                            Get.toNamed(Routes.ORDER_TRACKING_SCREEN);
                            ordersController.drawPolyLineFromOriginToDestination(
                                context,
                                originLatitude: ordersController
                                    .selectedShipment!.originLocation.latitude,
                                originLongitude: ordersController
                                    .selectedShipment!.originLocation.longitude,
                                originAddress: ordersController
                                    .selectedShipment!.originLocation.name,
                                destinationLatitude: ordersController
                                    .selectedShipment!
                                    .destinationLocation
                                    .latitude,
                                destinationLongitude: ordersController
                                    .selectedShipment!
                                    .destinationLocation
                                    .longitude,
                                destinationAddress: ordersController
                                    .selectedShipment!
                                    .destinationLocation
                                    .name);
                          },
                          // isBusy: signInProvider.isLoading,
                          title: "View Progress",
                          width: 1.sw,
                          backgroundColor: AppColors.primaryColor,
                          fontColor: AppColors.whiteColor,
                        )
                      : const SizedBox.shrink())
            ],
          ),
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
                      SectionBox(
                        backgroundColor: AppColors.backgroundColor,
                        children: [
                          OrderSummaryDetailItem(
                            title: "Pick up address",
                            value: ordersController
                                    .selectedShipment?.originLocation.name ??
                                "",
                          ),
                          OrderSummaryDetailItem(
                            title: "Sender",
                            value:
                                '${ordersController.selectedShipment?.sender?.firstName ?? ""} ${ordersController.selectedShipment?.sender?.lastName ?? ""}',
                          ),
                          OrderSummaryDetailItem(
                            title: "Sender's phone",
                            value: ordersController
                                    .selectedShipment?.sender?.phone ??
                                "",
                          ),
                        ],
                      ),
                      SectionBox(
                        backgroundColor: AppColors.backgroundColor,
                        children: [
                          OrderSummaryDetailItem(
                            titleIconAsset: SvgAssets.profileIcon,
                            title: "Receiver's name",
                            value: ordersController
                                    .selectedShipment?.receiver.name ??
                                "",
                          ),
                          OrderSummaryDetailItem(
                            titleIconAsset: SvgAssets.locationIcon,
                            title: "Drop off address",
                            value: ordersController.selectedShipment
                                    ?.destinationLocation.name ??
                                "",
                          ),
                          OrderSummaryDetailItem(
                            titleIconAsset: SvgAssets.contactIcon,
                            title: "Receiver's phone",
                            value: ordersController
                                    .selectedShipment?.receiver.phone ??
                                "",
                          ),
                        ],
                      ),
                      TitleSectionBox(
                        backgroundColor: AppColors.backgroundColor,
                        title: "Shipment Items",
                        children: [
                          ...List.generate(
                              ordersController.selectedShipment!.items.length,
                              (i) => OrderItemAccordion(
                                  shipmentItemData: ordersController
                                      .selectedShipment!.items[i]))
                        ],
                      ),
                      SectionBox(
                        backgroundColor: AppColors.backgroundColor,
                        children: [
                          CopyAbleAndClickAbleOrderSummaryDetailItem(
                            title: "Tracking ID",
                            onCopy: () {},
                            onClick: () {
                              // Get.to(const OrderTrackingScreen());
                            },
                            clickableTitle: "Track",
                            value:
                                ordersController.selectedShipment?.trackingId ??
                                    "",
                          ),
                          // ClickAbleOrderSummaryDetailItem(
                          //   title: "Invoice number",
                          //   onClick: () {
                          //     Get.to(const OrderInvoiceDetailsScreen());
                          //   },
                          //   clickableTitle: "View Invoice",
                          //   value: "0xfferrw123455",
                          // ),
                          OrderSummaryStatusDetailItem(
                            title: "Status",
                            value:
                                ordersController.selectedShipment?.status ?? "",
                          ),
                          const OrderSummaryDetailItem(
                              title: "Total amount",
                              // value: formatToCurrency(double.parse(ordersController.selectedShipment?. ?? "")),
                              value: ""),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
