import 'package:gorider/core/utils/exports.dart';
import 'package:geolocator/geolocator.dart';

class DashboardController extends GetxController {
  GoogleMapController? mapController;
  Position? currentPosition;

  @override
  void onInit() {
    super.onInit();
    _initializeLocation();
  }

  void _initializeLocation() {
    if (Get.isRegistered<LocationService>()) {
      final locationService = Get.find<LocationService>();
      currentPosition = locationService.currentPosition;

      // Listen to location updates
      ever(locationService.currentPosition.obs, (Position? position) {
        if (position != null) {
          currentPosition = position;
          _updateMapCamera(position);
          update();
        }
      });

      // Update from position stream
      _listenToLocationUpdates();
    }
  }

  void _listenToLocationUpdates() {
    if (Get.isRegistered<LocationService>()) {
      // Location service already streams updates via _positionStream
      // We just need to get updates periodically
      Future.delayed(const Duration(seconds: 2), () {
        _checkAndUpdateLocation();
      });
    }
  }

  void _checkAndUpdateLocation() {
    if (Get.isRegistered<LocationService>()) {
      final locationService = Get.find<LocationService>();
      if (locationService.currentPosition != null) {
        final newPosition = locationService.currentPosition!;
        if (currentPosition == null ||
            currentPosition!.latitude != newPosition.latitude ||
            currentPosition!.longitude != newPosition.longitude) {
          currentPosition = newPosition;
          _updateMapCamera(newPosition);
          update();
        }
      }
      // Continue checking
      Future.delayed(const Duration(seconds: 3), () {
        _checkAndUpdateLocation();
      });
    }
  }

  void _updateMapCamera(Position position) {
    mapController?.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(position.latitude, position.longitude),
      ),
    );
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (currentPosition != null) {
      _updateMapCamera(currentPosition!);
    }
  }

  LatLng get initialPosition {
    if (currentPosition != null) {
      return LatLng(currentPosition!.latitude, currentPosition!.longitude);
    }
    // Fallback to Abuja if location not available yet
    return const LatLng(9.0765, 7.3986);
  }

  @override
  void onClose() {
    mapController?.dispose();
    super.onClose();
  }
}
