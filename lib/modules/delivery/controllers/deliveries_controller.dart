import 'dart:developer';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_logistics_driver/utils/exports.dart';

class DeliveriesController extends GetxController {
  final deliveryService = serviceLocator<DeliveryService>();
  final profileService = serviceLocator<ProfileService>();
  final sendingInfoFormKey = GlobalKey<FormState>();
  final deliveriesSearchFormKey = GlobalKey<FormState>();
  final itemDetailsFormKey = GlobalKey<FormState>();
  final serviceManager = Get.find<DeliveryNotificationServiceManager>();
  final settingsController = Get.find<SettingsController>();

  List<DeliveryModel> allDeliveries = [];
  String? distanceToDestination;
  String? durationToDestination;
  bool fetchingDeliveries = false;
  final ScrollController deliveriesScrollController = ScrollController();

  void _deliveriesScrollListener() {
    if (deliveriesScrollController.position.pixels >=
        deliveriesScrollController.position.maxScrollExtent - 100) {
      fetchDeliveries(isLoadMore: true);
    }
  }

  int deliveriesPageSize = 15;
  int totalDeliveries = 0;
  int currentDeliveriesPage = 1;

  setTotalDeliveries(int val) {
    totalDeliveries = val;
    update();
  }

  fetchDeliveries({bool isLoadMore = false}) async {
    if (fetchingDeliveries ||
        (isLoadMore && allDeliveries.length >= totalDeliveries)) return;

    fetchingDeliveries = true;
    update();

    if (!isLoadMore) {
      allDeliveries.clear(); // Clear only when not loading more
      currentDeliveriesPage = 1;
    }

    dynamic data = {
      "page": currentDeliveriesPage,
      "per_page": deliveriesPageSize,
    };
    final getStorage = GetStorage();
    APIResponse response = await deliveryService.getAllDeliveries(data);
    fetchingDeliveries = false;

    if (response.status == "success") {
      List<DeliveryModel> newDeliveries = (response.data['data'] as List)
          .map((sh) => DeliveryModel.fromJson(sh))
          .toList();

      if (isLoadMore) {
        allDeliveries.addAll(newDeliveries);
      } else {
        allDeliveries = newDeliveries;
      }

      setTotalDeliveries(response.data['total']);
      currentDeliveriesPage++; // Increment for next load more
      update();
    } else {
      if (getStorage.read("token") != null) {
        showToast(
            message: response.message, isError: response.status != "success");
      }
    }
  }

