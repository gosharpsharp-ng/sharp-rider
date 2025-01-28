import 'package:fbroadcast/fbroadcast.dart' as broadcast;
import 'package:geolocator/geolocator.dart';
import 'package:go_logistics_driver/modules/orders/views/widgets/phone_number_widget.dart';
import 'package:go_logistics_driver/utils/exports.dart';

class DeliveryTrackingScreen extends StatefulWidget {
  const DeliveryTrackingScreen({super.key});

  @override
  State<DeliveryTrackingScreen> createState() => _DeliveryTrackingScreenState();
}

class _DeliveryTrackingScreenState extends State<DeliveryTrackingScreen> {
  late LatLng currentPosition;
  final settingsController = Get.find<SettingsController>();
  final ordersController = Get.find<DeliveriesController>();
  final locationService = Get.find<LocationService>();
  StreamSubscription<Position>? _positionSubscription;
  @override
  void initState() {
    super.initState();
    currentPosition = LatLng(locationService.currentPosition?.latitude ?? 0.0,
        locationService.currentPosition?.longitude ?? 0.0);
    checkIfLocationPermissionIsAllowed();
    if (!['delivered', 'rejected']
        .contains(ordersController.selectedDelivery!.status)) {
      setupLocationTracking();
    }
  }

  void setupLocationTracking() {
    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen(
      // When new position arrives
      (Position position) {
        updateMarkerPosition(position);
      },
      // Handle errors
      onError: (error) {
        print('Location tracking error: $error');
      },
      // What to do when the stream is cancelled
      onDone: () {
        print('Location tracking completed');
      },
    );
  }

  void updateMarkerPosition(Position position) async {
    if (!mounted) return;

    LatLng newPosition = LatLng(position.latitude, position.longitude);
    LatLng closestPoint = getClosestPointOnPolyline(newPosition);

    double deviation = Geolocator.distanceBetween(
      newPosition.latitude,
      newPosition.longitude,
      closestPoint.latitude,
      closestPoint.longitude,
    );

    // Threshold for recalculating the route
    const double deviationThreshold = 50.0; // in meters

    if (deviation > deviationThreshold) {
      // Recalculate the route
      if (['accepted'].contains(ordersController.selectedDelivery!.status)) {
        ordersController.drawPolylineFromRiderToDestination(context,
            destinationPosition: LatLng(
                double.parse(
                    ordersController.selectedDelivery!.originLocation.latitude),
                double.parse(ordersController
                    .selectedDelivery!.originLocation.longitude)),
            currentLocation: newPosition);
      } else if (['picked']
          .contains(ordersController.selectedDelivery!.status)) {
        ordersController.drawPolylineFromRiderToDestination(context,
            destinationPosition: LatLng(
                double.parse(ordersController
                    .selectedDelivery!.destinationLocation.latitude),
                double.parse(ordersController
                    .selectedDelivery!.destinationLocation.longitude)),
            currentLocation: newPosition);
      }

      // Update marker and camera
      setState(() {
        var markerId =
            MarkerId(settingsController.userProfile?.id.toString() ?? "");
        double rotation =
            calculateLocationDegrees(currentPosition, newPosition);

        final marker = Marker(
          markerId: markerId,
          position: newPosition,
          icon:
              ordersController.bikeMarkerIcon ?? BitmapDescriptor.defaultMarker,
          rotation: rotation,
          anchor: const Offset(0.5, 0.5),
        );

        ordersController.markerSet.removeWhere((m) => m.markerId == markerId);
        ordersController.markerSet.add(marker);

        if (ordersController.newGoogleMapController != null) {
          ordersController.newGoogleMapController!
              .animateCamera(CameraUpdate.newLatLng(newPosition));
        }

        currentPosition = newPosition;
      });
    }
  }

  LatLng getClosestPointOnPolyline(LatLng position) {
    double minDistance = double.infinity;
    LatLng closestPoint = position;

    for (LatLng point in ordersController.pLineCoordinatedList) {
      double distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        point.latitude,
        point.longitude,
      );

      if (distance < minDistance) {
        minDistance = distance;
        closestPoint = point;
      }
    }

