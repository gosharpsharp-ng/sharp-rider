import 'package:geolocator/geolocator.dart';
import 'package:gorider/core/utils/exports.dart';
import 'package:gorider/core/services/analytics_service.dart';
import 'package:gorider/core/services/push_notification_service.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _checkToken();
  }

  void _checkToken() async {
    // Get token from storage
    final box = GetStorage();
    String? token = box.read('token');

    if (token != null && token.isNotEmpty) {
      // Register device token for push notifications
      await PushNotificationService().registerTokenIfAvailable();

      // Load data and check location permission
      await _loadData();

      // Check if location permission is granted
      bool hasLocationPermission = await _checkLocationPermission();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (hasLocationPermission) {
          Get.offNamed(Routes.APP_NAVIGATION);
        } else {
          Get.offNamed(Routes.LOCATION_PERMISSION_SCREEN);
        }
      });
    } else {
      // Navigate to onboarding after the current frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offNamed(Routes.ONBOARDING);
      });
    }
  }

  Future<bool> _checkLocationPermission() async {
    try {
      // Check if location service is enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return false;
      }

      // Check permission status
      LocationPermission permission = await Geolocator.checkPermission();

      return permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse;
    } catch (e) {
      debugPrint("Error checking location permission: $e");
      return false;
    }
  }

  // Method to initiate calls from the WalletController and ProfileController
  Future<void> _loadData() async {
    Get.put(SettingsController());
    Get.put(DeliveriesController());

    // Set Analytics user ID for already logged-in users
    final settingsController = Get.find<SettingsController>();
    if (settingsController.reactiveUserProfile.value?.id != null) {
      await AnalyticsService().setUserId(
        settingsController.reactiveUserProfile.value!.id.toString(),
      );
      await AnalyticsService().setUserProperty('user_type', 'rider');
    }
  }
}
