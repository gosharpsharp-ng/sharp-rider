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
  Timer? _ringtoneTimeout;
  bool _isRingtonePlaying = false;

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
      _stopRingtoneAndVibration();
    }
  }

  /// Clears processed notifications cache (call periodically or on logout)
  void clearProcessedNotifications() {
    _processedNotifications.clear();
  }

  /// Stops ringtone and vibration with error handling
  Future<void> _stopRingtoneAndVibration() async {
    try {
      // Cancel any active timeout timer
      _ringtoneTimeout?.cancel();
      _ringtoneTimeout = null;

      // Stop ringtone if playing
      if (_isRingtonePlaying) {
        FlutterRingtonePlayer().stop();
        _isRingtonePlaying = false;
        log('Ringtone stopped successfully');
      }

      // Stop vibration
      await _stopVibration();
    } catch (e) {
      log('Error stopping ringtone/vibration: $e');
      // Even if there's an error, mark as not playing to prevent stuck state
      _isRingtonePlaying = false;
    }
  }

  /// Starts ringtone with automatic timeout to prevent infinite ringing
  void _startRingtoneWithTimeout() {
    try {
      // Stop any existing ringtone first
      _stopRingtoneAndVibration();

      // Play ringtone
      FlutterRingtonePlayer().playRingtone();
      _isRingtonePlaying = true;
      log('Ringtone started');

      // Set timeout to automatically stop ringtone after 30 seconds
      _ringtoneTimeout = Timer(const Duration(seconds: 30), () {
        log('Ringtone timeout reached - auto-stopping');
        _stopRingtoneAndVibration();
      });
    } catch (e) {
      log('Error starting ringtone: $e');
      _isRingtonePlaying = false;
    }
  }

  @override
  void onClose() {
    // Clean up when service is disposed
    _stopRingtoneAndVibration();
    super.onClose();
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
  Future<void> _stopVibration() async {
    try {
      // Check if device has vibrator before trying to cancel
      bool? hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator == true) {
        await Vibration.cancel();
      }
    } catch (e) {
      // Silently catch vibration errors - non-critical
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

      // Log parsed delivery model
      log('======== PARSED DELIVERY NOTIFICATION MODEL ========');
      log('Tracking ID: ${delivery.trackingId}');
      log('Delivery ID: ${delivery.id}');
      log('Order ID: ${delivery.orderId}');
      log('Cost: ${delivery.cost}');
      log('Delivery Fee: ${delivery.deliveryFee}');
      log('Distance: ${delivery.distance}');
      log('Status: ${delivery.status}');
      log('Payment Status: ${delivery.paymentStatus}');
      log('From: ${delivery.originLocation.name}');
      log('To: ${delivery.destinationLocation.name}');
      log('Sender: ${delivery.sender?.name ?? "N/A"}');
      log('Receiver: ${delivery.receiver?.name ?? "N/A"}');
      log('==================================================');

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

        // Play ringtone and vibrate with timeout protection
        _startRingtoneWithTimeout();
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
            onWillPop: () async {
              // Prevent accidental dismissal but ensure cleanup if it somehow happens
              _stopRingtoneAndVibration();
              return false;
            },
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
                          Center(
                            child: Container(
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
                          ),
                          SizedBox(height: 16.h),

                          // 💰 DELIVERY FEE - Prominent at top
                          Center(
                            child: Column(
                              children: [
                                customText(
                                  "You'll Earn",
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.obscureTextColor,
                                ),
                                SizedBox(height: 6.h),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20.w,
                                    vertical: 10.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2E7D32).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12.r),
                                    border: Border.all(
                                      color: const Color(0xFF2E7D32),
                                      width: 2,
                                    ),
                                  ),
                                  child: customText(
                                    formatToCurrency(double.parse(shipment.deliveryFee)),
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF2E7D32),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20.h),

                          // Title
                          Center(
                            child: customText(
                              'New Incoming Order',
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.blackColor,
                            ),
                          ),
                          SizedBox(height: 20.h),

                          // From row
                          _buildAddressRow(
                            label: 'From',
                            value: shipment.originLocation.name ?? '',
                          ),
                          SizedBox(height: 12.h),

                          // Distance indicator (between from and to)
                          Center(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 8.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.backgroundColor,
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(
                                  color: AppColors.primaryColor.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.route,
                                    size: 16.sp,
                                    color: AppColors.primaryColor,
                                  ),
                                  SizedBox(width: 6.w),
                                  customText(
                                    '${double.parse(shipment.distance).toStringAsFixed(2)} km',
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 12.h),

                          // To row
                          _buildAddressRow(
                            label: 'To',
                            value: shipment.destinationLocation.name ?? '',
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
                                          _stopRingtoneAndVibration();
                                          Navigator.of(context).pop();
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
                                          _stopRingtoneAndVibration();

                                          // Capture navigator before async operation
                                          final navigator = Navigator.of(context);

                                          await deliveriesController
                                              .acceptDelivery(
                                            context,
                                            trackingId: shipment.trackingId,
                                          );

                                          // Reset dialog state
                                          _isDialogShowing = false;
                                          _currentNotificationTrackingId = null;

                                          // Close dialog safely using captured navigator
                                          if (navigator.canPop()) {
                                            navigator.pop();
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
