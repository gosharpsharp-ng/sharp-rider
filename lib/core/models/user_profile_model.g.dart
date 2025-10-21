// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => UserProfile(
      id: (json['id'] as num).toInt(),
      avatar: json['avatar'] as String?,
      fname: json['fname'] as String,
      lname: json['lname'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      status: json['status'] as String,
      referralCode: json['referral_code'] as String?,
      referredBy: json['referred_by'] as String?,
      lastLoginAt: json['last_login_at'] as String?,
      failedLoginAttempts: (json['failed_login_attempts'] as num).toInt(),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      isEmailVerified: json['is_email_verified'] as bool,
      hasValidDriverLicense: json['has_valid_driver_license'] as bool,
      hasVerifiedVehicle: json['has_verified_vehicle'] as bool,
      isPhoneVerified: json['is_phone_verified'] as bool,
      vehicle: json['vehicle'] == null
          ? null
          : VehicleModel.fromJson(json['vehicle'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'avatar': instance.avatar,
      'fname': instance.fname,
      'lname': instance.lname,
      'phone': instance.phone,
      'email': instance.email,
      'role': instance.role,
      'status': instance.status,
      'referral_code': instance.referralCode,
      'referred_by': instance.referredBy,
      'last_login_at': instance.lastLoginAt,
      'failed_login_attempts': instance.failedLoginAttempts,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'is_email_verified': instance.isEmailVerified,
      'is_phone_verified': instance.isPhoneVerified,
      'has_valid_driver_license': instance.hasValidDriverLicense,
      'has_verified_vehicle': instance.hasVerifiedVehicle,
      'vehicle': instance.vehicle,
    };
