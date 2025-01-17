import 'dart:developer';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:go_logistics_driver/models/direction_details_Info.dart';
import 'package:go_logistics_driver/utils/exports.dart';

class OrdersController extends GetxController {
  final shipmentService = serviceLocator<ShipmentService>();
  final sendingInfoFormKey = GlobalKey<FormState>();
  final deliveriesSearchFormKey = GlobalKey<FormState>();
  final itemDetailsFormKey = GlobalKey<FormState>();

  List<ShipmentModel> allShipments = [];
  bool fetchingShipments = false;
  Future<void> fetchShipments() async {
    fetchingShipments = true;
    update();

    APIResponse response = await shipmentService.getAllShipment();
    // Handle response

    fetchingShipments = false;
    update();
    if (response.status == "success") {
      allShipments = (response.data as List)
          .map((sh) => ShipmentModel.fromJson(sh))
          .toList();
      update();
    }
  }

  Future<void> getShipment() async {
    fetchingShipments = true;
    update();

    APIResponse response =
        await shipmentService.getShipment({'id': selectedShipment!.id});
    // Handle response
    showToast(
      message: response.message,
      isError: response.status != "success",
    );
    fetchingShipments = false;
    update();
    if (response.status == "success") {
      selectedShipment = ShipmentModel.fromJson(response.data);
      update();
    }
  }

  ShipmentModel? selectedShipment;
  setSelectedShipment(ShipmentModel sh) {
    selectedShipment = sh;

    update();
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
        width: 7);

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
      infoWindow: InfoWindow(title: originAddress ?? "", snippet: "Origin"),
      position: originLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );
    Marker destinationMarker = Marker(
      markerId: const MarkerId('destinationID'),
      infoWindow:
          InfoWindow(title: destinationAddress ?? "", snippet: "Destination"),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    markerSet.add(originMarker);
    markerSet.add(destinationMarker);
    update();

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

  bool acceptingShipment = false;
  Future<void> acceptShipment(BuildContext context,
      {required String trackingId}) async {
    acceptingShipment = true;
    update();
    final dynamic data = {
      "tracking_id": trackingId,
      "action": "accept",
    };
    print(
        "********************************************************************************************************************");
    print(data.toString());
    print(
        "********************************************************************************************************************");

    // Call the API
    APIResponse response = await shipmentService.updateShipmentStatus(data);
    // Handle response

    if (response.status == "success") {
      selectedShipment = ShipmentModel.fromJson(response.data);
      acceptingShipment = false;
      update();
      fetchShipments();
      Get.find<LocationService>().startEmittingParcelLocation(
          trackingId: selectedShipment!.trackingId);
      drawPolyLineFromOriginToDestination(context,
          originLatitude: selectedShipment!.originLocation.latitude,
          originLongitude: selectedShipment!.originLocation.longitude,
          originAddress: selectedShipment!.originLocation.name,
          destinationLatitude: selectedShipment!.destinationLocation.latitude,
          destinationLongitude: selectedShipment!.destinationLocation.longitude,
          destinationAddress: selectedShipment!.destinationLocation.name);
      getShipment();
      // Get.back();
      showToast(
        message: response.message,
        isError: response.status != "success",
      );
      Get.toNamed(Routes.ORDER_TRACKING_SCREEN);
    } else {
      showToast(
        message: response.message,
        isError: response.status != "success",
      );
      acceptingShipment = false;
      update();
    }
  }
  resetDeliveriesSearchFields() {
    searchQueryController.clear();
    shipmentSearchResults.clear();
    update();
  }

  List<ShipmentModel> shipmentSearchResults = [];
  TextEditingController searchQueryController = TextEditingController();
  bool searchingShipments = false;
  searchShipments() async {
    if (deliveriesSearchFormKey.currentState!.validate()) {
      dynamic data = {'search': searchQueryController.text};
      searchingShipments = true;
      update();
      APIResponse response = await shipmentService.searchShipments(data);
      searchingShipments = false;
      update();
      if (response.status == "success") {
        shipmentSearchResults = (response.data as List)
            .map((sh) => ShipmentModel.fromJson(sh))
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

  bool updatingShipmentStatus = false;
  Future<void> updateShipmentStatus({required String status}) async {
    updatingShipmentStatus = true;
    update();
    final dynamic data = {
      "tracking_id": selectedShipment!.trackingId,
      "action": status.toLowerCase(),
    };
    print("***********************************************************************************************************");
    print(data.toString());
    print("************************************************************************************************************");
    // Call the API
    APIResponse response = await shipmentService.updateShipmentStatus(data);
    // Handle response
    showToast(
      message: response.message,
      isError: response.status != "success",
    );

    if (response.status == "success") {
      selectedShipment = ShipmentModel.fromJson(response.data);
      await getShipment();
      updatingShipmentStatus = false;
      update();
      fetchShipments();
    } else {
      updatingShipmentStatus = false;
      update();
    }
  }

  @override
  void onReady() {
    super.onReady();
    fetchShipments();
  }
}
