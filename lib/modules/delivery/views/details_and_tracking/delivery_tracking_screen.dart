import 'package:gorider/core/utils/exports.dart';
import 'package:gorider/modules/delivery/views/widgets/delivery_otp_verification_dialog.dart';

class DeliveryTrackingScreen extends StatefulWidget {
  const DeliveryTrackingScreen({super.key});

  @override
  State<DeliveryTrackingScreen> createState() => _DeliveryTrackingScreenState();
}

class _DeliveryTrackingScreenState extends State<DeliveryTrackingScreen> {
  final settingsController = Get.find<SettingsController>();
  final deliveriesController = Get.find<DeliveriesController>();

  bool _mapInitialized = false;

  @override
  void initState() {
    super.initState();
    // Reset map state for fresh polyline drawing
    deliveriesController.polyLineSet.clear();
    deliveriesController.markerSet.clear();
    deliveriesController.pLineCoordinatedList.clear();
  }

  void _initializeMap() {
    if (_mapInitialized) return;
    _mapInitialized = true;

    if (deliveriesController.selectedDelivery != null) {
      deliveriesController.drawPolyLineFromOriginToDestination(
        context,
        originLatitude:
            deliveriesController.selectedDelivery!.originLocation.latitude ??
                '0.0',
        originLongitude:
            deliveriesController.selectedDelivery!.originLocation.longitude ??
                '0.0',
        destinationLatitude: deliveriesController
                .selectedDelivery!.destinationLocation.latitude ??
            '0.0',
        destinationLongitude: deliveriesController
                .selectedDelivery!.destinationLocation.longitude ??
            '0.0',
        originAddress:
            deliveriesController.selectedDelivery!.originLocation.displayName,
        destinationAddress: deliveriesController
            .selectedDelivery!.destinationLocation.displayName,
      );
    }
  }

  // Get navigation destination based on delivery status
  String _getNavigationDestination() {
    final status = deliveriesController.selectedDelivery?.status?.toLowerCase();
    if (status == 'accepted') {
      // Navigate to pickup location
      return '${deliveriesController.selectedDelivery!.originLocation.latitude},${deliveriesController.selectedDelivery!.originLocation.longitude}';
    } else if (status == 'picked') {
      // Navigate to delivery location
      return '${deliveriesController.selectedDelivery!.destinationLocation.latitude},${deliveriesController.selectedDelivery!.destinationLocation.longitude}';
    }
    return '';
  }

  // Get navigation button label based on delivery status
  String _getNavigationButtonLabel() {
    final status = deliveriesController.selectedDelivery?.status?.toLowerCase();
    if (status == 'accepted') {
      return 'Go to Pickup';
    } else if (status == 'picked') {
      return 'Go to Delivery';
    }
    return 'Navigate';
  }

  // Get button text based on delivery status
  String _getStatusButtonText() {
    final status = deliveriesController.selectedDelivery?.status?.toLowerCase();
    if (status == 'accepted') {
      return 'Picked Up';
    } else if (status == 'picked') {
      return 'Deliver Item';
    }
    return 'Update Status';
  }

  // Get status action - these must match the API: "accepted", "picked", "delivered"
  String _getStatusAction() {
    final status = deliveriesController.selectedDelivery?.status?.toLowerCase();
    if (status == 'accepted') {
      return 'picked'; // Next action after accepted is picked
    } else if (status == 'picked') {
      return 'delivered'; // Next action after picked is delivered
    }
    return '';
  }

  // Show OTP verification dialog for delivery completion
  void _showOTPVerificationDialog() {
    Get.dialog(
      DeliveryOTPVerificationDialog(
        trackingId: deliveriesController.selectedDelivery!.trackingId ?? '',
        onVerificationSuccess: (String deliveryCode) {
          // After collecting delivery code, update delivery status with the code
          deliveriesController.updateDeliveryStatus(
            context,
            status: 'delivered',
            deliveryCode: deliveryCode,
          );
        },
      ),
      barrierDismissible: false,
    );
  }

  // Handle status button press
  void _handleStatusButtonPress() {
    final status = deliveriesController.selectedDelivery?.status?.toLowerCase();

    if (status == 'picked') {
      // Show OTP dialog for final delivery
      _showOTPVerificationDialog();
    } else {
      // For other statuses, update directly
      deliveriesController.updateDeliveryStatus(
        context,
        status: _getStatusAction(),
      );
    }
  }

  // Helper to get sender name (prefer sender, fallback to user)
  String _getSenderName() {
    final delivery = deliveriesController.selectedDelivery;
    // Prefer sender.displayName (handles both name and fname/lname formats)
    if (delivery?.sender != null) {
      return delivery!.sender!.displayName;
    }
    // Fallback to user
    if (delivery?.user != null) {
      return delivery!.user!.displayName;
    }
    return "";
  }

