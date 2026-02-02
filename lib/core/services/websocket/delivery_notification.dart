import 'dart:convert';
import 'dart:developer';

import 'package:geolocator/geolocator.dart';
import 'package:vibration/vibration.dart';

import 'package:gorider/core/utils/exports.dart';

class DeliveryNotificationService extends GetxService {
  static DeliveryNotificationService get instance => Get.find();

  bool _isDialogShowing = false;
  String? _currentNotificationTrackingId;
  final Set<String> _processedNotifications = {};

  initialize() async {
    if (Get.isRegistered<SocketService>() &&
        Get.find<SocketService>().isConnected.value == true) {
      Get.find<SocketService>().joinRiderRoom();
    }
  }

  void handleDialogDismissal() {
    if (_isDialogShowing) {
      _isDialogShowing = false;
      _currentNotificationTrackingId = null;
    }
  }

  /// Clears processed notifications cache (call periodically or on logout)
  void clearProcessedNotifications() {
    _processedNotifications.clear();
  }

  /// Vibrates the device with a pattern to alert the rider
  Future<void> _vibrateDevice() async {
    try {
      // Check if device has vibration capability
      bool? hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator == true) {
        // Vibrate with pattern: wait 0ms, vibrate 500ms, wait 200ms, vibrate 500ms, wait 200ms, vibrate 500ms
        Vibration.vibrate(pattern: [0, 500, 200, 500, 200, 500]);
      }
    } catch (e) {
      log('Error vibrating device: $e');
    }
  }

  /// Stops vibration
  void _stopVibration() {
    try {
      Vibration.cancel();
    } catch (e) {
      log('Error stopping vibration: $e');
    }
  }

  void handleDeliveryNotification(dynamic data) async {
    // Debug: Print raw WebSocket data
    log('======== WEBSOCKET ORDER NOTIFICATION ========');
    log('Raw data type: ${data.runtimeType}');
    log('Raw data: $data');
    if (data is String) {
      log('Parsed JSON: ${jsonDecode(data)}');
    }
    log('==============================================');

    try {
      Position currentPosition = Get.find<LocationService>().currentPosition!;
      final parsedData = data is String ? jsonDecode(data) : data;
      final DeliveryNotificationModel delivery =
          DeliveryNotificationModel.fromJson(parsedData);
      var originLatLng = LatLng(
          double.parse(delivery.originLocation.latitude ?? '0.0'),
          double.parse(delivery.originLocation.longitude ?? '0.0'));
      var destinationLatLng = LatLng(
          double.parse(delivery.destinationLocation.latitude ?? '0.0'),
          double.parse(delivery.destinationLocation.longitude ?? '0.0'));
      var currentLatLng =
          LatLng(currentPosition.latitude, currentPosition.longitude);

      var senderToReceiverDirectionDetails =
          await obtainOriginToDestinationDirectionDetails(
              originLatLng, destinationLatLng);
      var riderToSenderDirectionDetails =
          await obtainOriginToDestinationDirectionDetails(
              currentLatLng, originLatLng);

      final deliveriesController = Get.find<DeliveriesController>();

      // Check if rider has an active delivery (accepted or picked)
      final hasActiveDelivery = deliveriesController.selectedDelivery != null &&
          ['accepted', 'picked'].contains(
              deliveriesController.selectedDelivery!.status?.toLowerCase());

      if (hasActiveDelivery) {
        log('Rider has active delivery, ignoring new notification');
        return;
      }

      // Prevent duplicate notifications for the same tracking ID
      if (_processedNotifications.contains(delivery.trackingId)) {
        log('Duplicate notification for ${delivery.trackingId}, ignoring');
        return;
      }

      // Check if dialog is already showing for this delivery
      if (_isDialogShowing &&
          _currentNotificationTrackingId == delivery.trackingId) {
        log('Dialog already showing for ${delivery.trackingId}, ignoring');
        return;
      }

      if (!_isDialogShowing &&
          !deliveriesController.rejectedDeliveries
              .contains(delivery.trackingId) &&
          !deliveriesController.pickedDeliveries
              .contains(delivery.trackingId)) {
        // Mark as processed to prevent duplicates
        _processedNotifications.add(delivery.trackingId);
        _currentNotificationTrackingId = delivery.trackingId;

        // Play ringtone and vibrate
        FlutterRingtonePlayer().playRingtone();
        _vibrateDevice();
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
                child: Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.all(24.sp),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                            value:
                                formatToCurrency(double.parse(shipment.cost)),
                          ),
                          SizedBox(height: 16.h),

                          // From row
                          _buildAddressRow(
                            label: 'From',
                            value: shipment.originLocation.name ?? '',
                          ),
                          SizedBox(height: 16.h),

                          // To row
                          _buildAddressRow(
                            label: 'To',
                            value: shipment.destinationLocation.name ?? '',
                          ),
                          SizedBox(height: 16.h),

                          // Distance row
                          _buildInfoRow(
                            label: 'Distance',
                            value: senderToReceiverDirectionDetails
                                    .distance_text ??
                                '',
                          ),
                          SizedBox(height: 32.h),

                          // Action buttons
                          Row(
                            children: [
                              // Decline button
                              Expanded(
                                child: InkWell(
                                  onTap: deliveriesController.acceptingDelivery
                                      ? null
                                      : () {
                                          deliveriesController
                                              .rejectedDeliveries
                                              .add(shipment.trackingId);
                                          deliveriesController.rejectDelivery(
                                            trackingId: shipment.trackingId,
                                          );
                                          _isDialogShowing = false;
                                          _currentNotificationTrackingId = null;
                                          FlutterRingtonePlayer().stop();
                                          _stopVibration();
                                          Get.back();
                                        },
                                  child: Container(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 14.h),
                                    decoration: BoxDecoration(
                                      color:
                                          deliveriesController.acceptingDelivery
                                              ? const Color(0xFFFFE5E5)
                                                  .withOpacity(0.5)
                                              : const Color(
                                                  0xFFFFE5E5), // Light red
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Center(
                                      child: customText(
                                        'Decline',
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: deliveriesController
                                                .acceptingDelivery
                                            ? const Color(0xFFD32F2F)
                                                .withOpacity(0.5)
                                            : const Color(
                                                0xFFD32F2F), // Red text
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
                                          _stopVibration();

                                          await deliveriesController
                                              .acceptDelivery(
                                            context,
                                            trackingId: shipment.trackingId,
                                          );

                                          // Reset dialog state
                                          _isDialogShowing = false;
                                          _currentNotificationTrackingId = null;

                                          // Close dialog safely
                                          if (Get.isDialogOpen == true) {
                                            Get.back();
                                          }

                                          // Navigate to result screen with success/failure info
                                          Get.offNamed(
                                            Routes
                                                .DELIVERY_ACCEPTANCE_RESULT_SCREEN,
                                            arguments: {
                                              'isSuccess': deliveriesController
                                                  .acceptedDelivery,
                                              'message': deliveriesController
                                                  .lastAcceptanceMessage,
                                              'trackingId': shipment.trackingId,
                                            },
                                          );
                                        },
                                  child: Container(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 14.h),
                                    decoration: BoxDecoration(
                                      color:
                                          const Color(0xFF2E7D32), // Dark green
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Center(
                                      child: deliveriesController
                                              .acceptingDelivery
                                          ? SizedBox(
                                              width: 20.sp,
                                              height: 20.sp,
                                              child:
                                                  const CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                            Color>(
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
                    // Loading overlay
                    if (deliveriesController.acceptingDelivery)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 50.sp,
                                  height: 50.sp,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 4,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Color(0xFF2E7D32),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16.h),
                                customText(
                                  'Accepting order...',
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF2E7D32),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
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

  Widget _buildAddressRow({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customText(
          label,
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.obscureTextColor,
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontFamily: "Satoshi",
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.blackColor,
          ),
          textAlign: TextAlign.left,
          softWrap: true,
        ),
      ],
    );
  }
}
