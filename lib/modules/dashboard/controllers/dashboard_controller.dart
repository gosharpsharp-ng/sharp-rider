import 'package:gorider/core/utils/exports.dart';
import 'package:geolocator/geolocator.dart';

class DashboardController extends GetxController {
  GoogleMapController? mapController;
  Position? currentPosition;
  bool isLightMapStyle = true;

  // Marker and circle for rider's current position
  Set<Marker> markers = {};
  Set<Circle> circles = {};

  // Stream subscription for location updates
  StreamSubscription<Position>? _locationSubscription;

  // Flag to track if map is visible/mounted
  bool isMapVisible = false;

  // Light map style (standard Google Maps)
  static const String _lightMapStyle = '[]';

  // Dark map style
  static const String _darkMapStyle = '''
[
  {"elementType": "geometry", "stylers": [{"color": "#242f3e"}]},
  {"elementType": "labels.text.stroke", "stylers": [{"color": "#242f3e"}]},
  {"elementType": "labels.text.fill", "stylers": [{"color": "#746855"}]},
  {"featureType": "administrative.locality", "elementType": "labels.text.fill", "stylers": [{"color": "#d59563"}]},
  {"featureType": "poi", "elementType": "labels.text.fill", "stylers": [{"color": "#d59563"}]},
  {"featureType": "poi.park", "elementType": "geometry", "stylers": [{"color": "#263c3f"}]},
  {"featureType": "poi.park", "elementType": "labels.text.fill", "stylers": [{"color": "#6b9a76"}]},
  {"featureType": "road", "elementType": "geometry", "stylers": [{"color": "#38414e"}]},
  {"featureType": "road", "elementType": "geometry.stroke", "stylers": [{"color": "#212a37"}]},
  {"featureType": "road", "elementType": "labels.text.fill", "stylers": [{"color": "#9ca5b3"}]},
  {"featureType": "road.highway", "elementType": "geometry", "stylers": [{"color": "#746855"}]},
  {"featureType": "road.highway", "elementType": "geometry.stroke", "stylers": [{"color": "#1f2835"}]},
  {"featureType": "road.highway", "elementType": "labels.text.fill", "stylers": [{"color": "#f3d19c"}]},
  {"featureType": "transit", "elementType": "geometry", "stylers": [{"color": "#2f3948"}]},
  {"featureType": "transit.station", "elementType": "labels.text.fill", "stylers": [{"color": "#d59563"}]},
  {"featureType": "water", "elementType": "geometry", "stylers": [{"color": "#17263c"}]},
  {"featureType": "water", "elementType": "labels.text.fill", "stylers": [{"color": "#515c6d"}]},
  {"featureType": "water", "elementType": "labels.text.stroke", "stylers": [{"color": "#17263c"}]}
]
''';

  @override
  void onInit() {
    super.onInit();
    _initializeLocation();
  }

  void _initializeLocation() async {
    // Get initial position from LocationService if available
    if (Get.isRegistered<LocationService>()) {
      final locationService = Get.find<LocationService>();
      if (locationService.currentPosition != null) {
        currentPosition = locationService.currentPosition;
        _updateRiderMarker(currentPosition!);
        update();
      }
    }

    // Get current position directly
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      currentPosition = position;
      _updateRiderMarker(position);
      update();
    } catch (e) {
      // Fallback handled by initialPosition getter
    }

    // Subscribe to position stream for real-time updates
    _locationSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5, // Update every 5 meters
      ),
    ).listen(
      (Position position) {
        currentPosition = position;
        _updateMapCamera(position);
        update();
      },
      onError: (error) {
        // Handle error silently
      },
    );
  }

  void _updateMapCamera(Position position) {
    // Only animate camera if map is visible and controller is available
    if (isMapVisible && mapController != null) {
      mapController!.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(position.latitude, position.longitude),
        ),
      ).catchError((e) {
        // Silently handle error when map is not available
        debugPrint("Error animating camera: $e");
      });
    }
    _updateRiderMarker(position);
  }

  /// Call this when the map becomes visible (e.g., on dashboard screen)
  void setMapVisible(bool visible) {
    isMapVisible = visible;
  }

  void _updateRiderMarker(Position position) {
    final riderPosition = LatLng(position.latitude, position.longitude);

    // Create the rider marker with green color
    final riderMarker = Marker(
      markerId: const MarkerId('rider_location'),
      position: riderPosition,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow: const InfoWindow(title: 'You are here'),
      anchor: const Offset(0.5, 0.5),
    );

    // Create glowing effect with circles
    // Green color: 0xFF4CAF50
    const greenColor = Color(0xFF4CAF50);

    final innerGlow = Circle(
      circleId: const CircleId('rider_glow_inner'),
      center: riderPosition,
      radius: 30, // 30 meters
      fillColor: greenColor.withAlpha(77), // 0.3 * 255 ≈ 77
      strokeColor: greenColor.withAlpha(153), // 0.6 * 255 ≈ 153
      strokeWidth: 2,
    );

    final outerGlow = Circle(
      circleId: const CircleId('rider_glow_outer'),
      center: riderPosition,
      radius: 60, // 60 meters
      fillColor: greenColor.withAlpha(26), // 0.1 * 255 ≈ 26
      strokeColor: greenColor.withAlpha(77), // 0.3 * 255 ≈ 77
      strokeWidth: 1,
    );

    markers = {riderMarker};
    circles = {innerGlow, outerGlow};
    update();
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    isMapVisible = true;
    if (currentPosition != null) {
      _updateMapCamera(currentPosition!);
      _updateRiderMarker(currentPosition!);
    }
  }

  /// Call this when leaving the dashboard screen to prevent camera animation errors
  void onMapDisposed() {
    isMapVisible = false;
  }

  String get currentMapStyle =>
      isLightMapStyle ? _lightMapStyle : _darkMapStyle;

  void toggleMapStyle() {
    isLightMapStyle = !isLightMapStyle;
    update();
  }

  LatLng get initialPosition {
    if (currentPosition != null) {
      return LatLng(currentPosition!.latitude, currentPosition!.longitude);
    }
    // Fallback to Abuja if location not available yet
    return const LatLng(9.0765, 7.3986);
  }

  @override
  void onClose() {
    isMapVisible = false;
    _locationSubscription?.cancel();
    mapController?.dispose();
    super.onClose();
  }
}
