import 'package:gorider/core/models/vehicle_model.dart';
import 'package:gorider/core/models/wallet_model.dart';

class UserProfile {
  final int id;
  final String? avatar;
  final String fname;
  final String lname;
  final String phone;
  final String? dob;
  final String email;
  final String status;
  final String? referralCode;
  final String? referredBy;
  final String? lastLoginAt;
  final int? failedLoginAttempts;
  final String? deletedAt;
  final String? createdAt;
  final String? updatedAt;
  final List<UserRole>? roles;
  final List<dynamic>? permissions;
  final VehicleModel? vehicle;
  final Wallet? wallet;

  UserProfile({
    required this.id,
    this.avatar,
    required this.fname,
    required this.lname,
    required this.phone,
    this.dob,
    required this.email,
    required this.status,
    this.referralCode,
    this.referredBy,
    this.lastLoginAt,
    this.failedLoginAttempts,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.roles,
    this.permissions,
    this.vehicle,
    this.wallet,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as int,
      avatar: json['avatar'] as String?,
      fname: json['fname'] as String,
      lname: json['lname'] as String,
      phone: json['phone'] as String,
      dob: json['dob'] as String?,
      email: json['email'] as String,
      status: json['status'] as String,
      referralCode: json['referral_code'] as String?,
      referredBy: json['referred_by'] as String?,
      lastLoginAt: json['last_login_at'] as String?,
      failedLoginAttempts: json['failed_login_attempts'] as int?,
      deletedAt: json['deleted_at'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      roles: json['roles'] != null
          ? (json['roles'] as List)
              .map((e) => UserRole.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      permissions: json['permissions'] as List<dynamic>?,
      vehicle: json['vehicle'] != null
          ? VehicleModel.fromJson(json['vehicle'] as Map<String, dynamic>)
          : null,
      wallet: json['wallet'] != null
          ? Wallet.fromJson(json['wallet'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'avatar': avatar,
      'fname': fname,
      'lname': lname,
      'phone': phone,
      'dob': dob,
      'email': email,
      'status': status,
      'referral_code': referralCode,
      'referred_by': referredBy,
      'last_login_at': lastLoginAt,
      'failed_login_attempts': failedLoginAttempts,
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'roles': roles?.map((e) => e.toJson()).toList(),
      'permissions': permissions,
      'vehicle': vehicle?.toJson(),
      'wallet': wallet?.toJson(),
    };
  }
}

class UserRole {
  final int id;
  final String name;
  final String guardName;
  final String? deletedAt;
  final String? createdAt;
  final String? updatedAt;
  final RolePivot? pivot;

  UserRole({
    required this.id,
    required this.name,
    required this.guardName,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.pivot,
  });

  factory UserRole.fromJson(Map<String, dynamic> json) {
    return UserRole(
      id: json['id'] as int,
      name: json['name'] as String,
      guardName: json['guard_name'] as String,
      deletedAt: json['deleted_at'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      pivot: json['pivot'] != null
          ? RolePivot.fromJson(json['pivot'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'guard_name': guardName,
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'pivot': pivot?.toJson(),
    };
  }
}

class RolePivot {
  final String modelType;
  final int modelId;
  final int roleId;

  RolePivot({
    required this.modelType,
    required this.modelId,
    required this.roleId,
  });

  factory RolePivot.fromJson(Map<String, dynamic> json) {
    return RolePivot(
      modelType: json['model_type'] as String,
      modelId: json['model_id'] as int,
      roleId: json['role_id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'model_type': modelType,
      'model_id': modelId,
      'role_id': roleId,
    };
  }
}
