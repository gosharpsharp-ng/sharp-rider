import 'package:go_logistics_driver/utils/exports.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_profile_model.g.dart';

@JsonSerializable()
class UserProfile {
  final int id;
  final String? avatar;
  final String fname;
  final String lname;
  final String phone;
  final String email;
  final String role;
  final String status;
  @JsonKey(name: 'referral_code')
  final String? referralCode;
  @JsonKey(name: 'referred_by')
  final String? referredBy;
  @JsonKey(name: 'last_login_at')
  final String? lastLoginAt;
  @JsonKey(name: 'failed_login_attempts')
  final int failedLoginAttempts;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  @JsonKey(name: 'is_email_verified')
  final bool isEmailVerified;
  @JsonKey(name: 'is_phone_verified')
  final bool isPhoneVerified;
  @JsonKey(name: 'has_valid_driver_license')
  final bool hasValidDriverLicense;
  @JsonKey(name: 'has_verified_vehicle')
  final bool hasVerifiedVehicle;
  final VehicleModel? vehicle;

  UserProfile({
    required this.id,
    this.avatar,
    required this.fname,
    required this.lname,
    required this.phone,
    required this.email,
    required this.role,
    required this.status,
    this.referralCode,
    this.referredBy,
    this.lastLoginAt,
    required this.failedLoginAttempts,
    required this.createdAt,
    required this.updatedAt,
    required this.isEmailVerified,
    required this.hasValidDriverLicense,
    required this.hasVerifiedVehicle,
    required this.isPhoneVerified,
    required this.vehicle,
  });

  // Factory method to create an instance from JSON
  factory UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() => _$UserProfileToJson(this);
}
