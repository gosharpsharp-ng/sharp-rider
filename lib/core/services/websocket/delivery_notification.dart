import 'dart:convert';
import 'dart:developer';

import 'package:geolocator/geolocator.dart';

import 'package:gorider/core/utils/exports.dart';

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
              .contains(delivery.trackingId)) &&
          !(Get.find<DeliveriesController>()
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
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Container(
                  padding: EdgeInsets.all(24.sp),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Bike icon at the top
                      Container(
                        width: 80.sp,
                        height: 80.sp,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFC107), // Yellow color
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            SvgAssets.bikeIcon,
                            width: 50.sp,
                            height: 50.sp,
                            colorFilter: const ColorFilter.mode(
                              AppColors.blackColor,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // Title
                      customText(
                        'New Incoming Order',
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackColor,
                      ),
                      SizedBox(height: 24.h),

                      // Amount row
                      _buildInfoRow(
                        label: 'Amount',
                        value: formatToCurrency(double.parse(shipment.cost)),
                      ),
                      SizedBox(height: 16.h),

                      // From row
                      _buildInfoRow(
                        label: 'From',
                        value: shipment.originLocation.name,
                      ),
                      SizedBox(height: 16.h),

                      // To row
                      _buildInfoRow(
                        label: 'To',
                        value: shipment.destinationLocation.name,
                      ),
                      SizedBox(height: 16.h),

                      // Distance row
                      _buildInfoRow(
                        label: 'Distance',
                        value: senderToReceiverDirectionDetails.distance_text ?? '',
                      ),
                      SizedBox(height: 32.h),

                      // Action buttons
                      Row(
                        children: [
                          // Decline button
                          Expanded(
                            child: InkWell(
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
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFE5E5), // Light red
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Center(
                                  child: customText(
                                    'Decline',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFFD32F2F), // Red text
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),

                          // Accept button
                          Expanded(
                            child: InkWell(
                              onTap: deliveriesController.acceptingDelivery
                                  ? null
                                  : () async {
                                      FlutterRingtonePlayer().stop();
                                      final BuildContext dialogContext = context;
                                      await deliveriesController.acceptDelivery(
                                        dialogContext,
                                        trackingId: shipment.trackingId,
                                      );

                                      if (deliveriesController.acceptedDelivery) {
                                        _isDialogShowing = false;
                                        if (dialogContext.mounted) {
                                          Navigator.of(dialogContext).pop();
                                        }
                                        Get.toNamed(Routes.DELIVERY_TRACKING_SCREEN);
                                        deliveriesController.fetchDeliveries();
                                        Get.find<LocationService>()
                                            .startEmittingParcelLocation(
                                                deliveryModel: deliveriesController
                                                    .selectedDelivery!);
                                        if (dialogContext.mounted) {
                                          deliveriesController
                                              .drawPolylineFromRiderToDestination(
                                                  dialogContext,
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
                                      }
                                    },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2E7D32), // Dark green
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Center(
                                  child: deliveriesController.acceptingDelivery
                                      ? SizedBox(
                                          width: 20.sp,
                                          height: 20.sp,
                                          child: const CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    AppColors.whiteColor),
                                          ),
                                        )
                                      : customText(
                                          'Accept',
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.whiteColor,
                                        ),
                                ),
                              ),
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

  Widget _buildInfoRow({required String label, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        customText(
          label,
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.obscureTextColor,
        ),
        Flexible(
          child: customText(
            value,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.blackColor,
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
