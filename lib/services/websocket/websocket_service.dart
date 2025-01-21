import 'dart:developer';

import 'package:geolocator/geolocator.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../utils/exports.dart';

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
        'http://164.90.143.42:8082',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .enableReconnection()
            .setReconnectionAttempts(5)
            .setReconnectionDelay(3000)
            .build());
    socket.connect();
  }

  void _setupSocketListeners() {
    socket
      ..onConnect((_) {
        print('Socket Connected');
        isConnected.value = true;
      })
      ..onDisconnect((_) {
        print('Socket Disconnected');
        isConnected.value = false;
      })
      ..onReconnect((_) {
        log('Socket Reconnected');
        isConnected.value = true;
      })
      ..onError((error) => log('Socket Error: $error'))
      ..onConnectError((error) => log('Socket Connect Error: $error'));
  }

  void emitLocation(Position position) {
    if (isConnected.value) {
      dynamic data = {
        'location': {
          'lon': position.latitude,
          'lat': position.longitude,
        },
        'user_id': _userProfile.id,
        'name': "${_userProfile.fname} ${_userProfile.lname}"
      };
      log("Sending Location **********************************************************************************");
      log(data.toString());
      log("Sending Location **********************************************************************************");
      socket.emit('rider_connect', data);
    }
  }

  void emitLocationUpdate(Position position) {
    if (isConnected.value) {
      dynamic data = {
        'lon': position.latitude,
        'lat': position.longitude,
      };
      socket.emit('rider_connect', data);
    }
  }

  void emitParcelRiderLocationUpdate(LatLng position,
      {required String trackingId, required double locationDegrees}) {
    if (isConnected.value) {
      dynamic data = {
        'room': trackingId,
        'event': 'rider_tracking',
        'data': {
          'lon': position.latitude,
          'lat': position.longitude,
          'degrees': locationDegrees
        }
      };
      socket.emit('broadcast_to_room', data);
    }
  }

  void listenForParcelLocationUpdate(
      {required String roomId, required Function(dynamic) onLocationUpdate}) {
    socket.on(roomId, onLocationUpdate);
  }

  void joinTrackingRoom(
      {required String trackingId, required String msg}) async {
    if (isConnected.value) {
      socket.emit(msg, trackingId);
    }
  }

  void leaveTrackingRoom(
      {required String trackingId, required String msg}) async {
    if (isConnected.value) {
      socket.emit(msg, trackingId);
    }
  }

  void emitParcelStatusUpdate(
      {required String status, required String trackingId}) {
    if (isConnected.value) {
      dynamic data = {
        'status': status,
      };
      socket.emit(trackingId, data);
    }
  }

  void listenForShipments(Function(dynamic) onNewShipment) {
    socket.on('shipment_events', onNewShipment);
  }

  void listenToOrders(Function(dynamic) onNewOrder) {
    socket.on('update_location', onNewOrder);
  }

  void acceptOrder(String orderId) {
    socket.emit('shipment', {'orderId': orderId});
  }

  void rejectOrder(String orderId) {
    socket.emit('rejectOrder', {'orderId': orderId});
  }

  void updateLocationDuringParcelDelivery(
      String trackingId, Position position) {
    socket.emit(trackingId, {
      'lon': position.latitude,
      'lat': position.longitude,
    });
  }

  @override
  void onClose() {
    socket.dispose();
    super.onClose();
  }
}
