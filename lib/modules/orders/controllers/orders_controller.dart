import 'dart:developer';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_logistics_driver/models/direction_details_Info.dart';
import 'package:go_logistics_driver/models/rider_stats_model.dart';
import 'package:go_logistics_driver/utils/exports.dart';

class OrdersController extends GetxController {
  final deliveryService = serviceLocator<DeliveryService>();
  final profileService = serviceLocator<ProfileService>();
  final sendingInfoFormKey = GlobalKey<FormState>();
  final deliveriesSearchFormKey = GlobalKey<FormState>();
  final itemDetailsFormKey = GlobalKey<FormState>();
  final serviceManager = Get.find<ServiceManager>();
  final settingsController = Get.find<SettingsController>();

  List<DeliveryModel> allDeliveries = [];
  String? distanceToDestination;
  String? durationToDestination;
  bool fetchingDeliveries = false;
  Future<void> fetchDeliveries() async {
    fetchingDeliveries = true;
    update();

    APIResponse response = await deliveryService.getAllDeliveries();
    // Handle response

    fetchingDeliveries = false;
    update();
    if (response.status == "success") {
      allDeliveries = (response.data as List)
          .map((sh) => DeliveryModel.fromJson(sh))
          .toList();
      update();
    }
    getRiderStats();
  }

  Future<void> getDelivery() async {
    fetchingDeliveries = true;
    update();

    APIResponse response =
        await deliveryService.getDelivery({'id': selectedDelivery!.id});
    // Handle response
    showToast(
      message: response.message,
      isError: response.status != "success",
    );
    fetchingDeliveries = false;
    update();
    if (response.status == "success") {
      selectedDelivery = DeliveryModel.fromJson(response.data);
      update();
    }
  }

  DeliveryModel? selectedDelivery;
  setSelectedDelivery(DeliveryModel sh) {
    selectedDelivery = sh;

    update();
  }

  bool isOnline = false;
  toggleOnlineStatus() async {
    if (settingsController.userProfile != null) {
      isOnline = !isOnline;
      if (isOnline) {
        try {
          await serviceManager
              .initializeServices(settingsController.userProfile!);
          showToast(
            message: "You're online",
            isError: false,
          );
        } catch (e) {
          showToast(
              message: "Failed to initialize services: ${e.toString()}",
              isError: true);
        }
      } else {
        await serviceManager.disposeServices();
        showToast(
          message: "You're offline",
          isError: false,
        );
      }
      update();
    }
  }

  Set<Marker> markerSet = {};
  Set<Circle> circleSet = {};
  DirectionDetailsInfo? rideDirectionDetailsInfo;
  final Completer<GoogleMapController> googleMapController =
      Completer<GoogleMapController>();
  GoogleMapController? newGoogleMapController;
  List<LatLng> pLineCoordinatedList = [];
  Set<Polyline> polyLineSet = {};