    return closestPoint;
  }

  DraggableScrollableController? draggableScrollableController;
  LocationPermission? _locationPermission;
  checkIfLocationPermissionIsAllowed() async {
    _locationPermission = await Geolocator.requestPermission();
    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  LatLng? pickLocation;
  static const CameraPosition _kLagosPosition = CameraPosition(
    target: LatLng(6.5244, 3.3792),
    zoom: 14.4746,
  );
  Position? userCurrentPosition;
  locateUserPosition() async {
    final ordersController = Get.find<DeliveriesController>();

    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
    );
    Position cPosition = await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );
    userCurrentPosition = cPosition;
    LatLng latLngPosition =
        LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);
    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 13);
    ordersController.newGoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DeliveriesController>(builder: (ordersController) {
      return Scaffold(
        appBar: flatAppBar(),
        backgroundColor: AppColors.backgroundColor,
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 0.sp, vertical: 0.sp),
          height: 1.sh,
          width: 1.sw,
          child: Stack(
            children: [
              Container(
                width: 1.sw,
                height: ordersController.selectedDelivery!.status == 'delivered'
                    ? 1.sh * 0.804
                    : 1.sh * 0.65,
                margin: EdgeInsets.symmetric(horizontal: 0.sp),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: GoogleMap(
                      myLocationEnabled: true,
                      mapType: MapType.normal,
                      myLocationButtonEnabled: true,
                      zoomControlsEnabled: true,
                      zoomGesturesEnabled: true, // Enable zoom gestures
                      scrollGesturesEnabled: true,
                      trafficEnabled: true,
                      polylines: ordersController.polyLineSet,
                      markers: ordersController.markerSet,
                      circles: ordersController.circleSet,
                      initialCameraPosition: _kLagosPosition,
                      onMapCreated: (GoogleMapController controller) {
                        if (!ordersController.googleMapController.isCompleted) {
                          ordersController.googleMapController
                              .complete(controller);
                        }
                        ordersController.newGoogleMapController = controller;
                        setState(() {});
                      },
                      onCameraMove: (CameraPosition? position) {
                        if (pickLocation != position!.target) {
                          pickLocation = position.target;
                        }
                      }),
                ),
              ),
              DraggableScrollableSheet(
                initialChildSize:
                    ordersController.selectedDelivery!.status!.toLowerCase() ==
                            'delivered'
                        ? 0.31
                        : 0.35,
                minChildSize:
                    ordersController.selectedDelivery!.status!.toLowerCase() ==
                            'delivered'
                        ? 0.31
                        : 0.31,
                maxChildSize:
                    ordersController.selectedDelivery!.status!.toLowerCase() ==
                            'delivered'
                        ? 0.50
                        : 0.65,
                expand: true,
                controller: draggableScrollableController,
                builder: (context, scrollController) {
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height *
                              0.65, // Ensure content does not exceed max size
                        ),
                        child: SingleChildScrollView(
                          controller: scrollController,
                          physics: const ClampingScrollPhysics(),
                          child: Container(
                            // height: MediaQuery.of(context).size.height,
                            padding: EdgeInsets.symmetric(vertical: 8.sp),
                            decoration: const BoxDecoration(
                              color: AppColors.whiteColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ['delivered', 'rejected', 'canceled'].contains(
                                        ordersController
                                            .selectedDelivery!.status!
                                            .toLowerCase())
                                    ? const SizedBox.shrink()
                                    : Container(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 12),
                                                  child: TextButton(
                                                    onPressed: () {
                                                      // _launchGoogleMaps(pickLocation!);
                                                      if (ordersController
                                                              .selectedDelivery!
                                                              .status!
                                                              .toLowerCase() ==
                                                          'accepted') {
                                                        openGoogleMaps(
                                                            '${ordersController.selectedDelivery!.originLocation.latitude},${ordersController.selectedDelivery!.originLocation.longitude}');
                                                      } else if (ordersController
                                                              .selectedDelivery!
                                                              .status!
                                                              .toLowerCase() ==
                                                          'picked') {
                                                        openGoogleMaps(
                                                            '${ordersController.selectedDelivery!.destinationLocation.latitude},${ordersController.selectedDelivery!.destinationLocation.longitude}');
                                                      }
                                                    },
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 15.sp,
                                                              vertical: 5.sp),
                                                      decoration: BoxDecoration(
                                                          color: AppColors
                                                              .greenColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15.r)),
                                                      // width: 55.w,
                                                      child: Row(
                                                        children: [
                                                          SvgPicture.asset(
                                                              SvgAssets
                                                                  .googleMapsIcon,
                                                              height: 30.sp,
                                                              width: 30.sp),
                                                          customText(
                                                            "Navigate",
                                                            fontSize: 14.sp,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: AppColors
                                                                .whiteColor,
                                                            overflow:
                                                                TextOverflow
                                                                    .visible,
                                                          ),
                                                          SizedBox(
                                                            width: 15.sp,
                                                          ),
                                                          Icon(Icons.directions,
                                                              size: 25.sp,
                                                              color:
                                                                  Colors.white),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: ordersController
                                                          .selectedDelivery!
                                                          .status!
                                                          .toLowerCase() ==
                                                      'accepted'
                                                  ? CustomButton(
                                                      onPressed: () {
                                                        ordersController
                                                            .updateDeliveryStatus(
                                                                context,
                                                                status:
                                                                    'pickup');
                                                      },
                                                      isBusy: ordersController
                                                          .updatingDeliveryStatus,
                                                      title:
                                                          "Click here if you've picked the item",
                                                      width: 1.sw,
                                                      backgroundColor: AppColors
                                                          .primaryColor,
                                                      fontColor:
                                                          AppColors.whiteColor,
                                                    )
                                                  : ordersController
                                                              .selectedDelivery!
                                                              .status!
                                                              .toLowerCase() ==
                                                          'picked'
                                                      ? CustomButton(
                                                          onPressed: () {
                                                            ordersController
                                                                .updateDeliveryStatus(
                                                                    context,
                                                                    status:
                                                                        'deliver');
                                                          },
                                                          isBusy: ordersController
                                                              .updatingDeliveryStatus,
                                                          title:
                                                              "Click here if you've delivered the item",
                                                          width: 1.sw,
                                                          backgroundColor:
                                                              AppColors
                                                                  .primaryColor,
                                                          fontColor: AppColors
                                                              .whiteColor,
                                                        )
                                                      : const SizedBox.shrink(),
                                            ),
                                          ],
                                        ),
                                      ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.sp, vertical: 10.sp),
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 10.sp, vertical: 10.sp),
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
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.normal,
                                                  overflow:
                                                      TextOverflow.visible,
                                                ),
                                                SizedBox(
                                                  height: 5.h,
                                                ),
                                                customText(
                                                  ordersController
                                                          .selectedDelivery
                                                          ?.originLocation
                                                          .name ??
                                                      "",
                                                  color: AppColors.whiteColor,
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w500,
                                                  overflow:
                                                      TextOverflow.visible,
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
                                                  color: AppColors.whiteColor,
                                                  width: 1.sp),
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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                customText(
                                                  "Drop off Address",
                                                  color: AppColors.whiteColor,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.normal,
                                                  overflow:
                                                      TextOverflow.visible,
                                                ),
                                                SizedBox(
                                                  height: 5.h,
                                                ),
                                                customText(
                                                  ordersController
                                                          .selectedDelivery
                                                          ?.destinationLocation
                                                          .name ??
                                                      "",
                                                  color: AppColors.whiteColor,
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w500,
                                                  overflow:
                                                      TextOverflow.visible,
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
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.sp, vertical: 5.sp),
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 10.sp, vertical: 0.sp),
                                  width: 1.sw,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.r),
                                      color: AppColors.whiteColor),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Visibility(
                                            visible: ordersController
                                                    .selectedDelivery
                                                    ?.sender
                                                    ?.avatar !=
                                                null,
                                            replacement: CircleAvatar(
                                              radius: 15.r,
                                              backgroundColor:
                                                  AppColors.backgroundColor,
                                              child: customText(
                                                "${ordersController.selectedDelivery?.sender?.firstName?.substring(0, 1) ?? ""}${ordersController.selectedDelivery?.sender?.lastName?.substring(0, 1) ?? ""}",
                                                fontSize: 8.sp,
                                              ),
                                            ),
                                            child: CircleAvatar(
                                                backgroundImage:
                                                    CachedNetworkImageProvider(
                                                  ordersController
                                                          .selectedDelivery
                                                          ?.sender
                                                          ?.avatar ??
                                                      '',
                                                ),
                                                radius: 15.r),
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
                                                  "${ordersController.selectedDelivery?.sender?.firstName} ${ordersController.selectedDelivery?.sender?.lastName}",
                                                  color: AppColors.blackColor,
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w500,
                                                  overflow:
                                                      TextOverflow.visible,
                                                ),
                                                SizedBox(
                                                  height: 5.h,
                                                ),
                                                customText(
                                                  "Sender",
                                                  color: AppColors
                                                      .obscureTextColor,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.normal,
                                                  overflow:
                                                      TextOverflow.visible,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      PhoneNumberWidget(
                                          title: "Call sender",
                                          phoneNumber: ordersController
                                                  .selectedDelivery
                                                  ?.sender
                                                  ?.phone ??
                                              "",
                                          callAction: () async {
                                            makePhoneCall(ordersController
                                                    .selectedDelivery
                                                    ?.sender
                                                    ?.phone ??
                                                "");
                                          }),
                                      PhoneNumberWidget(
                                          title: "Call receiver",
                                          phoneNumber: ordersController
                                                  .selectedDelivery
                                                  ?.receiver
                                                  .phone ??
                                              "",
                                          callAction: () {
                                            makePhoneCall(ordersController
                                                    .selectedDelivery
                                                    ?.receiver
                                                    .phone ??
                                                "");
                                          }),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          DeliveryTrackingMiniInfoItem(
                                            title: "Order status",
                                            value: ordersController
                                                    .selectedDelivery
                                                    ?.status!
                                                    .capitalizeFirst ??
                                                "",
                                            isStatus: true,
                                          ),
                                          DeliveryTrackingMiniInfoItem(
                                            title: "Estimated distance",
                                            value: ordersController
                                                    .distanceToDestination ??
                                                "",
                                          ),
                                          DeliveryTrackingMiniInfoItem(
                                            title: "ETA",
                                            value: ordersController
                                                    .durationToDestination ??
                                                "",
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      const DottedLine(
                                        dashLength: 3,
                                        dashGapLength: 3,
                                        lineThickness: 2,
                                        dashColor: AppColors.primaryColor,
                                        // lineLength: 150,
                                      ),
                                      SizedBox(
                                        height: 16.h,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    super.dispose();
  }
}
