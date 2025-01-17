// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'license_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LicenseModel _$LicenseModelFromJson(Map<String, dynamic> json) => LicenseModel(
      id: (json['id'] as num).toInt(),
      number: json['number'] as String,
      frontImage: json['front_img'] as String?,
      backImage: json['back_img'] as String?,
      expiryDate: json['expiry_date'] as String,
      issuedAt: json['issued_at'] as String,
      status: json['status'] as String,
      userId: (json['user_id'] as num).toInt(),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$LicenseModelToJson(LicenseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'number': instance.number,
      'front_img': instance.frontImage,
      'back_img': instance.backImage,
      'expiry_date': instance.expiryDate,
      'issued_at': instance.issuedAt,
      'status': instance.status,
      'user_id': instance.userId,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
