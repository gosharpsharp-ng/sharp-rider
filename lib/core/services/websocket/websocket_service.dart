import 'dart:developer';
import 'package:geolocator/geolocator.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:gorider/core/utils/exports.dart';

class SocketService extends GetxService {
  static SocketService get instance => Get.find();

  late IO.Socket socket;
  final isConnected = false.obs;
  late UserProfile _userProfile;
  final Set<String> _joinedRooms = {}; // Track joined rooms
  bool _hasJoinedRiderRoom = false;

  Future<SocketService> init(UserProfile profile) async {
    _userProfile = profile;
    _initializeSocket();
    _setupSocketListeners();
    return this;
  }

  void _initializeSocket() {
    socket = IO.io(
        'https://socket.gosharpsharp.com',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .enableReconnection()
            .setReconnectionAttempts(1000)
            .setReconnectionDelay(3000)
            .build());
    socket.connect();
  }

  void _setupSocketListeners() {
    socket
      ..onConnect((_) {
        log('🟢 Socket Connected to https://socket.gosharpsharp.com');

        isConnected.value = true;
        // Join rider room and start emitting location
        if (isConnected.value == true) {
          if (!_hasJoinedRiderRoom) joinRiderRoom();
          startListeningAndEmitting();
        }
      })
      ..onDisconnect((_) {
        log('🔴 Socket Disconnected');
        isConnected.value = false;
      })
      ..onReconnect((_) {
        log('🟡 Socket Reconnected');
        isConnected.value = true;
        // Rejoin rider room on reconnection
        if (!_hasJoinedRiderRoom) joinRiderRoom();
      })
      ..onError((error) => log('❌ Socket Error: $error'))
      ..onConnectError((error) => log('❌ Socket Connect Error: $error'));
  }

  /// Join rider delivery room
  /// Emits to: "delivery:join" with payload { "driverId": riderId, "courierTypeId": courierTypeId }
  void joinRiderRoom() {
    if (isConnected.value) {
      final courierTypeId = _userProfile.vehicle?.courierType?.id ?? 1;
      socket.emit('delivery:join', {
        'driverId': _userProfile.id,
        'courierTypeId': courierTypeId,
      });
      _hasJoinedRiderRoom = true;
      log('🚴 Rider joined delivery room - Driver ID: ${_userProfile.id}, Courier Type ID: $courierTypeId');
    }
  }

  /// Listen for new delivery requests
  /// Event: "delivery:new"
  /// Data: Full delivery object with pickup/destination locations
  void listenForDeliveries(Function(dynamic) onNewDelivery) {
    socket.on('delivery:new', onNewDelivery);
  }

  /// Emit rider's current location to join/update in delivery room
  /// Emits to: "delivery:location-update" with payload { driverId, location: {latitude, longitude, degrees, timestamp} }
  /// This allows the rider to receive new delivery requests based on their location
  void emitRiderLocationUpdateByCurrierType(Position position) {
    if (isConnected.value) {
      dynamic data = {
        "driverId": _userProfile.id,
        "location": {
          "latitude": position.latitude,
          "longitude": position.longitude,
          "degrees": position.heading,
          "timestamp": DateTime.now().toUtc().toIso8601String(),
        }
      };
      socket.emit('delivery:location-update', data);
    }
  }

  void emitParcelRiderLocationUpdateOnce(LatLng position,
      {required DeliveryModel deliveryModel, required double locationDegrees}) {
    if (isConnected.value) {
      // Only emit to delivery tracking location update event
      emitDeliveryTrackingLocationUpdate(
        trackingId: deliveryModel.trackingId,
        latitude: position.latitude,
        longitude: position.longitude,
        degrees: locationDegrees,
      );
    }
  }

  void emitParcelRiderLocationUpdate(LatLng position,
      {required DeliveryModel deliveryModel, required double locationDegrees}) {
    if (isConnected.value) {
      // Only emit to delivery tracking location update event
      emitDeliveryTrackingLocationUpdate(
        trackingId: deliveryModel.trackingId,
        latitude: position.latitude,
        longitude: position.longitude,
        degrees: locationDegrees,
      );
    }
  }

  /// Emit rider's location during active delivery for customer tracking
  /// Emits to: "delivery:tracking-location-update" with payload { trackingId, location: {latitude, longitude, degrees} }
  /// This is used by customers to track the rider's real-time location during delivery
  void emitDeliveryTrackingLocationUpdate({
    required String trackingId,
    required double latitude,
    required double longitude,
    required double degrees,
  }) {
    if (isConnected.value) {
      dynamic data = {
        "trackingId": trackingId,
        "location": {
          "latitude": latitude,
          "longitude": longitude,
          "degrees": degrees,
        }
      };
      socket.emit('delivery:tracking-location-update', data);
      log('📍 Emitted tracking location for: $trackingId');
    }
  }

  // ==================== LEGACY METHODS (kept for backward compatibility) ====================

  // DEPRECATED: No longer used with new WebSocket structure
  @Deprecated('No longer used - rider joins via delivery:join event')
  riderConnect(Map<String, dynamic> data) async {
    if (isConnected.value) {
      socket.emit("rider_connect", data);
    }
  }

  // DEPRECATED: Status management moved to API
  @Deprecated('Status updates should use API instead')
  updateRiderAvailabilityStatus(String status) async {
    if (isConnected.value) {
      socket.emit("update_status", status);
    }
  }

  startListeningAndEmitting() async {
    if (Get.isRegistered<LocationService>()) {
      Get.find<LocationService>().init();
    } else {
      await Get.putAsync(() => LocationService().init());
      Get.find<LocationService>().init();
    }
  }

  @Deprecated('Use specific delivery tracking methods instead')
  void listenForParcelLocationUpdate(
      {required String roomId, required Function(dynamic) onLocationUpdate}) {
    socket.on(roomId, onLocationUpdate);
  }

  @Deprecated('Use delivery:join event instead')
  void joinRoom({required String roomId}) {
    if (isConnected.value) {
      socket.emit('join_room', roomId);
    }
  }

  @Deprecated('Use specific leave methods instead')
  void leaveRoom({required String roomId}) {
    if (isConnected.value) {
      socket.emit('leave_room', roomId);
    }
  }

  // ==================== CLEANUP ====================

  void disconnectAndLeaveRooms() {
    _hasJoinedRiderRoom = false;
    socket.disconnect();
  }

  @override
  void onClose() {
    disconnectAndLeaveRooms();
    socket.dispose();
    super.onClose();
  }
}
