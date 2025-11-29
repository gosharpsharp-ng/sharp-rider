
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gorider/core/utils/exports.dart';

class DeliveriesController extends GetxController with WidgetsBindingObserver {
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

  // Status filtering
  final List<String> deliveryStatuses = [
    'all',
    'accepted',
    'picked',
    'delivered',
    'cancelled'
  ];
  String selectedDeliveryStatus = 'all';

  void setSelectedDeliveryStatus(String status) {
    selectedDeliveryStatus = status;
    update();
    // Fetch deliveries when status changes
    fetchDeliveries();
  }

  List<DeliveryModel> get filteredDeliveries {
    if (selectedDeliveryStatus == 'all') {
      return allDeliveries;
    }
    return allDeliveries
        .where((delivery) =>
            delivery.status?.toLowerCase() ==
            selectedDeliveryStatus.toLowerCase())
        .toList();
  }

  int getDeliveryCountByStatus(String status) {
    if (status == 'all') {
      return allDeliveries.length;
    }
    return allDeliveries
        .where((delivery) =>
            delivery.status?.toLowerCase() == status.toLowerCase())
        .length;
  }

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
        (isLoadMore && allDeliveries.length >= totalDeliveries)) {
      return;
    }

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
        // Auto-restore active delivery if rider has one in progress
        _restoreActiveDeliveryIfExists(newDeliveries);
      }

      // Get total from meta object (new API structure) or directly (old structure)
      final total =
          response.data['meta']?['total'] ?? response.data['total'] ?? 0;
      setTotalDeliveries(
          total is int ? total : int.tryParse(total.toString()) ?? 0);
      currentDeliveriesPage++; // Increment for next load more
      update();
    } else {
      if (getStorage.read("token") != null) {
        showToast(
          message: response.message,
          isError: response.status != "success",
        );
      }
    }
  }

  Future<void> getDelivery() async {
    fetchingDeliveries = true;
    update();

    APIResponse response = await deliveryService.getDelivery({
      'tracking_id': selectedDelivery!.trackingId,
    });
    fetchingDeliveries = false;
    update();
    if (response.status == "success") {
      // API returns {delivery: {...}} so extract the delivery object
      final deliveryData = response.data['delivery'] ?? response.data;
      selectedDelivery = DeliveryModel.fromJson(deliveryData);
      update();
    }
  }

  DeliveryModel? selectedDelivery;

  /// Checks if there's an active delivery (accepted or picked) and restores it
  /// This prevents new delivery notifications when rider has an in-progress delivery
  void _restoreActiveDeliveryIfExists(List<DeliveryModel> deliveries) {
    // Only restore if we don't already have an active delivery set
    if (selectedDelivery != null &&
        ['accepted', 'picked']
            .contains(selectedDelivery!.status?.toLowerCase())) {
      return;
    }

    // Find any delivery with 'accepted' or 'picked' status
    final activeDelivery = deliveries.cast<DeliveryModel?>().firstWhere(
          (d) => ['accepted', 'picked'].contains(d?.status?.toLowerCase()),
          orElse: () => null,
        );

    if (activeDelivery != null) {
      selectedDelivery = activeDelivery;
      if (activeDelivery.trackingId != null) {
        pickedDeliveries.add(activeDelivery.trackingId!);
      }
      update();
    }
  }

  setSelectedDelivery(DeliveryModel sh) {
    selectedDelivery = sh;
    if (selectedDelivery?.status?.toLowerCase() != "delivered" &&
        pickedDeliveries.isEmpty &&
        selectedDelivery?.trackingId != null) {
      pickedDeliveries.add(selectedDelivery!.trackingId!);
    }
    update();
  }

  bool isOnline = false;

  Future<void> toggleOnlineStatus() async {
    if (settingsController.reactiveUserProfile.value != null) {
      if (settingsController.reactiveUserProfile.value?.vehicle != null) {
        // if (settingsController.reactiveUserProfile.value?.hasVerifiedVehicle ==
        //     false) {
        //   await Get.find<SettingsController>().getProfile();
        // }
        // if (settingsController.reactiveUserProfile.value?.hasVerifiedVehicle ==
        //     true) {
        isOnline = !isOnline;
        if (isOnline) {
          bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
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
              settingsController.reactiveUserProfile.value!,
            );
          } catch (e) {
            showToast(
              message: "Failed to initialize services: ${e.toString()}",
              isError: true,
            );
          }
        } else {
          await serviceManager.disposeServices();
        }
        update();
        // } else {
        //   showAdminApprovalDialog();
        // }
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

  /// Fit map to show the entire route (origin to destination)
  void fitMapToBounds() {
    if (newGoogleMapController == null || selectedDelivery == null) return;

    try {
      final originLatLng = LatLng(
        double.parse(selectedDelivery!.originLocation.latitude ?? '0.0'),
        double.parse(selectedDelivery!.originLocation.longitude ?? '0.0'),
      );
      final destinationLatLng = LatLng(
        double.parse(selectedDelivery!.destinationLocation.latitude ?? '0.0'),
        double.parse(selectedDelivery!.destinationLocation.longitude ?? '0.0'),
      );

      LatLngBounds latLngBounds;
      if (originLatLng.latitude > destinationLatLng.latitude &&
          originLatLng.longitude > destinationLatLng.longitude) {
        latLngBounds = LatLngBounds(
          southwest: destinationLatLng,
          northeast: originLatLng,
        );
      } else if (originLatLng.longitude > destinationLatLng.longitude) {
        latLngBounds = LatLngBounds(
          southwest: LatLng(originLatLng.latitude, destinationLatLng.longitude),
          northeast: LatLng(destinationLatLng.latitude, originLatLng.longitude),
        );
      } else if (originLatLng.latitude > destinationLatLng.latitude) {
        latLngBounds = LatLngBounds(
          southwest: LatLng(destinationLatLng.latitude, originLatLng.longitude),
          northeast: LatLng(originLatLng.latitude, destinationLatLng.longitude),
        );
      } else {
        latLngBounds = LatLngBounds(
          southwest: originLatLng,
          northeast: destinationLatLng,
        );
      }

      newGoogleMapController!.animateCamera(
        CameraUpdate.newLatLngBounds(latLngBounds, 65),
      );
    } catch (e) {
      debugPrint("Error fitting map to bounds: $e");
    }
  }

  Future<void> drawPolyLineFromOriginToDestination(
    BuildContext context, {
    required String originLatitude,
    required String originLongitude,
    required String destinationLatitude,
    required String destinationLongitude,
    required String originAddress,
    required String destinationAddress,
  }) async {
    await googleMapController.future;
    var originLatLng = LatLng(
      double.parse(originLatitude),
      double.parse(originLongitude),
    );
    var destinationLatLng = LatLng(
      double.parse(destinationLatitude),
      double.parse(destinationLongitude),
    );

    var directionDetailsInfo = await obtainOriginToDestinationDirectionDetails(
      originLatLng,
      destinationLatLng,
    );

    rideDirectionDetailsInfo = directionDetailsInfo;
    distanceToDestination = rideDirectionDetailsInfo!.distance_text;
    durationToDestination = rideDirectionDetailsInfo!.duration_text;

    List<PointLatLng> decodePolyLinePointsResultList =
        PolylinePoints.decodePolyline(directionDetailsInfo.e_points!);
    pLineCoordinatedList.clear();

    if (decodePolyLinePointsResultList.isNotEmpty) {
      for (var pointLatLng in decodePolyLinePointsResultList) {
        pLineCoordinatedList.add(
          LatLng(pointLatLng.latitude, pointLatLng.longitude),
        );
      }
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
      width: 5,
    );

    polyLineSet.add(polyline);
    update();
    LatLngBounds latLngBounds;
    if (originLatLng.latitude > destinationLatLng.latitude &&
        originLatLng.longitude > destinationLatLng.longitude) {
      latLngBounds = LatLngBounds(
        southwest: destinationLatLng,
        northeast: originLatLng,
      );
    } else if (originLatLng.longitude > destinationLatLng.longitude) {
      latLngBounds = LatLngBounds(
        southwest: LatLng(originLatLng.latitude, destinationLatLng.longitude),
        northeast: LatLng(destinationLatLng.latitude, originLatLng.longitude),
      );
    } else if (originLatLng.latitude > destinationLatLng.latitude) {
      latLngBounds = LatLngBounds(
        southwest: LatLng(destinationLatLng.latitude, originLatLng.longitude),
        northeast: LatLng(originLatLng.latitude, destinationLatLng.longitude),
      );
    } else {
      latLngBounds = LatLngBounds(
        southwest: originLatLng,
        northeast: destinationLatLng,
      );
    }
    if (newGoogleMapController != null) {
      try {
        await newGoogleMapController!.animateCamera(
          CameraUpdate.newLatLngBounds(latLngBounds, 65),
        );
      } catch (e) {
        debugPrint("Error animating camera: $e");
      }
    } else {
      debugPrint("GoogleMapController is not initialized yet.");
    }
    Marker originMarker = Marker(
      markerId: const MarkerId('OriginID'),
      infoWindow: InfoWindow(
        title: selectedDelivery?.originLocation.name ?? "",
        snippet: "Sender",
      ),
      position: LatLng(
        double.parse(selectedDelivery!.originLocation.latitude ?? '0.0'),
        double.parse(selectedDelivery!.originLocation.longitude ?? '0.0'),
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
    Marker destinationMarker = Marker(
      markerId: const MarkerId('destinationID'),
      infoWindow: InfoWindow(
        title: selectedDelivery?.destinationLocation.name ?? "",
        snippet: "Receiver",
      ),
      position: LatLng(
        double.parse(selectedDelivery!.destinationLocation.latitude ?? '0.0'),
        double.parse(selectedDelivery!.destinationLocation.longitude ?? '0.0'),
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );
    markerSet.clear();
    markerSet.add(originMarker);
    markerSet.add(destinationMarker);
    update();
  }

  Future<void> drawPolylineFromRiderToDestination(
    BuildContext context, {
    required LatLng destinationPosition,
    LatLng? currentLocation,
  }) async {
    // Get the user's current location
    LatLng riderLatLng = currentLocation ??
        LatLng(
          (await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.bestForNavigation,
          ))
              .latitude,
          (await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.bestForNavigation,
          ))
              .longitude,
        );
    await googleMapController.future;
    // Fetch direction details
    var directionDetailsInfo = await obtainOriginToDestinationDirectionDetails(
      riderLatLng,
      destinationPosition,
    );

    rideDirectionDetailsInfo = directionDetailsInfo;
    distanceToDestination = rideDirectionDetailsInfo!.distance_text;
    durationToDestination = rideDirectionDetailsInfo!.duration_text;

    // Decode the polyline points
    List<PointLatLng> decodedPolylinePoints = PolylinePoints.decodePolyline(
      directionDetailsInfo.e_points ?? "",
    );

    pLineCoordinatedList.clear();
    if (decodedPolylinePoints.isNotEmpty) {
      for (var pointLatLng in decodedPolylinePoints) {
        pLineCoordinatedList.add(
          LatLng(pointLatLng.latitude, pointLatLng.longitude),
        );
      }
      update();
    }

    // Create and add the polyline
    polyLineSet.clear();
    Polyline polyline = Polyline(
      polylineId: const PolylineId("UserToSenderPolyline"),
      jointType: JointType.mitered,
      color: Colors.green,
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
      latLngBounds = LatLngBounds(
        southwest: destinationPosition,
        northeast: riderLatLng,
      );
    } else if (riderLatLng.longitude > destinationPosition.longitude) {
      latLngBounds = LatLngBounds(
        southwest: LatLng(riderLatLng.latitude, destinationPosition.longitude),
        northeast: LatLng(destinationPosition.latitude, riderLatLng.longitude),
      );
    } else if (riderLatLng.latitude > destinationPosition.latitude) {
      latLngBounds = LatLngBounds(
        southwest: LatLng(destinationPosition.latitude, riderLatLng.longitude),
        northeast: LatLng(riderLatLng.latitude, destinationPosition.longitude),
      );
    } else {
      latLngBounds = LatLngBounds(
        southwest: riderLatLng,
        northeast: destinationPosition,
      );
    }

    if (newGoogleMapController != null) {
      try {
        await newGoogleMapController!.animateCamera(
          CameraUpdate.newLatLngBounds(latLngBounds, 65),
        );
      } catch (e) {
        debugPrint("Error animating camera: $e");
      }
    } else {
      debugPrint("GoogleMapController is not initialized yet.");
    }

    // Add markers

    Marker originMarker = Marker(
      markerId: MarkerId(settingsController.userProfile!.id.toString()),
      infoWindow: const InfoWindow(title: "You", snippet: "Origin"),
      position: LatLng(riderLatLng.latitude, riderLatLng.longitude),
      icon: bikeMarkerIcon ?? BitmapDescriptor.defaultMarker,
    );
    Marker? destinationMarker;
    if (['accepted'].contains(selectedDelivery!.status)) {
      destinationMarker = Marker(
        markerId: const MarkerId('senderID'),
        infoWindow: InfoWindow(
          title: selectedDelivery?.originLocation.name ?? "",
          snippet: "Sender",
        ),
        position: LatLng(
          double.parse(selectedDelivery!.originLocation.latitude ?? '0.0'),
          double.parse(selectedDelivery!.originLocation.longitude ?? '0.0'),
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      );
    } else if (['picked'].contains(selectedDelivery!.status)) {
      destinationMarker = Marker(
        markerId: const MarkerId('receiverID'),
        infoWindow: InfoWindow(
          title: selectedDelivery?.destinationLocation.name ?? "",
          snippet: "Receiver",
        ),
        position: LatLng(
          double.parse(selectedDelivery!.destinationLocation.latitude ?? '0.0'),
          double.parse(
              selectedDelivery!.destinationLocation.longitude ?? '0.0'),
        ),
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

  List<String> rejectedDeliveries = [];
  List<String> pickedDeliveries = [];
  bool acceptingDelivery = false;
  bool acceptedDelivery = false;

  Future<void> rejectDelivery({required String trackingId}) async {
    update();
    final dynamic data = {"tracking_id": trackingId, "action": "reject"};

    deliveryService.updateDeliveryStatus(data);
  }

  // Store last acceptance response for result screen
  String lastAcceptanceMessage = '';
  String lastAcceptanceTrackingId = '';

  Future<void> acceptDelivery(
    BuildContext context, {
    required String trackingId,
  }) async {
    acceptedDelivery = false;
    acceptingDelivery = true;
    lastAcceptanceMessage = '';
    lastAcceptanceTrackingId = trackingId;
    update();

    // Call the API with correct action name "accepted"
    APIResponse response = await deliveryService.triggerDeliveryAction(
      trackingId: trackingId,
      action: "accepted",
    );
    // Handle response
    acceptingDelivery = false;
    lastAcceptanceMessage = response.message;
    update();

    if (response.status == "success") {
      pickedDeliveries.add(trackingId);
      update();
      // API returns {delivery: {...}} so extract the delivery object
      final deliveryData = response.data['delivery'] ?? response.data;
      selectedDelivery = DeliveryModel.fromJson(deliveryData);
      await getDelivery();
      if (Get.isRegistered<LocationService>()) {
        await Get.find<LocationService>().joinParcelTrackingRoom(
          trackingId: selectedDelivery?.trackingId ?? "",
        );
        Get.find<LocationService>()
            .notifyUserOfDeliveryStatusWithLocationLocation(
          deliveryModel: selectedDelivery!,
        );
        Get.find<LocationService>().startEmittingParcelLocation(
          deliveryModel: selectedDelivery!,
        );
      } else {
        await serviceManager.initializeServices(
          settingsController.userProfile!,
        );
        await Get.find<LocationService>().joinParcelTrackingRoom(
          trackingId: selectedDelivery?.trackingId ?? "",
        );
        await Get.find<SocketService>().updateRiderAvailabilityStatus("busy");
        Get.find<LocationService>()
            .notifyUserOfDeliveryStatusWithLocationLocation(
          deliveryModel: selectedDelivery!,
        );
        Get.find<LocationService>().startEmittingParcelLocation(
          deliveryModel: selectedDelivery!,
        );
      }
      acceptedDelivery = true;
      acceptingDelivery = false;
      update();
      // Refresh deliveries list after accepting
      fetchDeliveries();
    } else {
      acceptedDelivery = false;
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
        (isLoadMore && deliverySearchResults.length >= totalSearchDeliveries)) {
      return;
    }

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
      currentSearchDeliveriesPage++;
      update();
    } else {
      showToast(
        message: response.message,
        isError: response.status != "success",
      );
    }
  }

  bool updatingDeliveryStatus = false;

  Future<void> updateDeliveryStatus(
    BuildContext context, {
    required String status,
    String? deliveryCode,
  }) async {
    updatingDeliveryStatus = true;
    update();

    // Map status to correct action name for API
    String action = status.toLowerCase();
    if (action == "pick") action = "picked";
    if (action == "accept") action = "accepted";
    if (action == "deliver") action = "delivered";

    // Call the API with correct endpoint
    APIResponse response = await deliveryService.triggerDeliveryAction(
      trackingId: selectedDelivery!.trackingId ?? '',
      action: action,
      deliveryCode: deliveryCode,
    );
    // Handle response
    // showToast(message: response.message, isError: response.status != "success");
    if (response.status == "success") {
      showSuccessSheet(
        title: "Delivery Updated",
        message: response.message,
      );
    } else {
      showErrorSheet(
        title: "Update Failed",
        message: response.message,
      );
    }

    if (response.status == "success") {
      if (Get.isRegistered<LocationService>()) {
        await getDelivery();

        if (status.toLowerCase() == "accept") {
          await Get.find<LocationService>().joinParcelTrackingRoom(
            trackingId: selectedDelivery?.trackingId ?? "",
          );
        }

        Get.find<LocationService>()
            .notifyUserOfDeliveryStatusWithLocationLocation(
          deliveryModel: selectedDelivery!,
        );
        if (status.toLowerCase() == "deliver") {
          update();
          await Get.find<SocketService>().updateRiderAvailabilityStatus("busy");
        }
      } else {
        await serviceManager.initializeServices(
          settingsController.userProfile!,
        );
        await Get.find<LocationService>().joinParcelTrackingRoom(
          trackingId: selectedDelivery?.trackingId ?? "",
        );
        // Notify user of current status of delivery
        Get.find<LocationService>()
            .notifyUserOfDeliveryStatusWithLocationLocation(
          deliveryModel: selectedDelivery!,
        );
      }
      if (status.toLowerCase() == 'deliver') {
        pickedDeliveries.clear();
        update();
        await Get.find<LocationService>().leaveParcelTrackingRoom(
          trackingId: selectedDelivery?.trackingId ?? "",
        );
        // Reload rider profile to get updated wallet balance
        if (Get.isRegistered<SettingsController>()) {
          await Get.find<SettingsController>().getProfile();
        }
        // Load wallet from updated profile
        if (Get.isRegistered<WalletController>()) {
          Get.find<WalletController>().loadWalletFromProfile();
        }
        // await getRiderStats();
        // await getRiderRatingStats();
        Navigator.pop(Get.context!);
        // Get.offAndToNamed(Routes.RIDER_PERFORMANCE_SCREEN);
      }
      // API returns {delivery: {...}} so extract the delivery object
      final deliveryData = response.data['delivery'] ?? response.data;
      selectedDelivery = DeliveryModel.fromJson(deliveryData);
      if (['picked'].contains(selectedDelivery!.status)) {
        drawPolylineFromRiderToDestination(
          context,
          destinationPosition: LatLng(
            double.parse(
                selectedDelivery!.destinationLocation.latitude ?? '0.0'),
            double.parse(
                selectedDelivery!.destinationLocation.longitude ?? '0.0'),
          ),
        );
      } else if (['delivered'].contains(selectedDelivery!.status)) {
        drawPolyLineFromOriginToDestination(
          context,
          originLatitude: selectedDelivery!.originLocation.latitude ?? '0.0',
          originLongitude: selectedDelivery!.originLocation.longitude ?? '0.0',
          originAddress: selectedDelivery!.originLocation.name ?? '',
          destinationLatitude:
              selectedDelivery!.destinationLocation.latitude ?? '0.0',
          destinationLongitude:
              selectedDelivery!.destinationLocation.longitude ?? '0.0',
          destinationAddress: selectedDelivery!.destinationLocation.name ?? '',
        );
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
        message: response.message,
        isError: response.status != "success",
      );
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
        message: response.message,
        isError: response.status != "success",
      );
    }
  }

  @override
  void onReady() {
    super.onReady();
    WidgetsBinding.instance.addObserver(this);
    deliveriesScrollController.addListener(_deliveriesScrollListener);
    searchDeliveriesScrollController.addListener(
      _searchDeliveriesScrollListener,
    );
    fetchDeliveries();
    getBikeIcon();
  }

  @override
  void onInit() {
    WidgetsBinding.instance.addObserver(this); // Register observer
    super.onInit();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      final userProfile = settingsController.reactiveUserProfile.value;

      if (userProfile != null) {
        // Check if SocketService is registered
        if (!Get.isRegistered<SocketService>()) {
          await serviceManager.initializeServices(userProfile);
        }

        // Socket service available for future use if needed
        // final websocketService = Get.find<SocketService>();
      } else {
        debugPrint(
          'User profile is null on app resume — skipping socket initialization.',
        );
      }
    }
  }
}
