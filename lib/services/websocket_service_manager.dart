import 'dart:developer';
import 'package:go_logistics_driver/services/delivery/delivery_notification.dart';
import '../utils/exports.dart';

class ServiceManager extends GetxService {
  static ServiceManager get instance => Get.find();
  bool _isServicesInitialized = false;

  bool get isServicesInitialized => _isServicesInitialized;

  Future<void> initializeServices(UserProfile profile) async {
    if (_isServicesInitialized) {
      print('Services already initialized');
      return;
    }

    try {
      // Check and dispose existing services
      if (Get.isRegistered<SocketService>()) {
        await Get.delete<SocketService>();
      }
      if (Get.isRegistered<LocationService>()) {
        await Get.delete<LocationService>();
      }
      if (Get.isRegistered<DeliveryNotificationService>()) {
        await Get.delete<DeliveryNotificationService>();
      }

      // Initialize services
      await Get.putAsync(() => SocketService().init(profile));
      await Get.putAsync(() => LocationService().init());
      // Initialize notification service
      final notificationService = DeliveryNotificationService();
      await Get.put(notificationService);
      notificationService.initialize();

      _isServicesInitialized = true;
      log('Services initialized successfully');
    } catch (e) {
      log('Error initializing services: $e');
      _isServicesInitialized = false;
      rethrow;
    }
  }

  Future<void> disposeServices() async {
    if (Get.isRegistered<SocketService>()) {
      final socketService = Get.find<SocketService>();
      socketService.socket.disconnect();
      await Get.delete<SocketService>();
    }

    if (Get.isRegistered<LocationService>()) {
      await Get.delete<LocationService>();
    }

    if (Get.isRegistered<DeliveryNotificationService>()) {
      await Get.delete<DeliveryNotificationService>();
    }

    _isServicesInitialized = false;
    log('Services disposed successfully');
  }
}
