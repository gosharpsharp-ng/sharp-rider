import 'package:geolocator/geolocator.dart';
import 'package:gorider/core/utils/exports.dart';

class LocationPermissionScreen extends StatefulWidget {
  const LocationPermissionScreen({super.key});

  @override
  State<LocationPermissionScreen> createState() =>
      _LocationPermissionScreenState();
}

class _LocationPermissionScreenState extends State<LocationPermissionScreen> {
  bool isCheckingPermission = false;
  bool isLocationServiceEnabled = false;
  LocationPermission? currentPermission;

  @override
  void initState() {
    super.initState();
    _checkLocationStatus();
  }

  Future<void> _checkLocationStatus() async {
    setState(() {
      isCheckingPermission = true;
    });

    try {
      // Check if location service is enabled
      isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();

      // Check current permission status
      currentPermission = await Geolocator.checkPermission();

      // If everything is granted, navigate to dashboard
      if (isLocationServiceEnabled &&
          (currentPermission == LocationPermission.always ||
              currentPermission == LocationPermission.whileInUse)) {
        _navigateToDashboard();
      }
    } catch (e) {
      debugPrint("Error checking location status: $e");
    } finally {
      setState(() {
        isCheckingPermission = false;
      });
    }
  }

  Future<void> _requestLocationPermission() async {
    setState(() {
      isCheckingPermission = true;
    });

    try {
      // First check if location service is enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          isCheckingPermission = false;
        });
        _showLocationServiceDialog();
        return;
      }

      // Request permission
      LocationPermission permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        showToast(
          message: "Location permission is required to use this app",
          isError: true,
        );
        setState(() {
          currentPermission = permission;
          isCheckingPermission = false;
        });
      } else if (permission == LocationPermission.deniedForever) {
        setState(() {
          currentPermission = permission;
          isCheckingPermission = false;
        });
        _showOpenSettingsDialog();
      } else {
        // Permission granted
        _navigateToDashboard();
      }
    } catch (e) {
      showToast(
        message: "Error requesting location permission: ${e.toString()}",
        isError: true,
      );
      setState(() {
        isCheckingPermission = false;
      });
    }
  }

  void _showLocationServiceDialog() {
    Get.dialog(
      PopScope(
        canPop: false,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Container(
            padding: EdgeInsets.all(24.sp),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                Container(
                  width: 80.sp,
                  height: 80.sp,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFC107),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.location_off,
                      size: 50.sp,
                      color: AppColors.blackColor,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                // Title
                customText(
                  'Location Service Disabled',
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blackColor,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12.h),

                // Description
                customText(
                  'This app requires location services to be enabled. Please enable location services in your device settings.',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.obscureTextColor,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.visible,
                ),
                SizedBox(height: 32.h),

                // Action buttons
                Row(
                  children: [
                    // Cancel button
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFE5E5),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Center(
                            child: customText(
                              'Cancel',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFD32F2F),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),

                    // Open Settings button
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          Get.back();
                          await Geolocator.openLocationSettings();
                          // Recheck after returning from settings
                          Future.delayed(const Duration(seconds: 1), () {
                            _checkLocationStatus();
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2E7D32),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Center(
                            child: customText(
                              'Open Settings',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.whiteColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void _showOpenSettingsDialog() {
    Get.dialog(
      PopScope(
        canPop: false,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Container(
            padding: EdgeInsets.all(24.sp),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                Container(
                  width: 80.sp,
                  height: 80.sp,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFC107),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.location_disabled,
                      size: 50.sp,
                      color: AppColors.blackColor,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                // Title
                customText(
                  'Permission Denied',
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blackColor,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12.h),

                // Description
                customText(
                  'Location permission is permanently denied. Please enable it from app settings to continue.',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.obscureTextColor,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.visible,
                ),
                SizedBox(height: 32.h),

                // Action buttons
                Row(
                  children: [
                    // Exit button
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFE5E5),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Center(
                            child: customText(
                              'Exit',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFD32F2F),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),

                    // Open Settings button
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          Get.back();
                          await Geolocator.openAppSettings();
                          // Recheck after returning from settings
                          Future.delayed(const Duration(seconds: 1), () {
                            _checkLocationStatus();
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2E7D32),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Center(
                            child: customText(
                              'Open Settings',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.whiteColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void _navigateToDashboard() {
    Get.offAllNamed(Routes.APP_NAVIGATION);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: flatEmptyAppBar(
          topColor: AppColors.whiteColor,
          navigationColor: AppColors.whiteColor),
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Container(
          width: 1.sw,
          height: 1.sh,
          padding: EdgeInsets.symmetric(horizontal: 24.sp, vertical: 40.sp),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Location Icon
              Container(
                width: 120.sp,
                height: 120.sp,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.location_on,
                    size: 80.sp,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              SizedBox(height: 40.h),

              // Title
              customText(
                'Location Access Required',
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.blackColor,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),

              // Description
              customText(
                'To provide you with the best delivery experience, we need access to your location. This helps us:',
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.obscureTextColor,
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
              ),
              SizedBox(height: 24.h),

              // Features list
              _buildFeatureItem(
                Icons.navigation,
                'Navigate to pickup and delivery locations',
              ),
              SizedBox(height: 16.h),
              _buildFeatureItem(
                Icons.track_changes,
                'Track your deliveries in real-time',
              ),
              SizedBox(height: 16.h),
              _buildFeatureItem(
                Icons.notifications_active,
                'Receive nearby delivery requests',
              ),
              SizedBox(height: 16.h),
              _buildFeatureItem(
                Icons.location_searching,
                'Share your location with customers',
              ),

              const Spacer(),

              // Enable Location Button
              CustomButton(
                onPressed: () => _requestLocationPermission(),
                isBusy: isCheckingPermission,
                title: "Enable Location Access",
                width: 1.sw,
                backgroundColor: AppColors.primaryColor,
                fontColor: AppColors.whiteColor,
              ),
              SizedBox(height: 16.h),

              // Info text
              customText(
                'Your location data is only used while using the app and is never shared without your permission.',
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.obscureTextColor,
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.sp),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            icon,
            size: 24.sp,
            color: AppColors.primaryColor,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: customText(
            text,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.blackColor,
            overflow: TextOverflow.visible,
          ),
        ),
      ],
    );
  }
}
