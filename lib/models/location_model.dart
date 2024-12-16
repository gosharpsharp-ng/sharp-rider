// class LatLng {
//   final double latitude;
//   final double longitude;
//
//   LatLng(this.latitude, this.longitude);
// }

class ItemLocation {
  final String? formattedAddress;
  final double latitude;
  final double longitude;

  ItemLocation(
      {this.formattedAddress, required this.latitude, required this.longitude});
}