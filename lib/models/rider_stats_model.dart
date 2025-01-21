import 'package:json_annotation/json_annotation.dart';

part 'rider_stats_model.g.dart';

@JsonSerializable()
class RiderStatsModel {
  @JsonKey(name: 'total_distance')
  final dynamic totalDistance;
  @JsonKey(name: 'total_earnings')
  final dynamic totalEarnings;
  @JsonKey(name: 'total_orders')
  final dynamic totalOrders;


  RiderStatsModel({
    required this.totalDistance,
    required this.totalEarnings,
    required this.totalOrders,
  });

  /// Factory method to generate a `RiderStatsModel` instance from JSON
  factory RiderStatsModel.fromJson(Map<String, dynamic> json) =>
      _$RiderStatsModelFromJson(json);

  /// Method to convert `RiderStatsModel` instance to JSON
  Map<String, dynamic> toJson() => _$RiderStatsModelToJson(this);

}