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
                          .contains(ordersController.selectedDelivery!.status)
                      ? CustomButton(
                          onPressed: () async {
                            final serviceManager = Get.find<ServiceManager>();
                            if (Get.isRegistered<LocationService>()) {
                              await Get.find<LocationService>()
                                  .joinParcelTrackingRoom(
                                      trackingId: ordersController
                                              .selectedDelivery?.trackingId ??
                                          "");
                              Get.find<LocationService>()
                                  .startEmittingParcelLocation(
                                      deliveryModel:
                                          ordersController.selectedDelivery!);
                              Get.find<LocationService>()
                                  .listenForParcelLocationUpdate(
                                      roomId: "rider_tracking");
                            } else {
                              await serviceManager.initializeServices(
                                  ordersController
                                      .settingsController.userProfile!);
                              await Get.find<LocationService>()
                                  .joinParcelTrackingRoom(
                                      trackingId: ordersController
                                              .selectedDelivery?.trackingId ??
                                          "");
                              Get.find<LocationService>()
                                  .startEmittingParcelLocation(
                                      deliveryModel:
                                          ordersController.selectedDelivery!);
                              Get.find<LocationService>()
                                  .listenForParcelLocationUpdate(
                                      roomId: "rider_tracking");
                            }
                            Get.toNamed(Routes.ORDER_TRACKING_SCREEN);
                            if (['delivered', 'rejected', 'canceled'].contains(
                                ordersController.selectedDelivery!.status)) {
                              ordersController.drawPolyLineFromOriginToDestination(
                                  context,
                                  originLatitude: ordersController
                                      .selectedDelivery!
                                      .originLocation
                                      .latitude,
                                  originLongitude: ordersController
                                      .selectedDelivery!
                                      .originLocation
                                      .longitude,
                                  originAddress: ordersController
                                      .selectedDelivery!.originLocation.name,
                                  destinationLatitude: ordersController
                                      .selectedDelivery!
                                      .destinationLocation
                                      .latitude,
                                  destinationLongitude: ordersController
                                      .selectedDelivery!
                                      .destinationLocation
                                      .longitude,
                                  destinationAddress: ordersController
                                      .selectedDelivery!
                                      .destinationLocation
                                      .name);
                            } else if (['accepted'].contains(
                                ordersController.selectedDelivery!.status)) {
                              ordersController
                                  .drawPolylineFromRiderToDestination(context,
                                      destinationPosition: LatLng(
                                          double.parse(ordersController
                                              .selectedDelivery!
                                              .originLocation
                                              .latitude),
                                          double.parse(ordersController
                                              .selectedDelivery!
                                              .originLocation
                                              .longitude)));
                            } else if (['picked'].contains(
                                ordersController.selectedDelivery!.status)) {
                              ordersController
                                  .drawPolylineFromRiderToDestination(context,
                                      destinationPosition: LatLng(
                                          double.parse(ordersController
                                              .selectedDelivery!
                                              .destinationLocation
                                              .latitude),
                                          double.parse(ordersController
                                              .selectedDelivery!
                                              .destinationLocation
                                              .longitude)));
                            }
                          },
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
                                    .selectedDelivery?.originLocation.name ??
                                "",
                          ),
                          OrderSummaryDetailItem(
                            title: "Sender",
                            value:
                                '${ordersController.selectedDelivery?.sender?.firstName ?? ""} ${ordersController.selectedDelivery?.sender?.lastName ?? ""}',
                          ),
                          OrderSummaryDetailItem(
                            title: "Sender's phone",
                            value: ordersController
                                    .selectedDelivery?.sender?.phone ??
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
                                    .selectedDelivery?.receiver.name ??
                                "",
                          ),
                          OrderSummaryDetailItem(
                            titleIconAsset: SvgAssets.locationIcon,
                            title: "Drop off address",
                            value: ordersController.selectedDelivery
                                    ?.destinationLocation.name ??
                                "",
                          ),
                          OrderSummaryDetailItem(
                            titleIconAsset: SvgAssets.contactIcon,
                            title: "Receiver's phone",
                            value: ordersController
                                    .selectedDelivery?.receiver.phone ??
                                "",
                          ),
                        ],
                      ),
                      TitleSectionBox(
                        backgroundColor: AppColors.backgroundColor,
                        title: "Delivery Items",
                        children: [
                          ...List.generate(
                              ordersController.selectedDelivery!.items.length,
                              (i) => OrderItemAccordion(
                                  shipmentItemData: ordersController
                                      .selectedDelivery!.items[i]))
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
                                ordersController.selectedDelivery?.trackingId ??
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
                                ordersController.selectedDelivery?.status ?? "",
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