  // Helper to get sender initials
  String _getSenderInitials() {
    final name = _getSenderName();
    if (name.isEmpty) return "";
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return "${parts[0].substring(0, 1)}${parts[1].substring(0, 1)}".toUpperCase();
    }
    return name.length >= 2 ? name.substring(0, 2).toUpperCase() : name.toUpperCase();
  }

  // Helper to get sender phone (prefer sender, fallback to user)
  String _getSenderPhone() {
    final delivery = deliveriesController.selectedDelivery;
    return delivery?.sender?.phone ?? delivery?.user?.phone ?? "";
  }

  // Helper to get receiver initials
  String _getReceiverInitials() {
    final name = deliveriesController.selectedDelivery?.receiver?.name ?? "";
    return name.length >= 2
        ? name.substring(0, 2).toUpperCase()
        : name.toUpperCase();
  }

  static const CameraPosition _kLagosPosition = CameraPosition(
    target: LatLng(6.5244, 3.3792),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DeliveriesController>(
      builder: (deliveriesController) {
        final isDeliveryComplete = ['delivered', 'rejected', 'canceled']
            .contains(
                deliveriesController.selectedDelivery?.status?.toLowerCase());

        return Scaffold(
          appBar: flatAppBar(),
          backgroundColor: AppColors.backgroundColor,
          body: Stack(
            children: [
              // Google Map showing pickup and delivery locations
              SizedBox(
                width: 1.sw,
                height: 1.sh * 0.65,
                child: Stack(
                  children: [
                    GoogleMap(
                      mapType: MapType.normal,
                      myLocationEnabled: false,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      zoomGesturesEnabled: true,
                      scrollGesturesEnabled: true,
                      trafficEnabled: true,
                      polylines: deliveriesController.polyLineSet,
                      markers: deliveriesController.markerSet,
                      initialCameraPosition: _kLagosPosition,
                      onMapCreated: (GoogleMapController controller) {
                        deliveriesController.setMapController(controller);
                        // Draw polyline after map is created
                        _initializeMap();
                      },
                    ),

                    // Active Delivery Info Overlay (top)
                    if (!isDeliveryComplete)
                      Positioned(
                        top: 10.h,
                        left: 16.w,
                        right: 16.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 10.sp),
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(10.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(20),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8.sp),
                                decoration: BoxDecoration(
                                  color: deliveriesController.selectedDelivery?.status?.toLowerCase() == 'accepted'
                                      ? AppColors.amberColor.withAlpha(30)
                                      : AppColors.primaryColor.withAlpha(30),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Icon(
                                  deliveriesController.selectedDelivery?.status?.toLowerCase() == 'accepted'
                                      ? Icons.inventory_2_outlined
                                      : Icons.local_shipping_outlined,
                                  color: deliveriesController.selectedDelivery?.status?.toLowerCase() == 'accepted'
                                      ? AppColors.amberColor
                                      : AppColors.primaryColor,
                                  size: 20.sp,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    customText(
                                      deliveriesController.selectedDelivery?.status?.toLowerCase() == 'accepted'
                                          ? 'Heading to Pickup'
                                          : 'Heading to Delivery',
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.blackColor,
                                    ),
                                    SizedBox(height: 2.h),
                                    customText(
                                      deliveriesController.selectedDelivery?.status?.toLowerCase() == 'accepted'
                                          ? deliveriesController.selectedDelivery?.originLocation.displayName ?? ''
                                          : deliveriesController.selectedDelivery?.destinationLocation.displayName ?? '',
                                      fontSize: 11.sp,
                                      color: AppColors.greyColor,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // Recenter Button (right side)
                    Positioned(
                      top: isDeliveryComplete ? 10.h : 80.h,
                      right: 16.w,
                      child: GestureDetector(
                        onTap: () {
                          // Recenter to show full route
                          if (deliveriesController.pLineCoordinatedList.isNotEmpty) {
                            deliveriesController.fitMapToBounds();
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(10.sp),
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(8.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(15),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.fullscreen,
                            color: AppColors.blackColor,
                            size: 22.sp,
                          ),
                        ),
                      ),
                    ),

                    // Navigate Button on map - Google Maps style
                    if (!isDeliveryComplete)
                      Positioned(
                        bottom: 16.h,
                        right: 16.w,
                        child: FloatingActionButton.extended(
                          heroTag: "navigateBtn",
                          onPressed: () {
                            final destination = _getNavigationDestination();
                            if (destination.isNotEmpty) {
                              openGoogleMaps(destination);
                            }
                          },
                          backgroundColor: AppColors.whiteColor,
                          elevation: 4,
                          icon: Icon(
                            Icons.directions,
                            color: const Color(0xFF4285F4), // Google Maps blue
                            size: 22.sp,
                          ),
                          label: customText(
                            _getNavigationButtonLabel(),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF4285F4), // Google Maps blue
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Bottom sheet with delivery info and actions
              DraggableScrollableSheet(
                initialChildSize: isDeliveryComplete ? 0.31 : 0.35,
                minChildSize: 0.31,
                maxChildSize: isDeliveryComplete ? 0.50 : 0.65,
                expand: true,
                builder: (context, scrollController) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      physics: const ClampingScrollPhysics(),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.sp),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Drag handle indicator
                            Container(
                              width: 40.w,
                              height: 4.h,
                              margin: EdgeInsets.only(bottom: 12.h),
                              decoration: BoxDecoration(
                                color: AppColors.greyColor.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(2.r),
                              ),
                            ),

                            // Tracking ID - using shared widget
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.sp),
                              child: DeliveryTrackingIdWidget(
                                trackingId: deliveriesController
                                        .selectedDelivery?.trackingId ??
                                    "",
                              ),
                            ),
                            SizedBox(height: 12.h),

                            // Status indicator text
                            if (!isDeliveryComplete)
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 20.sp),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: customText(
                                    deliveriesController
                                                .selectedDelivery?.status
                                                ?.toLowerCase() ==
                                            'accepted'
                                        ? "Head to pick-up location"
                                        : deliveriesController
                                                    .selectedDelivery?.status
                                                    ?.toLowerCase() ==
                                                'picked'
                                            ? "Head to delivery location"
                                            : "",
                                    color: AppColors.primaryColor,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            SizedBox(height: 16.h),

                            // Action Button (immediately under tracking ID)
                            if (!isDeliveryComplete) ...[
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 16.sp),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: CustomButton(
                                    onPressed: _handleStatusButtonPress,
                                    isBusy: deliveriesController
                                        .updatingDeliveryStatus,
                                    title: _getStatusButtonText(),
                                    backgroundColor: AppColors.primaryColor,
                                    fontColor: AppColors.whiteColor,
                                  ),
                                ),
                              ),
                              SizedBox(height: 12.h),
                            ],

                            // Pickup and Delivery Locations Card - using shared widget
                            DeliveryLocationsCard(
                              pickupAddress: deliveriesController
                                      .selectedDelivery
                                      ?.originLocation
                                      .displayName ??
                                  "",
                              dropoffAddress: deliveriesController
                                      .selectedDelivery
                                      ?.destinationLocation
                                      .displayName ??
                                  "",
                              margin: EdgeInsets.symmetric(horizontal: 16.sp),
                            ),

                            SizedBox(height: 12.h),

                            // Sender and Receiver Info Card - using shared widget
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.sp),
                              child: DeliveryContactCard(
                                senderName: _getSenderName(),
                                senderInitials: _getSenderInitials(),
                                senderPhone: _getSenderPhone(),
                                senderAvatar: deliveriesController
                                    .selectedDelivery?.user?.avatarUrl,
                                receiverName: deliveriesController
                                        .selectedDelivery?.receiver?.name ??
                                    "",
                                receiverInitials: _getReceiverInitials(),
                                receiverPhone: deliveriesController
                                        .selectedDelivery?.receiver?.phone ??
                                    "",
                                useCircleCallButton: true,
                                onSenderCall: () {
                                  showAnyBottomSheet(
                                    isControlled: false,
                                    child:
                                        const DeliveryContactOptionBottomSheet(),
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 16.h),

                            // Delivery Stats
                            Container(
                              padding: EdgeInsets.all(16.sp),
                              margin: EdgeInsets.symmetric(horizontal: 16.sp),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                                color: AppColors.whiteColor,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  DeliveryTrackingMiniInfoItem(
                                    title: "Order status",
                                    value: deliveriesController.selectedDelivery
                                            ?.status?.capitalizeFirst ??
                                        "",
                                    isStatus: true,
                                  ),
                                  DeliveryTrackingMiniInfoItem(
                                    title: "Distance",
                                    value:
                                        "${deliveriesController.selectedDelivery?.distance ?? '0'} km",
                                  ),
                                  DeliveryTrackingMiniInfoItem(
                                    title: "Amount",
                                    value: formatToCurrency(
                                      double.tryParse(deliveriesController
                                                  .selectedDelivery?.cost ??
                                              "0") ??
                                          0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20.h),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