  Future<void> getDelivery() async {
    fetchingDeliveries = true;
    update();

    APIResponse response =
        await deliveryService.getDelivery({'id': selectedDelivery!.id});
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

  Future<void> toggleOnlineStatus() async {
    if (settingsController.reactiveUserProfile.value != null) {
      if (settingsController.reactiveUserProfile.value?.vehicle != null) {
        await Get.find<SettingsController>().getProfile();
        if (settingsController.reactiveUserProfile.value?.hasVerifiedVehicle ==
            true) {
          isOnline = !isOnline;
          if (isOnline) {
            bool isLocationEnabled =
                await Geolocator.isLocationServiceEnabled();
            LocationPermission permission = await Geolocator.checkPermission();

            if (!isLocationEnabled || permission == LocationPermission.denied) {
              bool granted = await showLocationPermissionDialog();
              if (!granted) {
                isOnline = false; // Revert status
                update();
                return;
              }
            }

            try {
              await serviceManager.initializeServices(
                  settingsController.reactiveUserProfile.value!);
              showToast(
                message: "You're online",
                isError: false,
              );
            } catch (e) {
              showToast(
                message: "Failed to initialize services: ${e.toString()}",
                isError: true,
              );
            }
          } else {
            await serviceManager.disposeServices();
            showToast(
              message: "You're offline",
              isError: false,
            );
          }
          update();
        } else {
          showAdminApprovalDialog();
        }
      } else {
        showAddBikeDialog();
      }
    }
  }

  Set<Marker> markerSet = {};
  DirectionDetailsInfo? rideDirectionDetailsInfo;
  final Completer<GoogleMapController> googleMapController =
      Completer<GoogleMapController>();
  GoogleMapController? newGoogleMapController;
  List<LatLng> pLineCoordinatedList = [];
  Set<Polyline> polyLineSet = {};

  Future<void> setMapController(GoogleMapController controller) async {
    if (!googleMapController.isCompleted) {
      googleMapController.complete(controller);
    }
    newGoogleMapController = controller; // Store the initialized controller
    update(); // Notify listeners
  }

  Future<void> drawPolyLineFromOriginToDestination(BuildContext context,
      {required String originLatitude,
      required String originLongitude,
      required String destinationLatitude,
      required String destinationLongitude,
      required String originAddress,
      required String destinationAddress}) async {
    await googleMapController.future;
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
        color: Colors.green,
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
    await googleMapController.future;
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
      color: Colors.green!,
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

    // Add markers

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
    acceptingDelivery = false;
    update();
    if (response.status == "success") {
      showToast(
        message: response.message,
        isError: response.status != "success",
      );
      selectedDelivery = DeliveryModel.fromJson(response.data);
      await getDelivery();
      if (Get.isRegistered<LocationService>()) {
        await Get.find<LocationService>().joinParcelTrackingRoom(
            trackingId: selectedDelivery?.trackingId ?? "");
        Get.find<LocationService>()
            .notifyUserOfDeliveryStatusWithLocationLocation(
                deliveryModel: selectedDelivery!);
        Get.find<LocationService>()
            .startEmittingParcelLocation(deliveryModel: selectedDelivery!);
      } else {
        await serviceManager
            .initializeServices(settingsController.userProfile!);
        await Get.find<LocationService>().joinParcelTrackingRoom(
            trackingId: selectedDelivery?.trackingId ?? "");
        Get.find<LocationService>()
            .notifyUserOfDeliveryStatusWithLocationLocation(
                deliveryModel: selectedDelivery!);
        Get.find<LocationService>()
            .startEmittingParcelLocation(deliveryModel: selectedDelivery!);
      }
      acceptedDelivery = true;
      acceptingDelivery = false;
      update();
    } else {
      showToast(
        message: response.message,
        isError: response.status != "success",
      );
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
    searchDeliveriesPageSize = 15;
    currentSearchDeliveriesPage = 1;
    totalSearchDeliveries = 0;
    update();
  }

  final ScrollController searchDeliveriesScrollController = ScrollController();
  bool searchingDeliveries = false;

  void _searchDeliveriesScrollListener() {
    if (searchDeliveriesScrollController.position.pixels >=
        searchDeliveriesScrollController.position.maxScrollExtent - 100) {
      searchDeliveries(isLoadMore: true);
    }
  }

  int searchDeliveriesPageSize = 15;
  int totalSearchDeliveries = 0;
  int currentSearchDeliveriesPage = 1;
  List<DeliveryModel> deliverySearchResults = [];

  TextEditingController searchQueryController = TextEditingController();

  setTotalSearchDeliveries(int val) {
    totalSearchDeliveries = val;
    update();
  }

  searchDeliveries({bool isLoadMore = false}) async {
    if (searchingDeliveries ||
        (isLoadMore && deliverySearchResults.length >= totalSearchDeliveries))
      return;

    if (!deliveriesSearchFormKey.currentState!.validate()) return;

    searchingDeliveries = true;
    update();

    if (!isLoadMore) {
      deliverySearchResults.clear(); // Clear only when not loading more
      currentSearchDeliveriesPage = 1;
    }

    dynamic data = {
      'search': searchQueryController.text,
      "page": currentSearchDeliveriesPage,
      "per_page": searchDeliveriesPageSize,
    };

    APIResponse response = await deliveryService.searchDeliveries(data);
    searchingDeliveries = false;

    if (response.status == "success") {
      List<DeliveryModel> newResults = (response.data['data'] as List)
          .map((sh) => DeliveryModel.fromJson(sh))
          .toList();

      if (isLoadMore) {
        deliverySearchResults.addAll(newResults);
      } else {
        deliverySearchResults = newResults;
      }

      setTotalSearchDeliveries(response.data['total']);
      currentSearchDeliveriesPage++; // Increment for next load more
      update();
    } else {
      showToast(
        message: response.message,
        isError: response.status != "success",
      );
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
      if (Get.isRegistered<LocationService>()) {
        await getDelivery();
        await Get.find<LocationService>().joinParcelTrackingRoom(
            trackingId: selectedDelivery?.trackingId ?? "");
        Get.find<LocationService>()
            .notifyUserOfDeliveryStatusWithLocationLocation(
                deliveryModel: selectedDelivery!);
      } else {
        await serviceManager
            .initializeServices(settingsController.userProfile!);
        await Get.find<LocationService>().joinParcelTrackingRoom(
            trackingId: selectedDelivery?.trackingId ?? "");
        // Notify user of current status of delivery
        Get.find<LocationService>()
            .notifyUserOfDeliveryStatusWithLocationLocation(
                deliveryModel: selectedDelivery!);
      }
      if (status.toLowerCase() == 'deliver') {
        await Get.find<LocationService>().leaveParcelTrackingRoom(
            trackingId: selectedDelivery?.trackingId ?? "");
        Get.find<WalletController>().getWalletBalance();
        await getRiderStats();
        await getRiderRatingStats();
        Navigator.pop(Get.context!);
        Get.offAndToNamed(Routes.RIDER_PERFORMANCE_SCREEN);
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

  ReviewModel? riderRatingStatsModel;
  getRiderRatingStats() async {
    APIResponse response = await profileService.getRiderRatingStats();
    if (response.status == "success") {
      riderRatingStatsModel = ReviewModel.fromJson(response.data);
      update();
    } else {
      showToast(
          message: response.message, isError: response.status != "success");
    }
  }

  @override
  void onReady() {
    super.onReady();
    deliveriesScrollController.addListener(_deliveriesScrollListener);
    searchDeliveriesScrollController
        .addListener(_searchDeliveriesScrollListener);
    fetchDeliveries();
    getBikeIcon();
  }
}
