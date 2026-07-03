import 'dart:developer';
import 'package:geolocator/geolocator.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:gorider/core/utils/exports.dart';

class SocketService extends GetxService {
  static SocketService get instance => Get.find();

  late IO.Socket socket;
  final isConnected = false.obs;
  late UserProfile _userProfile;

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
      ..onConnect((_) async {
        log('🟢 Socket Connected to https://socket.gosharpsharp.com');

        isConnected.value = true;
        // Join appropriate room based on delivery status
        await _joinAppropriateRoom();
        startListeningAndEmitting();
      })
      ..onDisconnect((_) {
        log('🔴 Socket Disconnected');
        isConnected.value = false;
      })
      ..onReconnect((_) async {
        log('🟡 Socket Reconnected');
        isConnected.value = true;
        // Rejoin appropriate room based on active delivery status
        await _joinAppropriateRoom();
        // Restart location emitting
        startListeningAndEmitting();
      })
      ..onError((error) => log('❌ Socket Error: $error'))
      ..onConnectError((error) => log('❌ Socket Connect Error: $error'));
  }

  /// Join appropriate room based on active delivery status
  /// - If rider has active delivery (accepted/picked), join tracking room
  /// - Otherwise, join delivery room to receive new delivery requests
  Future<void> _joinAppropriateRoom() async {
    if (!Get.isRegistered<DeliveriesController>()) {
      // No deliveries controller, join delivery room by default
      joinRiderRoom();
      return;
    }

    final deliveriesController = Get.find<DeliveriesController>();

    // Give time for active delivery restoration from API
    // This ensures we check server state before joining rooms
    if (deliveriesController.selectedDelivery == null) {
      log('⏳ Waiting for active delivery check...');
      await Future.delayed(const Duration(milliseconds: 1500));
    }

    final selectedDelivery = deliveriesController.selectedDelivery;

    // Check if rider has active delivery
    if (selectedDelivery != null) {
      final status = selectedDelivery.status?.toLowerCase();
      final trackingId = selectedDelivery.trackingId;

      if (status != null &&
          ['accepted', 'picked'].contains(status) &&
          trackingId != null) {
        // Has active delivery, join tracking room
        log('📦 Active delivery found (status: $status), joining tracking room');
        joinTrackingRoom(trackingId);
        return;
      }
    }

    // No active delivery, join delivery room only if rider is online
    if (deliveriesController.isOnline) {
      log('📭 No active delivery & rider is online, joining delivery room');
      joinRiderRoom();
    } else {
      log('📴 Rider is offline, not joining any room');
    }
  }

  /// Join rider delivery room
  /// Emits to: "delivery:join" with payload { "riderId": riderId, "courierTypeId": courierTypeId, "courierTypeName": courierTypeName }
  void joinRiderRoom() {
    if (isConnected.value) {
      final courierTypeId = _userProfile.vehicle?.courierTypeId ?? 1;
      final courierTypeName = _userProfile.vehicle?.courierType?.name ?? 'Express';
      // Replace spaces with hyphens in courier type name
      final normalizedCourierTypeName = courierTypeName.replaceAll(' ', '-');

      socket.emit('delivery:join', {
        'riderId': _userProfile.id,
        'courierTypeId': courierTypeId,
        'courierTypeName': normalizedCourierTypeName,
      });
      log('🚴 Rider joined delivery room - Rider ID: ${_userProfile.id}, Courier Type ID: $courierTypeId, Courier Type Name: $normalizedCourierTypeName');
    }
  }

  /// Leave delivery room when accepting a delivery
  /// Emits to: "leave-room" with payload { "roomName": "courier-type:bike" }
  void leaveDeliveryRoom() {
    if (isConnected.value) {
      final courierTypeName = _userProfile.vehicle?.courierType?.name ?? 'Express';
      final normalizedCourierTypeName = courierTypeName.replaceAll(' ', '-');
      final roomName = 'courier-type:$normalizedCourierTypeName';

      socket.emit('leave-room', {
        'roomName': roomName,
      });
      log('🚪 Rider left delivery room - Room: $roomName');
    }
  }

  /// Join tracking room for active delivery
  /// Emits to: "join_room" with trackingId
  void joinTrackingRoom(String trackingId) {
    if (isConnected.value) {
      socket.emit('join_room', trackingId);
      log('📍 Rider joined tracking room - Tracking ID: $trackingId');
    }
  }

  /// Leave tracking room after delivery completion
  /// Emits to: "leave-room" with payload { "roomName": trackingId }
  void leaveTrackingRoom(String trackingId) {
    if (isConnected.value) {
      socket.emit('leave-room', {
        'roomName': trackingId,
      });
      log('🚪 Rider left tracking room - Tracking ID: $trackingId');
    }
  }

  /// Listen for new delivery requests
  /// Event: "delivery:new"
  /// Data: Full delivery object with pickup/destination locations
  void listenForDeliveries(Function(dynamic) onNewDelivery) {
    socket.on('delivery:new', onNewDelivery);
  }

  /// Emit rider's current location to join/update in delivery room
  /// Emits to: "delivery:location-update" with payload { riderId, location: {latitude, longitude, timestamp} }
  /// This allows the rider to receive new delivery requests based on their location
  void emitRiderLocationUpdateByCurrierType(Position position) {
    if (isConnected.value) {
      dynamic data = {
        "riderId": _userProfile.id,
        "location": {
          "latitude": position.latitude,
          "longitude": position.longitude,
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
        trackingId: deliveryModel.trackingId ?? '',
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
        trackingId: deliveryModel.trackingId ?? '',
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
    socket.disconnect();
  }

  @override
  void onClose() {
    disconnectAndLeaveRooms();
    socket.dispose();
    super.onClose();
  }
}
