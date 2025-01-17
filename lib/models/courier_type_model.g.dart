// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'courier_type_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourierTypeModel _$CourierTypeModelFromJson(Map<String, dynamic> json) =>
    CourierTypeModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String,
      pricePerKilometer: json['price_per_kilometer'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$CourierTypeModelToJson(CourierTypeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price_per_kilometer': instance.pricePerKilometer,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
