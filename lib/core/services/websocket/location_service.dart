import 'dart:developer';
import 'package:geolocator/geolocator.dart';
import 'package:gorider/core/utils/exports.dart';

class LocationService extends GetxService {
  static LocationService get instance => Get.find();
  Position? currentPosition;
  Stream<Position>? _positionStream;
  bool _initialLocationSent = false; // Track if initial location was sent

  Future<LocationService> init() async {
    await _checkPermissions();
    _startLocationTracking();
    _initialLocationSent = false;
    return this;
  }

  bool _isRequestingPermission = false;

  Future<void> _checkPermissions() async {
    if (_isRequestingPermission) return;
    _isRequestingPermission = true;

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.requestPermission();
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
    } finally {
      _isRequestingPermission = false;
    }
  }

  joinParcelTrackingRoom({required String trackingId}) async {
    if (Get.isRegistered<SocketService>()) {
      Get.find<SocketService>().joinRoom(roomId: trackingId);
    }
  }

  joinRiderLocationUpdateRoom({required String courierType}) async {
    // Join room based on your courier type: express or e-bike
    if (Get.isRegistered<SocketService>()) {
      Get.find<SocketService>().joinRiderRoom();
    }
  }

  leaveParcelTrackingRoom({required String trackingId}) async {
    if (Get.isRegistered<SocketService>()) {
      Get.find<SocketService>().leaveRoom(roomId: trackingId);
    }
  }

  void _startLocationTracking() async {
    await joinRiderLocationUpdateRoom(
        courierType: Get.find<DeliveriesController>()
                .settingsController
                .userProfile
                ?.vehicle
                ?.courierType
                ?.name ??
            "");
    // First, get the initial position
    Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    ).then((Position initialPosition) {
      currentPosition = initialPosition;
      // Send initial location if socket service is available
      if (Get.isRegistered<SocketService>() &&
          Get.find<SocketService>().isConnected.value == true) {
        Get.find<SocketService>()
            .emitRiderLocationUpdateByCurrierType(initialPosition);
        _initialLocationSent = true;
        Get.find<SocketService>().listenForDeliveries((data) {
          Get.find<DeliveryNotificationService>()
              .handleDeliveryNotification(data);
        });
      }
    }).catchError((error) {
      log('Error getting initial position: $error');
    });

    // Then start the position stream for updates
    // Emit location every 5 meters
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 5,
      ),
    );

    _positionStream?.listen(
      (Position newPosition) {
        currentPosition = newPosition;
        if (Get.isRegistered<SocketService>()) {
          if (!_initialLocationSent) {
            // If initial location wasn't sent (e.g., if socket wasn't ready), send it now
            joinRiderLocationUpdateRoom(courierType: "express");
            Get.find<SocketService>()
                .emitRiderLocationUpdateByCurrierType(newPosition);
            _initialLocationSent = true;
            Get.find<SocketService>().listenForDeliveries((data) {
              Get.find<DeliveryNotificationService>()
                  .handleDeliveryNotification(data);
            });
          } else {
            // Otherwise send location update
            Get.find<SocketService>()
                .emitRiderLocationUpdateByCurrierType(newPosition);
          }
        }
      },
      onError: (error) {
        log('Location tracking error: $error');
      },
    );
  }

  void notifyUserOfDeliveryStatusWithLocationLocation(
      {required DeliveryModel deliveryModel}) {
    // Notify the user of the status of his order/delivery
    Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    ).then((Position initialPosition) {
      currentPosition = initialPosition;
      // Send initial location if socket service is available
      if (Get.isRegistered<SocketService>()) {
        Get.find<SocketService>().emitParcelRiderLocationUpdateOnce(
            LatLng(currentPosition?.latitude ?? 0.0,
                currentPosition?.longitude ?? 0.0),
            locationDegrees: calculateLocationDegrees(
                LatLng(currentPosition?.latitude ?? 0.0,
                    currentPosition?.longitude ?? 0.0),
                LatLng(currentPosition?.latitude ?? 0.0,
                    currentPosition?.longitude ?? 0.0)),
            deliveryModel: deliveryModel);
      }
    }).catchError((error) {
      log('Error getting initial position: $error');
    });
  }

  void startEmittingParcelLocation({required DeliveryModel deliveryModel}) {
    // start the position stream for updates when a parcel is picked
    // Emit location every 5 meters
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 5,
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
                deliveryModel: deliveryModel);
          }
        },
        onError: (error) {
          log('Location tracking error: $error');
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
