import 'package:json_annotation/json_annotation.dart';

part 'vehicle_model.g.dart';

@JsonSerializable()
class VehicleModel {
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'courier_type_id')
  final int courierTypeId;
  @JsonKey(name: 'brand')
  final String? brand;
  @JsonKey(name: 'model')
  final String? model;
  @JsonKey(name: 'reg_num')
  final String regNum;
  @JsonKey(name: 'status')
  final String status;
  @JsonKey(name: 'year')
  final int? year;
  @JsonKey(name: 'courier_type')
  final CourierType courierType;

  VehicleModel({
    required this.id,
    required this.courierTypeId,
    required this.brand,
    required this.status,
    required this.model,
    required this.regNum,
    required this.year,
    required this.courierType,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) =>
      _$VehicleModelFromJson(json);
  Map<String, dynamic> toJson() => _$VehicleModelToJson(this);
}

@JsonSerializable()
class CourierType {
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'description')
  final String description;
  @JsonKey(name: 'price_per_kilometer')
  final String pricePerKilometer;

  CourierType(
      {required this.id,
      required this.name,
      required this.description,
      required this.pricePerKilometer});

  factory CourierType.fromJson(Map<String, dynamic> json) =>
      _$CourierTypeFromJson(json);
  Map<String, dynamic> toJson() => _$CourierTypeToJson(this);
}