  Future<void> drawPolyLineFromOriginToDestination(BuildContext context,
      {required String originLatitude,
      required String originLongitude,
      required String destinationLatitude,
      required String destinationLongitude,
      required String originAddress,
      required String destinationAddress}) async {
    var originLatLng =
        LatLng(double.parse(originLatitude), double.parse(originLongitude));
    var destinationLatLng = LatLng(
        double.parse(destinationLatitude), double.parse(destinationLongitude));

    var directionDetailsInfo = await obtainOriginToDestinationDirectionDetails(
        originLatLng, destinationLatLng);

    rideDirectionDetailsInfo = directionDetailsInfo;
    distanceToDestination = rideDirectionDetailsInfo!.distance_text;
    durationToDestination = rideDirectionDetailsInfo!.duration_text;

    // Navigator.pop(context);
    PolylinePoints pPoints = PolylinePoints();
    List<PointLatLng> decodePolyLinePointsResultList =
        pPoints.decodePolyline(directionDetailsInfo.e_points!);
    pLineCoordinatedList.clear();

    if (decodePolyLinePointsResultList.isNotEmpty) {
      decodePolyLinePointsResultList.forEach((PointLatLng pointLatLng) {
        pLineCoordinatedList
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
      update();
    }
    polyLineSet.clear();
    Polyline polyline = Polyline(
        polylineId: const PolylineId("PolyLineId"),
        jointType: JointType.mitered,
        color: Colors.blue[900]!,
        points: pLineCoordinatedList,
        startCap: Cap.squareCap,
        endCap: Cap.squareCap,
        geodesic: true,
        width: 5);

    polyLineSet.add(polyline);
    update();
    LatLngBounds latLngBounds;
    if (originLatLng.latitude > destinationLatLng.latitude &&
        originLatLng.longitude > destinationLatLng.longitude) {
      latLngBounds =
          LatLngBounds(southwest: destinationLatLng, northeast: originLatLng);
    } else if (originLatLng.longitude > destinationLatLng.longitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(originLatLng.latitude, destinationLatLng.longitude),
          northeast:
              LatLng(destinationLatLng.latitude, originLatLng.longitude));
    } else if (originLatLng.latitude > destinationLatLng.latitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(destinationLatLng.latitude, originLatLng.longitude),
          northeast:
              LatLng(originLatLng.latitude, destinationLatLng.longitude));
    } else {
      latLngBounds =
          LatLngBounds(southwest: originLatLng, northeast: destinationLatLng);
    }
    if (newGoogleMapController != null) {
      newGoogleMapController!
          .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 65));
    } else {
      print("================================================");
      print("GoogleMapController is not initialized yet.");
      print("================================================");
    }
    Marker originMarker = Marker(
      markerId: const MarkerId('OriginID'),
      infoWindow: InfoWindow(
          title: selectedDelivery?.originLocation.name ?? "",
          snippet: "Sender"),
      position: LatLng(double.parse(selectedDelivery!.originLocation.latitude),
          double.parse(selectedDelivery!.originLocation.longitude)),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
    Marker destinationMarker = Marker(
      markerId: const MarkerId('destinationID'),
      infoWindow: InfoWindow(
          title: selectedDelivery?.destinationLocation.name ?? "",
          snippet: "Receiver"),
      position: LatLng(
          double.parse(selectedDelivery!.destinationLocation.latitude),
          double.parse(selectedDelivery!.destinationLocation.longitude)),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );
    markerSet.clear();
    markerSet.add(originMarker);
    markerSet.add(destinationMarker);
    Circle originCircle = Circle(
        circleId: const CircleId('originId'),
        fillColor: AppColors.primaryColor,
        radius: 20,
        strokeWidth: 12,
        strokeColor: AppColors.whiteColor,
        center: originLatLng);
    Circle destinationCircle = Circle(
        circleId: const CircleId('destinationId'),
        fillColor: AppColors.primaryColor,
        radius: 20,
        strokeWidth: 12,
        strokeColor: AppColors.whiteColor,
        center: destinationLatLng);

    circleSet.assign(originCircle);
    circleSet.assign(destinationCircle);
    update();
  }

  Future<void> drawPolylineFromRiderToDestination(BuildContext context,
      {required LatLng destinationPosition, LatLng? currentLocation}) async {
    // Get the user's current location
    LatLng riderLatLng = currentLocation ??
        LatLng(
          (await Geolocator.getCurrentPosition(
                  desiredAccuracy: LocationAccuracy.bestForNavigation))
              .latitude,
          (await Geolocator.getCurrentPosition(
                  desiredAccuracy: LocationAccuracy.bestForNavigation))
              .longitude,
        );

    // Fetch direction details
    var directionDetailsInfo = await obtainOriginToDestinationDirectionDetails(
        riderLatLng, destinationPosition);

    rideDirectionDetailsInfo = directionDetailsInfo;
    distanceToDestination = rideDirectionDetailsInfo!.distance_text;
    durationToDestination = rideDirectionDetailsInfo!.duration_text;

    // Decode the polyline points
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolylinePoints =
        polylinePoints.decodePolyline(directionDetailsInfo.e_points ?? "");

    pLineCoordinatedList.clear();
    if (decodedPolylinePoints.isNotEmpty) {
      decodedPolylinePoints.forEach((PointLatLng pointLatLng) {
        pLineCoordinatedList
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
      update();
    }

    // Create and add the polyline
    polyLineSet.clear();
    Polyline polyline = Polyline(
      polylineId: const PolylineId("UserToSenderPolyline"),
      jointType: JointType.mitered,
      color: Colors.green[700]!,
      points: pLineCoordinatedList,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      geodesic: true,
      width: 5,
    );

    polyLineSet.add(polyline);
    update();

    // Adjust camera bounds
    LatLngBounds latLngBounds;
    if (riderLatLng.latitude > destinationPosition.latitude &&
        riderLatLng.longitude > destinationPosition.longitude) {
      latLngBounds =
          LatLngBounds(southwest: destinationPosition, northeast: riderLatLng);
    } else if (riderLatLng.longitude > destinationPosition.longitude) {
      latLngBounds = LatLngBounds(
          southwest:
              LatLng(riderLatLng.latitude, destinationPosition.longitude),
          northeast:
              LatLng(destinationPosition.latitude, riderLatLng.longitude));
    } else if (riderLatLng.latitude > destinationPosition.latitude) {
      latLngBounds = LatLngBounds(
          southwest:
              LatLng(destinationPosition.latitude, riderLatLng.longitude),
          northeast:
              LatLng(riderLatLng.latitude, destinationPosition.longitude));
    } else {
      latLngBounds =
          LatLngBounds(southwest: riderLatLng, northeast: destinationPosition);
    }

    if (newGoogleMapController != null) {
      newGoogleMapController!
          .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 65));
    } else {
      print("GoogleMapController is not initialized yet.");
    }

    // Add markers and circles

    Marker originMarker = Marker(
      markerId: MarkerId(settingsController.userProfile!.id.toString()),
      infoWindow: InfoWindow(title: "You", snippet: "Origin"),
      position: LatLng(
        riderLatLng.latitude,
        riderLatLng.longitude,
      ),
      icon: bikeMarkerIcon ?? BitmapDescriptor.defaultMarker,
    );
    Marker? destinationMarker;
    if (['accepted'].contains(selectedDelivery!.status)) {
      destinationMarker = Marker(
        markerId: const MarkerId('senderID'),
        infoWindow: InfoWindow(
            title: selectedDelivery?.originLocation.name ?? "",
            snippet: "Sender"),
        position: LatLng(
            double.parse(selectedDelivery!.originLocation.latitude),
            double.parse(selectedDelivery!.originLocation.longitude)),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      );
    } else if (['picked'].contains(selectedDelivery!.status)) {
      destinationMarker = Marker(
        markerId: const MarkerId('receiverID'),
        infoWindow: InfoWindow(
            title: selectedDelivery?.destinationLocation.name ?? "",
            snippet: "Receiver"),
        position: LatLng(
            double.parse(selectedDelivery!.destinationLocation.latitude),
            double.parse(selectedDelivery!.destinationLocation.longitude)),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      );
    }
    markerSet.clear();
    markerSet.add(originMarker);
    if (destinationMarker != null) {
      markerSet.add(destinationMarker);
    }

    Circle userCircle = Circle(
      circleId: const CircleId('UserCircleId'),
      fillColor: Colors.blueAccent,
      radius: 20,
      strokeWidth: 8,
      strokeColor: Colors.white,
      center: riderLatLng,
    );
    Circle senderCircle = Circle(
      circleId: const CircleId('SenderCircleId'),
      fillColor: Colors.redAccent,
      radius: 20,
      strokeWidth: 8,
      strokeColor: Colors.white,
      center: destinationPosition,
    );

    circleSet.assign(userCircle);
    circleSet.assign(senderCircle);
    update();
  }

  bool acceptingDelivery = false;
  bool acceptedDelivery = false;
  Future<void> acceptDelivery(BuildContext context,
      {required String trackingId}) async {
    acceptedDelivery = false;
    acceptingDelivery = true;
    update();
    final dynamic data = {
      "tracking_id": trackingId,
      "action": "accept",
    };

    // Call the API
    APIResponse response = await deliveryService.updateDeliveryStatus(data);
    // Handle response
    showToast(
      message: response.message,
      isError: response.status != "success",
    );
    acceptingDelivery = false;
    update();
    if (response.status == "success") {
      selectedDelivery = DeliveryModel.fromJson(response.data);

      if (Get.isRegistered<LocationService>()) {
        await Get.find<LocationService>().joinParcelTrackingRoom(
            trackingId: selectedDelivery?.trackingId ?? "");
        Get.find<LocationService>()
            .notifyUserOfDeliveryAcceptanceWithLocationLocation(
                deliveryModel: selectedDelivery!);
        Get.find<LocationService>()
            .startEmittingParcelLocation(deliveryModel: selectedDelivery!);
        Get.find<LocationService>()
            .listenForParcelLocationUpdate(roomId: "rider_tracking");
      } else {
        await serviceManager
            .initializeServices(settingsController.userProfile!);
        await Get.find<LocationService>().joinParcelTrackingRoom(
            trackingId: selectedDelivery?.trackingId ?? "");
        Get.find<LocationService>()
            .notifyUserOfDeliveryAcceptanceWithLocationLocation(
                deliveryModel: selectedDelivery!);
        Get.find<LocationService>()
            .startEmittingParcelLocation(deliveryModel: selectedDelivery!);
        Get.find<LocationService>()
            .listenForParcelLocationUpdate(roomId: "rider_tracking");
      }
      acceptedDelivery = true;
      update();
    }
  }

  //
  // BitmapDescriptor? bikeMarkerIcon;
  // getBikeIcon() async {
  //   var icon = await BitmapDescriptor.asset(
  //       const ImageConfiguration(), PngAssets.carIcon,
  //       width: 35.sp, height: 35.sp);
  //   bikeMarkerIcon = icon;
  //   update();
  // }
  BitmapDescriptor? bikeMarkerIcon;
  getBikeIcon() async {
    var icon = await BitmapDescriptor.asset(
      const ImageConfiguration(),
      PngAssets.motorCycleIcon,
      width: 35.sp,
      height: 35.sp,
    );
    bikeMarkerIcon = icon;
    update();
  }

  resetDeliveriesSearchFields() {
    searchQueryController.clear();
    deliverySearchResults.clear();
    update();
  }

  List<DeliveryModel> deliverySearchResults = [];
  TextEditingController searchQueryController = TextEditingController();
  bool searchingDeliveries = false;
  searchDeliveries() async {
    if (deliveriesSearchFormKey.currentState!.validate()) {
      dynamic data = {'search': searchQueryController.text};
      searchingDeliveries = true;
      update();
      APIResponse response = await deliveryService.searchDeliveries(data);
      searchingDeliveries = false;
      update();
      if (response.status == "success") {
        deliverySearchResults = (response.data as List)
            .map((sh) => DeliveryModel.fromJson(sh))
            .toList();
        update();
      } else {
        showToast(
          message: response.message,
          isError: response.status != "success",
        );
      }
    }
  }

  bool updatingDeliveryStatus = false;
  Future<void> updateDeliveryStatus(BuildContext context,
      {required String status}) async {
    updatingDeliveryStatus = true;
    update();
    final dynamic data = {
      "tracking_id": selectedDelivery!.trackingId,
      "action": status.toLowerCase(),
    };

    // Call the API
    APIResponse response = await deliveryService.updateDeliveryStatus(data);
    // Handle response
    showToast(
      message: response.message,
      isError: response.status != "success",
    );

    if (response.status == "success") {
      if (status == 'deliver') {
        await Get.find<LocationService>().leaveParcelTrackingRoom(
            trackingId: selectedDelivery?.trackingId ?? "");
      }
      selectedDelivery = DeliveryModel.fromJson(response.data);
      if (['picked'].contains(selectedDelivery!.status)) {
        drawPolylineFromRiderToDestination(context,
            destinationPosition: LatLng(
                double.parse(selectedDelivery!.destinationLocation.latitude),
                double.parse(selectedDelivery!.destinationLocation.longitude)));
      } else if (['delivered'].contains(selectedDelivery!.status)) {
        drawPolyLineFromOriginToDestination(context,
            originLatitude: selectedDelivery!.originLocation.latitude,
            originLongitude: selectedDelivery!.originLocation.longitude,
            originAddress: selectedDelivery!.originLocation.name,
            destinationLatitude: selectedDelivery!.destinationLocation.latitude,
            destinationLongitude:
                selectedDelivery!.destinationLocation.longitude,
            destinationAddress: selectedDelivery!.destinationLocation.name);
      }
      await getDelivery();
      updatingDeliveryStatus = false;
      update();
      fetchDeliveries();
    } else {
      updatingDeliveryStatus = false;
      update();
    }
  }

  RiderStatsModel? riderStatsModel;
  getRiderStats() async {
    APIResponse response = await profileService.getRiderStats();
    if (response.status == "success") {
      riderStatsModel = RiderStatsModel.fromJson(response.data);
      update();
    } else {
      showToast(
          message: response.message, isError: response.status != "success");
    }
  }

  @override
  void onReady() {
    super.onReady();
    fetchDeliveries();
    getBikeIcon();
  }
}
