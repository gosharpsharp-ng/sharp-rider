import 'dart:convert';
import 'dart:developer';

import 'package:geolocator/geolocator.dart';

import 'package:go_logistics_driver/utils/exports.dart';

class DeliveryNotificationService extends GetxService {
  static DeliveryNotificationService get instance => Get.find();

  bool _isDialogShowing = false;

  initialize() async {
    if (Get.isRegistered<SocketService>() &&
        Get.find<SocketService>().isConnected.value == true) {
      Get.find<SocketService>().joinRiderRoom();
    }
  }

  void handleDialogDismissal() {
    if (_isDialogShowing) {
      _isDialogShowing = false;
    }
  }

  void handleDeliveryNotification(dynamic data) async {
    try {
      Position currentPosition = Get.find<LocationService>().currentPosition!;
      final parsedData = data is String ? jsonDecode(data) : data;
      final DeliveryNotificationModel delivery =
          DeliveryNotificationModel.fromJson(parsedData);
      var originLatLng = LatLng(double.parse(delivery.originLocation.latitude),
          double.parse(delivery.originLocation.longitude));
      var destinationLatLng = LatLng(
          double.parse(delivery.destinationLocation.latitude),
          double.parse(delivery.destinationLocation.longitude));
      var currentLatLng =
          LatLng(currentPosition.latitude, currentPosition.longitude);

      var senderToReceiverDirectionDetails =
          await obtainOriginToDestinationDirectionDetails(
              originLatLng, destinationLatLng);
      var riderToSenderDirectionDetails =
          await obtainOriginToDestinationDirectionDetails(
              currentLatLng, originLatLng);

      if (!_isDialogShowing &&
          !(Get.find<DeliveriesController>()
                  .rejectedDeliveries
                  .contains(delivery.trackingId) &&
              Get.find<DeliveriesController>()
                  .pickedDeliveries
                  .contains(delivery.trackingId))) {
        FlutterRingtonePlayer().playRingtone();
        showDeliveryDialog(
            shipment: delivery,
            riderToSenderDirectionDetails: riderToSenderDirectionDetails,
            senderToReceiverDirectionDetails: senderToReceiverDirectionDetails);
      }
    } catch (e) {
      log('Error handling shipment notification: $e');
    }
  }

  void showDeliveryDialog(
      {required DeliveryNotificationModel shipment,
      required DirectionDetailsInfo senderToReceiverDirectionDetails,
      required DirectionDetailsInfo riderToSenderDirectionDetails}) {
    _isDialogShowing = true;

    Get.dialog(
      Builder(
        builder: (context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: GetBuilder<DeliveriesController>(
                builder: (deliveriesController) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 5),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      customText(
                        'New Order Available!',
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.sp, vertical: 10.sp),
                        margin: EdgeInsets.symmetric(
                            horizontal: 5.sp, vertical: 10.sp),
                        width: 1.sw,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            color: AppColors.greenColor.withOpacity(0.92)),
                        child: Column(
                          children: [
                            customText(
                                formatToCurrency(double.parse(shipment.cost)),
                                fontSize: 25.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.whiteColor,
                                textAlign: TextAlign.center,
                                fontFamily:
                                    GoogleFonts.montserrat().fontFamily!),
                            SizedBox(
                              height: 15.sp,
                            ),
                            customText(
                                "Distance to pickup\n ${riderToSenderDirectionDetails.distance_text}",
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.whiteColor,
                                textAlign: TextAlign.center,
                                fontFamily:
                                    GoogleFonts.montserrat().fontFamily!),
                            SizedBox(
                              height: 25.sp,
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(4.sp),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.transparent,
                                    border: Border.all(
                                        color: AppColors.whiteColor,
                                        width: 1.sp),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      customText(
                                        "Pick up Address",
                                        color: AppColors.whiteColor,
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.normal,
                                        overflow: TextOverflow.visible,
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      customText(
                                        shipment.originLocation.name ?? "",
                                        color: AppColors.whiteColor,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500,
                                        overflow: TextOverflow.visible,
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      customText(
                                        "From You to Pickup: ${riderToSenderDirectionDetails.distance_text}",
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
                                        color: AppColors.whiteColor,
                                        width: 1.sp),
                                  ),
                                  child: SvgPicture.asset(
                                    SvgAssets.locationIcon,
                                    color: AppColors.whiteColor,
                                  ),
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      customText(
                                        "Drop off Address",
                                        color: AppColors.whiteColor,
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.normal,
                                        overflow: TextOverflow.visible,
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      customText(
                                        shipment.destinationLocation.name ?? "",
                                        color: AppColors.whiteColor,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500,
                                        overflow: TextOverflow.visible,
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      customText(
                                        "From Pickup to Destination: ${senderToReceiverDirectionDetails.distance_text}",
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
                      SizedBox(
                        height: 20.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Expanded(
                          //   child: CustomButton(
                          //     onPressed: () {
                          //       Get.back();
                          //       _isDialogShowing = false;
                          //     },
                          //     title: "Reject",
                          //     backgroundColor: AppColors.redColor,
                          //   ),
                          // ),
                          Expanded(
                            child: InkWell(
                                splashColor: AppColors.transparent,
                                highlightColor: AppColors.transparent,
                                onTap: () {
                                  deliveriesController.rejectedDeliveries
                                      .add(shipment.trackingId);
                                  deliveriesController.rejectDelivery(
                                    trackingId: shipment.trackingId,
                                  );
                                  Get.back();
                                  _isDialogShowing = false;
                                  FlutterRingtonePlayer().stop();
                                },
                                child: Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 12.w),
                                    child: customText("Reject",
                                        textAlign: TextAlign.center,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.obscureTextColor))),
                          ),

                          Expanded(
                            child: CustomButton(
                              onPressed: () async {
                                FlutterRingtonePlayer().stop();
                                await deliveriesController.acceptDelivery(
                                  context,
                                  trackingId: shipment.trackingId,
                                );

                                if (deliveriesController.acceptedDelivery) {
                                  _isDialogShowing = false;
                                  Navigator.of(context).pop();
                                  Get.toNamed(Routes.DELIVERY_TRACKING_SCREEN);
                                  deliveriesController.fetchDeliveries();
                                  Get.find<LocationService>()
                                      .startEmittingParcelLocation(
                                          deliveryModel: deliveriesController
                                              .selectedDelivery!);
                                  deliveriesController
                                      .drawPolylineFromRiderToDestination(
                                          context,
                                          destinationPosition: LatLng(
                                              double.parse(deliveriesController
                                                  .selectedDelivery!
                                                  .originLocation
                                                  .latitude),
                                              double.parse(deliveriesController
                                                  .selectedDelivery!
                                                  .originLocation
                                                  .longitude)));
                                }
                              },
                              title: "Accept",
                              isBusy: deliveriesController.acceptingDelivery,
                              backgroundColor: AppColors.greenColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          );
        },
      ),
      barrierDismissible: false,
    );
  }
}
