import 'dart:developer';
import 'package:geolocator/geolocator.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../utils/exports.dart';

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
        'http://164.90.143.42:8082',
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
        log('Socket Connected');

        isConnected.value = true;
        // Ensure rider rejoin
        if (isConnected.value == true) {
          _rejoinRooms();
          if (!_hasJoinedRiderRoom) joinRiderRoom();
          startListeningAndEmitting();
          riderConnect({
            "riderId": "${_userProfile.id}",
            "name": "${_userProfile.fname} ${_userProfile.lname}",
            "courierType": _userProfile.vehicle?.courierType ?? "",
            "status": "available"
          });
        }
      })
      ..onDisconnect((_) {
        log('Socket Disconnected');
        isConnected.value = false;
      })
      ..onReconnect((_) {
        log('Socket Reconnected');
        isConnected.value = true;
        _rejoinRooms();
        if (!_hasJoinedRiderRoom) joinRiderRoom();
        riderConnect({
          "riderId": "${_userProfile.id}",
          "name": "${_userProfile.fname} ${_userProfile.lname}",
          "courierType":
              _userProfile.vehicle?.courierType ?? {"courierType": ""},
          "status": "available"
        });
      })
      ..onError((error) => log('Socket Error: $error'))
      ..onConnectError((error) => log('Socket Connect Error: $error'));
  }

  void joinRiderRoom() {
    if (isConnected.value) {
      joinRoom(roomId: _userProfile.vehicle?.courierType.name ?? "");
      _hasJoinedRiderRoom = true;
      riderConnect({
        "riderId": "${_userProfile.id}",
        "name": "${_userProfile.fname} ${_userProfile.lname}",
        "courierType": _userProfile.vehicle?.courierType ?? "",
        "status": "available"
      });
    }
  }

  listenForDeliveries(Function(dynamic) onNewDelivery) {
    socket.on('shipment_events', onNewDelivery);
  }

  void emitRiderLocationUpdateByCurrierType(Position position) {
    if (isConnected.value) {
      dynamic data = {
        'room': _userProfile.vehicle?.courierType.name ?? "",
        'event': 'rider_location',
        'data': {
          'location': {
            'lon': position.latitude,
            'lat': position.longitude,
          },
          'user_id': _userProfile.id,
          'name': "${_userProfile.fname} ${_userProfile.lname}"
        }
      };
      socket.emit('broadcast_to_room', data);
    }
  }

  void emitParcelRiderLocationUpdateOnce(LatLng position,
      {required DeliveryModel deliveryModel, required double locationDegrees}) {
    if (isConnected.value) {
      dynamic data = {
        'room': deliveryModel.trackingId,
        'event': 'rider_tracking',
        'data': {
          'lon': position.longitude,
          'lat': position.latitude,
          'status': deliveryModel.status,
          'degrees': locationDegrees
        }
      };
      socket.emit('broadcast_to_room', data);
    }
  }

  void emitParcelRiderLocationUpdate(LatLng position,
      {required DeliveryModel deliveryModel, required double locationDegrees}) {
    if (isConnected.value) {
      dynamic data = {
        'room': deliveryModel.trackingId,
        'event': 'rider_tracking',
        'data': {
          'lon': position.longitude,
          'lat': position.latitude,
          'status': deliveryModel.status,
          'degrees': locationDegrees,
          'user_id': _userProfile.id,
          'name': "${_userProfile.fname} ${_userProfile.lname}",
        }
      };
      socket.emit('broadcast_to_room', data);
    }
  }

  // Connect Rider to the riding list so clients can see
  riderConnect(
    Map<String, dynamic> data,
  ) async {
    if (isConnected.value) {
      socket.emit("rider_connect", data);
    }
  }

  // Update Rider's Availability Status
  updateRiderAvailabilityStatus(
    String status,
  ) async {
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

  void listenForParcelLocationUpdate(
      {required String roomId, required Function(dynamic) onLocationUpdate}) {
    socket.on(roomId, onLocationUpdate);
  }

  void joinRoom({required String roomId}) {
    if (isConnected.value) {
      socket.emit('join_room', roomId);
      _joinedRooms.add(roomId);
    }
  }

  void leaveRoom({required String roomId}) {
    if (isConnected.value) {
      socket.emit('leave_room', roomId);
      _joinedRooms.remove(roomId);
    }
  }

  void _rejoinRooms() {
    for (var room in _joinedRooms) {
      socket.emit('join_room', room);
    }
  }

  void disconnectAndLeaveRooms() {
    for (var room in _joinedRooms) {
      socket.emit('leave_room', room);
    }
    _joinedRooms.clear();
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
