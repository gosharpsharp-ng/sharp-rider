// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleModel _$VehicleModelFromJson(Map<String, dynamic> json) => VehicleModel(
      id: (json['id'] as num).toInt(),
      courierTypeId: (json['courier_type_id'] as num).toInt(),
      brand: json['brand'] as String,
      model: json['model'] as String,
      regNum: json['reg_num'] as String,
      year: (json['year'] as num).toInt(),
    );

Map<String, dynamic> _$VehicleModelToJson(VehicleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'courier_type_id': instance.courierTypeId,
      'brand': instance.brand,
      'model': instance.model,
      'reg_num': instance.regNum,
      'year': instance.year,
    };
