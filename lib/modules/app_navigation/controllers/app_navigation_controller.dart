import 'dart:developer';

import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io;
import 'package:gorider/core/utils/exports.dart';

class AppNavigationController extends GetxController {
  ValueNotifier<int> selectedIndex = ValueNotifier<int>(0);
  socket_io.Socket? socket;

  List<Widget> screens = [
    const DashboardScreen(),
    const DeliveriesHistoryScreen(),
    const SettingsHomeScreen(),
  ];

  int currentScreenIndex = 0;

  void changeTabIndex(int index) async {
    bool locationEnabled = await _handleLocationPermission();
    if (locationEnabled) {
      selectedIndex.value = index;
    }
  }

  void changeScreenIndex(int index) async {
    bool locationEnabled = await _handleLocationPermission();
    if (locationEnabled) {
      currentScreenIndex = index;
      update();

      // Fetch deliveries when switching to Deliveries tab (index 1)
      if (index == 1 && Get.isRegistered<DeliveriesController>()) {
        final controller = Get.find<DeliveriesController>();
        // Reset pagination and fetch fresh data
        controller.currentDeliveriesPage = 1;
        controller.allDeliveries.clear();
        controller.totalDeliveries = 0;
        controller.fetchDeliveries();
      }
    }
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showDialog(
        context: Get.context!,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Enable Location"),
            content: const Text(
                "This app requires location services to function properly."),
            actions: [
              TextButton(
                child: const Text("Settings"),
                onPressed: () async {
                  await Geolocator.openLocationSettings();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text("Cancel"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.deniedForever) {
        showToast(message: "Location permission is required for this feature.");
        return false;
      }
    }

    return true;
  }

  Future<void> requestLocationPermission() async {
    PermissionStatus status = await Permission.location.status;

    if (status.isDenied || status.isPermanentlyDenied) {
      status = await Permission.location.request();
      if (status.isGranted) {
        log("Location permission granted.");
      } else if (status.isPermanentlyDenied) {
        showToast(
          isError: true,
          message:
              'Location permission is permanently denied. Enable it from app settings.',
        );
      } else {
        showToast(
          isError: true,
          message: 'Location permission denied.',
        );
      }
    } else if (status.isGranted) {
      log("Location permission already granted.");
    }
  }

  @override
  void onInit() {
    // _handleLocationPermission(); // Insist on enabling location on app start
    super.onInit();
  }
}
