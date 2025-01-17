import 'package:json_annotation/json_annotation.dart';

part 'courier_type_model.g.dart';

@JsonSerializable()
class CourierTypeModel {
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'description')
  final String description;
  @JsonKey(name: 'price_per_kilometer')
  final String pricePerKilometer;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  CourierTypeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.pricePerKilometer,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CourierTypeModel.fromJson(Map<String, dynamic> json) =>
      _$CourierTypeModelFromJson(json);
  Map<String, dynamic> toJson() => _$CourierTypeModelToJson(this);
}
