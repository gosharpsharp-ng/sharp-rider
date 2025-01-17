import 'package:geolocator/geolocator.dart';
import 'package:go_logistics_driver/utils/exports.dart';

class OrderTrackingScreen extends StatefulWidget {
  const OrderTrackingScreen({super.key});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  @override
  void initState() {
    super.initState();
    checkIfLocationPermissionIsAllowed();
  }

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
      final settingsController = Get.find<SettingsController>();
      return Scaffold(
        appBar: flatAppBar(),
        bottomNavigationBar:ordersController.selectedShipment!.status!
            .toLowerCase() ==
            'delivered'?SizedBox.shrink(): Container(
          height: 130.h,
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ordersController.selectedShipment!.status!
                              .toLowerCase() ==
                          'accepted'
                      ? CustomButton(
                          onPressed: () {
                            openGoogleMaps(
                                '${ordersController.selectedShipment!.originLocation.latitude},${ordersController.selectedShipment!.originLocation.longitude}');
                          },
                          title: "Go to pick-up address",
                          width: 1.sw,
                          backgroundColor: AppColors.greenColor,
                          fontColor: AppColors.whiteColor,
                        )
                      : ordersController.selectedShipment!.status!
                                  .toLowerCase() ==
                              'picked'
                          ? CustomButton(
                              onPressed: () {
                                openGoogleMaps(
                                    '${ordersController.selectedShipment!.destinationLocation.latitude},${ordersController.selectedShipment!.destinationLocation.longitude}');
                              },
                              title: "Go to drop off location",
                              width: 1.sw,
                              backgroundColor: AppColors.greenColor,
                              fontColor: AppColors.whiteColor,
                            )
                          : SizedBox.shrink()),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ordersController.selectedShipment!.status!
                            .toLowerCase() ==
                        'accepted'
                    ? CustomButton(
                        onPressed: () {
                          ordersController.updateShipmentStatus(
                              status: 'pickup');
                        },
                        isBusy: ordersController.updatingShipmentStatus,
                        title: "Click here if you've picked the item",
                        width: 1.sw,
                        backgroundColor: AppColors.primaryColor,
                        fontColor: AppColors.whiteColor,
                      )
                    : ordersController.selectedShipment!.status!
                                .toLowerCase() ==
                            'picked'
                        ? CustomButton(
                            onPressed: () {
                              ordersController.updateShipmentStatus(
                                  status: 'deliver');
                            },
                            isBusy: ordersController.updatingShipmentStatus,
                            title: "Click here if you've delivered the item",
                            width: 1.sw,
                            backgroundColor: AppColors.primaryColor,
                            fontColor: AppColors.whiteColor,
                          )
                        : SizedBox.shrink(),
              ),
            ],
          ),
        ),
        backgroundColor: AppColors.backgroundColor,
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 12.sp),
          height: 1.sh,
          width: 1.sw,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: 1.sw,
                  height: 1.sh * 0.8,
                  margin: EdgeInsets.symmetric(horizontal: 0.sp),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: GoogleMap(
                        myLocationEnabled: true,
                        mapType: MapType.normal,
                        myLocationButtonEnabled: true,
                        zoomControlsEnabled: true,
                        zoomGesturesEnabled: true,
                        trafficEnabled: true,
                        polylines: ordersController.polyLineSet,
                        markers: ordersController.markerSet,
                        circles: ordersController.circleSet,
                        initialCameraPosition: _kLagosPosition,
                        onMapCreated: (GoogleMapController controller) {
                          if (!ordersController
                              .googleMapController.isCompleted) {
                            ordersController.googleMapController
                                .complete(controller);
                          }
                          ordersController.newGoogleMapController = controller;
                          setState(() {});
                          // locateUserPosition();
                        },
                        onCameraMove: (CameraPosition? position) {
                          if (pickLocation != position!.target) {
                            pickLocation = position.target;
                          }
                        }),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 5.sp, vertical: 10.sp),
                  margin:
                      EdgeInsets.symmetric(horizontal: 5.sp, vertical: 10.sp),
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
                                  color: AppColors.whiteColor, width: 1.sp),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                customText(
                                  "Pick up Address",
                                  color: AppColors.whiteColor,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.normal,
                                  overflow: TextOverflow.visible,
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                customText(
                                  ordersController.selectedShipment
                                          ?.originLocation.name ??
                                      "",
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
                                  color: AppColors.whiteColor, width: 1.sp),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                customText(
                                  "Drop off Address",
                                  color: AppColors.whiteColor,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.normal,
                                  overflow: TextOverflow.visible,
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                customText(
                                  ordersController.selectedShipment
                                          ?.destinationLocation.name ??
                                      "",
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
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 5.sp, vertical: 10.sp),
                  margin:
                      EdgeInsets.symmetric(horizontal: 5.sp, vertical: 10.sp),
                  width: 1.sw,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      color: AppColors.whiteColor),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Visibility(
                            visible:
                                settingsController.userProfile?.avatar != null,
                            replacement: CircleAvatar(
                              radius: 15.r,
                              backgroundColor: AppColors.backgroundColor,
                              child: customText(
                                "${settingsController.userProfile?.fname.substring(0, 1) ?? ""}${settingsController.userProfile?.lname.substring(0, 1) ?? ""}",
                                fontSize: 14.sp,
                              ),
                            ),
                            child: CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(
                                  settingsController.userProfile?.avatar ?? '',
                                ),
                                radius: 15.r),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                customText(
                                  "${settingsController.userProfile?.fname ?? ''} ${settingsController.userProfile?.lname ?? ''}",
                                  color: AppColors.blackColor,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  overflow: TextOverflow.visible,
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                customText(
                                  "Courier",
                                  color: AppColors.obscureTextColor,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.normal,
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
                        dashColor: AppColors.primaryColor,
                        // lineLength: 150,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          OrderTrackingMiniInfoItem(
                            title: "Order status",
                            value: ordersController.selectedShipment?.status
                                    ?.capitalizeFirst ??
                                "",
                            isStatus: true,
                          ),
                          OrderTrackingMiniInfoItem(
                            title: "Estimated distance",
                            value:
                                '${double.parse(ordersController.selectedShipment!.distance).round() ?? ""}km',
                          ),
                          const OrderTrackingMiniInfoItem(
                            title: "ETA",
                            value: "24 min",
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          customText("Shipping progress",
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.obscureTextColor),
                          customText("${ getDeliveryProgress(ordersController.selectedShipment!.status!)*100}%",
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.obscureTextColor),
                        ],
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      LinearProgressIndicator(
                        value: getDeliveryProgress(ordersController.selectedShipment!.status!),
                        minHeight: 8.h,
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(10.r),
                        backgroundColor: AppColors.fadedButtonPrimaryColor,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
