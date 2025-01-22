import 'package:geolocator/geolocator.dart';
import 'dart:math' as math;
import '../../utils/exports.dart';

class LocationService extends GetxService {
  static LocationService get instance => Get.find();
  Position? currentPosition;
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
      Geolocator.requestPermission();
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }
  }

  joinParcelTrackingRoom({required String trackingId}) async {
    if (Get.isRegistered<SocketService>()) {
      Get.find<SocketService>()
          .joinTrackingRoom(trackingId: trackingId, msg: 'join_room');
    }
  }

   leaveParcelTrackingRoom({required String trackingId}) async {
    if (Get.isRegistered<SocketService>()) {
      Get.find<SocketService>()
          .joinTrackingRoom(trackingId: trackingId, msg: 'leave_room');
    }
  }

  void _startLocationTracking() {
    // First, get the initial position
    Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    ).then((Position initialPosition) {
      currentPosition = initialPosition;
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
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 10,
      ),
    );

    _positionStream?.listen(
      (Position newPosition) {
        currentPosition = newPosition;
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
    // start the position stream for updates
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 15,
      ),
    );
    if (Get.isRegistered<SocketService>()) {
      // Otherwise send location update
      _positionStream?.listen(
        (Position newPosition) {
          currentPosition = newPosition;
          // Get socket service and emit location updates
          if (Get.isRegistered<SocketService>()) {
            // Otherwise send location update
            Get.find<SocketService>().emitParcelRiderLocationUpdate(
                LatLng(newPosition.latitude, newPosition.longitude),
                locationDegrees: calculateLocationDegrees(
                    LatLng(currentPosition?.latitude ?? 0.0,
                        currentPosition?.longitude ?? 0.0),
                    LatLng(newPosition.latitude, newPosition.longitude)),
                trackingId: trackingId);
          }
        },
        onError: (error) {
          print('Location tracking error: $error');
        },
      );
    }
  }

  void listenForParcelLocationUpdate({required String roomId}) {
    if (Get.isRegistered<SocketService>()) {
      Get.find<SocketService>().listenForParcelLocationUpdate(
          roomId: roomId, onLocationUpdate: (data) {});
    }
  }

  @override
  void onClose() {
    _positionStream = null;
    _initialLocationSent = false;
    super.onClose();
  }
}
