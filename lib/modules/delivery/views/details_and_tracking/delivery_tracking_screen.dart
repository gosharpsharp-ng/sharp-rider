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
            deliveriesController.selectedDelivery!.originLocation.latitude ?? '0.0',
        originLongitude:
            deliveriesController.selectedDelivery!.originLocation.longitude ?? '0.0',
        destinationLatitude:
            deliveriesController.selectedDelivery!.destinationLocation.latitude ?? '0.0',
        destinationLongitude: deliveriesController
            .selectedDelivery!.destinationLocation.longitude ?? '0.0',
        originAddress:
            deliveriesController.selectedDelivery!.originLocation.displayName,
        destinationAddress:
            deliveriesController.selectedDelivery!.destinationLocation.displayName,
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
        trackingId: deliveriesController.selectedDelivery!.trackingId,
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
              Container(
                width: 1.sw,
                height: 1.sh * 0.65,
                child: Stack(
                  children: [
                    GoogleMap(
                      mapType: MapType.normal,
                      myLocationEnabled: false,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: true,
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
                    // Navigate Button on map
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
                          backgroundColor: AppColors.primaryColor,
                          icon: Icon(
                            Icons.navigation_rounded,
                            color: AppColors.whiteColor,
                            size: 20.sp,
                          ),
                          label: customText(
                            "Navigate",
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.whiteColor,
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

                            // Tracking ID
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.sp, vertical: 10.sp),
                              margin: EdgeInsets.symmetric(horizontal: 16.sp),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                                color: AppColors.backgroundColor,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.local_shipping_outlined,
                                        color: AppColors.primaryColor,
                                        size: 20.sp,
                                      ),
                                      SizedBox(width: 8.w),
                                      customText(
                                        "Tracking ID:",
                                        color: AppColors.obscureTextColor,
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      customText(
                                        deliveriesController
                                                .selectedDelivery?.trackingId ??
                                            "",
                                        color: AppColors.primaryColor,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      SizedBox(width: 8.w),
                                      InkWell(
                                        onTap: () {
                                          Clipboard.setData(ClipboardData(
                                            text: deliveriesController
                                                    .selectedDelivery
                                                    ?.trackingId ??
                                                "",
                                          ));
                                          showToast(
                                              message:
                                                  "Tracking ID copied to clipboard");
                                        },
                                        child: Icon(
                                          Icons.copy_rounded,
                                          color: AppColors.primaryColor,
                                          size: 18.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 12.h),

                            // Pickup and Delivery Locations Card
                            Container(
                              padding: EdgeInsets.all(16.sp),
                              margin: EdgeInsets.symmetric(horizontal: 16.sp),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                                color: AppColors.primaryColor,
                              ),
                              child: Column(
                                children: [
                                  // Pickup Location
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(8.sp),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppColors.whiteColor,
                                            width: 2.sp,
                                          ),
                                        ),
                                        child: SvgPicture.asset(
                                          SvgAssets.parcelIcon,
                                          colorFilter: const ColorFilter.mode(
                                            AppColors.whiteColor,
                                            BlendMode.srcIn,
                                          ),
                                          width: 20.sp,
                                          height: 20.sp,
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            customText(
                                              "Pick up Address",
                                              color: AppColors.whiteColor,
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            SizedBox(height: 4.h),
                                            customText(
                                              deliveriesController
                                                      .selectedDelivery
                                                      ?.originLocation
                                                      .displayName ??
                                                  "",
                                              color: AppColors.whiteColor,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600,
                                              overflow: TextOverflow.visible,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 12.h),
                                  const DottedLine(
                                    dashLength: 4,
                                    dashGapLength: 4,
                                    lineThickness: 2,
                                    dashColor: AppColors.whiteColor,
                                  ),
                                  SizedBox(height: 12.h),

                                  // Delivery Location
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(8.sp),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppColors.whiteColor,
                                            width: 2.sp,
                                          ),
                                        ),
                                        child: SvgPicture.asset(
                                          SvgAssets.locationIcon,
                                          colorFilter: const ColorFilter.mode(
                                            AppColors.secondaryColor,
                                            BlendMode.srcIn,
                                          ),
                                          width: 20.sp,
                                          height: 20.sp,
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            customText(
                                              "Drop off Address",
                                              color: AppColors.whiteColor,
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            SizedBox(height: 4.h),
                                            customText(
                                              deliveriesController
                                                      .selectedDelivery
                                                      ?.destinationLocation
                                                      .displayName ??
                                                  "",
                                              color: AppColors.whiteColor,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600,
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
                            SizedBox(height: 16.h),

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
                            SizedBox(height: 12.h),

                            // Sender and Receiver Info Card
                            Container(
                              padding: EdgeInsets.all(16.sp),
                              margin: EdgeInsets.symmetric(horizontal: 16.sp),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                                color: AppColors.backgroundColor,
                              ),
                              child: Column(
                                children: [
                                  // Sender Info
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 24.r,
                                        backgroundColor: AppColors.primaryColor
                                            .withOpacity(0.1),
                                        backgroundImage: deliveriesController
                                                    .selectedDelivery
                                                    ?.user
                                                    ?.avatar !=
                                                null
                                            ? CachedNetworkImageProvider(
                                                deliveriesController
                                                        .selectedDelivery
                                                        ?.user
                                                        ?.avatar ??
                                                    '',
                                              )
                                            : null,
                                        child: deliveriesController
                                                    .selectedDelivery
                                                    ?.user
                                                    ?.avatar ==
                                                null
                                            ? customText(
                                                "${deliveriesController.selectedDelivery?.user?.firstName?.substring(0, 1) ?? ""}${deliveriesController.selectedDelivery?.user?.lastName?.substring(0, 1) ?? ""}",
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.primaryColor,
                                              )
                                            : null,
                                      ),
                                      SizedBox(width: 12.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            customText(
                                              "${deliveriesController.selectedDelivery?.user?.firstName ?? ""} ${deliveriesController.selectedDelivery?.user?.lastName ?? ""}",
                                              color: AppColors.blackColor,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            SizedBox(height: 4.h),
                                            customText(
                                              "Sender",
                                              color: AppColors.obscureTextColor,
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          showAnyBottomSheet(
                                            isControlled: false,
                                            child:
                                                const DeliveryContactOptionBottomSheet(),
                                          );
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(8.sp),
                                          decoration: BoxDecoration(
                                            color: AppColors.primaryColor,
                                            shape: BoxShape.circle,
                                          ),
                                          child: SvgPicture.asset(
                                            SvgAssets.callIcon,
                                            height: 20.sp,
                                            width: 20.sp,
                                            colorFilter: const ColorFilter.mode(
                                              AppColors.whiteColor,
                                              BlendMode.srcIn,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16.h),

                                  // Receiver Info
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 24.r,
                                        backgroundColor: AppColors.greenColor
                                            .withOpacity(0.1),
                                        child: customText(
                                          (deliveriesController.selectedDelivery
                                                  ?.receiver?.name ?? "")
                                                  .length >= 2
                                              ? deliveriesController.selectedDelivery!
                                                  .receiver!.name!
                                                  .substring(0, 2)
                                                  .toUpperCase()
                                              : (deliveriesController.selectedDelivery
                                                  ?.receiver?.name ?? "").toUpperCase(),
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.greenColor,
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            customText(
                                              deliveriesController
                                                      .selectedDelivery
                                                      ?.receiver
                                                      ?.name ??
                                                  "",
                                              color: AppColors.blackColor,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            SizedBox(height: 4.h),
                                            customText(
                                              "Receiver",
                                              color: AppColors.obscureTextColor,
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          makePhoneCall(
                                            deliveriesController
                                                    .selectedDelivery
                                                    ?.receiver
                                                    ?.phone ??
                                                "",
                                          );
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(8.sp),
                                          decoration: BoxDecoration(
                                            color: AppColors.greenColor,
                                            shape: BoxShape.circle,
                                          ),
                                          child: SvgPicture.asset(
                                            SvgAssets.callIcon,
                                            height: 20.sp,
                                            width: 20.sp,
                                            colorFilter: const ColorFilter.mode(
                                              AppColors.whiteColor,
                                              BlendMode.srcIn,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16.h),

                                  const DottedLine(
                                    dashLength: 4,
                                    dashGapLength: 4,
                                    lineThickness: 2,
                                    dashColor: AppColors.primaryColor,
                                  ),
                                  SizedBox(height: 16.h),

                                  // Delivery Stats
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      DeliveryTrackingMiniInfoItem(
                                        title: "Order status",
                                        value: deliveriesController
                                                .selectedDelivery
                                                ?.status
                                                ?.capitalizeFirst ??
                                            "",
                                        isStatus: true,
                                      ),
                                      DeliveryTrackingMiniInfoItem(
                                        title: "Distance",
                                        value: deliveriesController
                                                .selectedDelivery?.distance ??
                                            "",
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
                                ],
                              ),
                            ),
                            SizedBox(height: 20.h),

                            // Action Button (only if not delivered)
                            if (!isDeliveryComplete) ...[
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.sp),
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
                              SizedBox(height: 16.h),
                            ],
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
