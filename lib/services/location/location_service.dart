import 'package:geolocator/geolocator.dart';

import '../../utils/exports.dart';

class LocationService extends GetxService {
  static LocationService get instance => Get.find();

  final position = Rx<Position?>(null);
  Stream<Position>? _positionStream;
  bool _initialLocationSent = false; // Track if initial location was sent

  Future<LocationService> init() async {
    await _checkPermissions();
    _startLocationTracking();
    return this;
  }

  Future<void> _checkPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }
  }

  void _startLocationTracking() {
    // First, get the initial position
    Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    ).then((Position initialPosition) {
      position.value = initialPosition;
      // Send initial location if socket service is available
      if (Get.isRegistered<SocketService>()) {
        Get.find<SocketService>().emitLocation(initialPosition);
        _initialLocationSent = true;
      }
    }).catchError((error) {
      print('Error getting initial position: $error');
    });

    // Then start the position stream for updates
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    );

    _positionStream?.listen(
      (Position newPosition) {
        position.value = newPosition;
        // Get socket service and emit location updates
        if (Get.isRegistered<SocketService>()) {
          if (!_initialLocationSent) {
            // If initial location wasn't sent (e.g., if socket wasn't ready), send it now
            Get.find<SocketService>().emitLocation(newPosition);
            _initialLocationSent = true;
          } else {
            // Otherwise send location update
            Get.find<SocketService>().emitLocationUpdate(newPosition);
          }
        }
      },
      onError: (error) {
        print('Location tracking error: $error');
      },
    );
  }

  void startEmittingParcelLocation({required String trackingId}) {
    // First, get the initial position
    Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    ).then((Position initialPosition) {
      position.value = initialPosition;
      // Send initial location if socket service is available
      if (Get.isRegistered<SocketService>()) {
        Get.find<SocketService>().emitParcelRiderLocationUpdate(initialPosition,
            trackingId: trackingId);
      }
    }).catchError((error) {
      print('Error getting initial position: $error');
    });

    // Then start the position stream for updates
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    );

    _positionStream?.listen(
      (Position newPosition) {
        position.value = newPosition;
        // Get socket service and emit location updates
        if (Get.isRegistered<SocketService>()) {
          // Otherwise send location update
          Get.find<SocketService>().emitParcelRiderLocationUpdate(newPosition,
              trackingId: trackingId);
        }
      },
      onError: (error) {
        print('Location tracking error: $error');
      },
    );
  }

  @override
  void onClose() {
    _positionStream = null;
    _initialLocationSent = false;
    super.onClose();
  }
}
