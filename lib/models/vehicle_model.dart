import 'package:json_annotation/json_annotation.dart';

part 'vehicle_model.g.dart';

@JsonSerializable()
class VehicleModel {
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'courier_type_id')
  final int courierTypeId;
  @JsonKey(name: 'brand')
  final String brand;
  @JsonKey(name: 'model')
  final String model;
  @JsonKey(name: 'reg_num')
  final String regNum;
  @JsonKey(name: 'year')
  final int year;

  VehicleModel({
    required this.id,
    required this.courierTypeId,
    required this.brand,
    required this.model,
    required this.regNum,
    required this.year,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) =>
      _$VehicleModelFromJson(json);
  Map<String, dynamic> toJson() => _$VehicleModelToJson(this);
}
