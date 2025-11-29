import 'package:gorider/core/models/license_model.dart';
import 'package:gorider/core/models/user_profile_model.dart';
import 'package:gorider/core/models/vehicle_model.dart';

/// Response model for the /riders/profile endpoint
/// Contains the user profile along with deliveries, commissions, ratings, license, and vehicle
class RiderProfileResponse {
  final UserProfile user;
  final List<dynamic> deliveries;
  final List<dynamic> commissions;
  final List<dynamic> ratings;
  final LicenseModel? driverLicense;
  final VehicleModel? vehicle;

  RiderProfileResponse({
    required this.user,
    this.deliveries = const [],
    this.commissions = const [],
    this.ratings = const [],
    this.driverLicense,
    this.vehicle,
  });

  factory RiderProfileResponse.fromJson(Map<String, dynamic> json) {
    return RiderProfileResponse(
      user: UserProfile.fromJson(json['user'] as Map<String, dynamic>),
      deliveries: json['deliveries'] as List<dynamic>? ?? [],
      commissions: json['commissions'] as List<dynamic>? ?? [],
      ratings: json['ratings'] as List<dynamic>? ?? [],
      driverLicense: json['driver_license'] != null
          ? LicenseModel.fromJson(json['driver_license'] as Map<String, dynamic>)
          : null,
      vehicle: json['vehicle'] != null
          ? VehicleModel.fromJson(json['vehicle'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'deliveries': deliveries,
      'commissions': commissions,
      'ratings': ratings,
      'driver_license': driverLicense?.toJson(),
      'vehicle': vehicle?.toJson(),
    };
  }
}
