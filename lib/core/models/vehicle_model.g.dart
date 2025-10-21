// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleModel _$VehicleModelFromJson(Map<String, dynamic> json) => VehicleModel(
      id: (json['id'] as num).toInt(),
      courierTypeId: (json['courier_type_id'] as num).toInt(),
      brand: json['brand'] as String?,
      status: json['status'] as String,
      model: json['model'] as String?,
      regNum: json['reg_num'] as String,
      year: (json['year'] as num?)?.toInt(),
      courierType:
          CourierType.fromJson(json['courier_type'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VehicleModelToJson(VehicleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'courier_type_id': instance.courierTypeId,
      'brand': instance.brand,
      'model': instance.model,
      'reg_num': instance.regNum,
      'status': instance.status,
      'year': instance.year,
      'courier_type': instance.courierType,
    };

CourierType _$CourierTypeFromJson(Map<String, dynamic> json) => CourierType(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String,
      pricePerKilometer: json['price_per_kilometer'] as String,
    );

Map<String, dynamic> _$CourierTypeToJson(CourierType instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price_per_kilometer': instance.pricePerKilometer,
    };
