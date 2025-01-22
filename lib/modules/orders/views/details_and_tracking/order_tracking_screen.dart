import 'package:fbroadcast/fbroadcast.dart' as broadcast;
import 'package:geolocator/geolocator.dart';
import 'package:go_logistics_driver/utils/exports.dart';

class OrderTrackingScreen extends StatefulWidget {
  const OrderTrackingScreen({super.key});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  late LatLng currentPosition;
  final settingsController = Get.find<SettingsController>();
  final ordersController = Get.find<OrdersController>();
  final locationService = Get.find<LocationService>();
  StreamSubscription<Position>? _positionSubscription;
  @override
  void initState() {
    super.initState();
    currentPosition = LatLng(locationService.currentPosition?.latitude ?? 0.0,
        locationService.currentPosition?.longitude ?? 0.0);
    checkIfLocationPermissionIsAllowed();
    if (!['delivered', 'rejected']
        .contains(ordersController.selectedShipment!.status)) {
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
      if (['accepted'].contains(ordersController.selectedShipment!.status)) {
        ordersController.drawPolylineFromRiderToDestination(context,
            destinationPosition: LatLng(
                double.parse(
                    ordersController.selectedShipment!.originLocation.latitude),
                double.parse(ordersController
                    .selectedShipment!.originLocation.longitude)),
            currentLocation: newPosition);
      } else if (['picked']
          .contains(ordersController.selectedShipment!.status)) {
        ordersController.drawPolylineFromRiderToDestination(context,
            destinationPosition: LatLng(
                double.parse(ordersController
                    .selectedShipment!.destinationLocation.latitude),
                double.parse(ordersController
                    .selectedShipment!.destinationLocation.longitude)),
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
    final ordersController = Get.find<OrdersController>();

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
    return GetBuilder<OrdersController>(builder: (ordersController) {
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
                height: ordersController.selectedShipment!.status == 'delivered'
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
                    ordersController.selectedShipment!.status!.toLowerCase() ==
                            'delivered'
                        ? 0.31
                        : 0.31,
                minChildSize:
                    ordersController.selectedShipment!.status!.toLowerCase() ==
                            'delivered'
                        ? 0.31
                        : 0.31,
                maxChildSize:
                    ordersController.selectedShipment!.status!.toLowerCase() ==
                            'delivered'
                        ? 0.50
                        : 0.65,
                expand: true,
                controller: draggableScrollableController,
                builder: (context, scrollController) {
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return SingleChildScrollView(
                        controller: scrollController,
                        physics: const ClampingScrollPhysics(),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height *
                                0.63, // Ensure content does not exceed max size
                          ),
                          child: Container(
                            // height: MediaQuery.of(context).size.height,
                            padding: EdgeInsets.symmetric(vertical: 8.sp),
                            decoration: const BoxDecoration(
                              color: AppColors.backgroundColor,
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
                                            .selectedShipment!.status!
                                            .toLowerCase())
                                    ? const SizedBox.shrink()
                                    : Container(
                                        width: 1.sw,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 12),
                                                  child: FloatingActionButton(
                                                    onPressed: () {
                                                      // _launchGoogleMaps(pickLocation!);
                                                      if (ordersController
                                                              .selectedShipment!
                                                              .status!
                                                              .toLowerCase() ==
                                                          'accepted') {
                                                        openGoogleMaps(
                                                            '${ordersController.selectedShipment!.originLocation.latitude},${ordersController.selectedShipment!.originLocation.longitude}');
                                                      } else if (ordersController
                                                              .selectedShipment!
                                                              .status!
                                                              .toLowerCase() ==
                                                          'picked') {
                                                        openGoogleMaps(
                                                            '${ordersController.selectedShipment!.destinationLocation.latitude},${ordersController.selectedShipment!.destinationLocation.longitude}');
                                                      }
                                                    },
                                                    backgroundColor:
                                                        AppColors.whiteColor,
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(5.sp),
                                                      // width: 55.w,
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: SvgPicture.asset(
                                                                SvgAssets
                                                                    .googleMapsIcon,
                                                                height: 55.sp,
                                                                width: 55.sp),
                                                          ),
                                                          const Icon(
                                                              Icons.directions,
                                                              color:
                                                                  Colors.blue),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            // Padding(
                                            //     padding: const EdgeInsets.all(8.0),
                                            //     child: ordersController.selectedShipment!.status!
                                            //                 .toLowerCase() ==
                                            //             'accepted'
                                            //         ? CustomButton(
                                            //             onPressed: () {
                                            //                            },
                                            //             title: "Go to pick-up address",
                                            //             width: 1.sw,
                                            //             backgroundColor: AppColors.greenColor,
                                            //             fontColor: AppColors.whiteColor,
                                            //           )
                                            //         : ordersController.selectedShipment!.status!
                                            //                     .toLowerCase() ==
                                            //                 'picked'
                                            //             ? CustomButton(
                                            //                 onPressed: () {
                                            //                                    },
                                            //                 title: "Go to drop off location",
                                            //                 width: 1.sw,
                                            //                 backgroundColor: AppColors.greenColor,
                                            //                 fontColor: AppColors.whiteColor,
                                            //               )
                                            //             : SizedBox.shrink()),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: ordersController
                                                          .selectedShipment!
                                                          .status!
                                                          .toLowerCase() ==
                                                      'accepted'
                                                  ? CustomButton(
                                                      onPressed: () {
                                                        ordersController
                                                            .updateShipmentStatus(
                                                                context,
                                                                status:
                                                                    'pickup');
                                                      },
                                                      isBusy: ordersController
                                                          .updatingShipmentStatus,
                                                      title:
                                                          "Click here if you've picked the item",
                                                      width: 1.sw,
                                                      backgroundColor: AppColors
                                                          .primaryColor,
                                                      fontColor:
                                                          AppColors.whiteColor,
                                                    )
                                                  : ordersController
                                                              .selectedShipment!
                                                              .status!
                                                              .toLowerCase() ==
                                                          'picked'
                                                      ? CustomButton(
                                                          onPressed: () {
                                                            ordersController
                                                                .updateShipmentStatus(
                                                                    context,
                                                                    status:
                                                                        'deliver');
                                                          },
                                                          isBusy: ordersController
                                                              .updatingShipmentStatus,
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
                                                          .selectedShipment
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
                                                          .selectedShipment
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
                                      horizontal: 10.sp, vertical: 10.sp),
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 10.sp, vertical: 10.sp),
                                  width: 1.sw,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.r),
                                      color: AppColors.whiteColor),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Visibility(
                                            visible: settingsController
                                                    .userProfile?.avatar !=
                                                null,
                                            replacement: CircleAvatar(
                                              radius: 15.r,
                                              backgroundColor:
                                                  AppColors.backgroundColor,
                                              child: customText(
                                                "${settingsController.userProfile?.fname.substring(0, 1) ?? ""}${settingsController.userProfile?.lname.substring(0, 1) ?? ""}",
                                                fontSize: 8.sp,
                                              ),
                                            ),
                                            child: CircleAvatar(
                                                backgroundImage:
                                                    CachedNetworkImageProvider(
                                                  settingsController.userProfile
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
                                                  "${settingsController.userProfile?.fname} ${settingsController.userProfile?.lname}",
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
                                                  "Courier",
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
                                          OrderTrackingMiniInfoItem(
                                            title: "Order status",
                                            value: ordersController
                                                    .selectedShipment
                                                    ?.status!
                                                    .capitalizeFirst ??
                                                "",
                                            isStatus: true,
                                          ),
                                          OrderTrackingMiniInfoItem(
                                            title: "Estimated distance",
                                            value: ordersController
                                                    .distanceToDestination ??
                                                "",
                                          ),
                                          OrderTrackingMiniInfoItem(
                                            title: "ETA",
                                            value: ordersController
                                                    .durationToDestination ??
                                                "",
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
