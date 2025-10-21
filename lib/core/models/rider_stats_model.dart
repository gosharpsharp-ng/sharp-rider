import 'package:json_annotation/json_annotation.dart';

part 'rider_stats_model.g.dart';

// DeliveryHistory class definition
@JsonSerializable()
class DeliveryHistory {
  final int id;
  @JsonKey(name: 'tracking_id')
  final String trackingId;
  final String status;
  @JsonKey(name: 'payment_status')
  final String paymentStatus;
  final String distance;
  final String cost;
  final String earning;
  @JsonKey(name: 'user_id')
  final int userId;
  @JsonKey(name: 'rider_id')
  final int riderId;
  @JsonKey(name: 'currency_id')
  final dynamic currencyId;
  @JsonKey(name: 'payment_method_id')
  final dynamic paymentMethodId;
  @JsonKey(name: 'courier_type_id')
  final int courierTypeId;
  @JsonKey(name: 'originable_type')
  final String originableType;
  @JsonKey(name: 'originable_id')
  final int originableId;
  @JsonKey(name: 'destinationable_type')
  final String destinationableType;
  @JsonKey(name: 'destinationable_id')
  final int destinationableId;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  DeliveryHistory({
    required this.id,
    required this.trackingId,
    required this.status,
    required this.paymentStatus,
    required this.distance,
    required this.cost,
    required this.earning,
    required this.userId,
    required this.riderId,
    required this.currencyId,
    required this.paymentMethodId,
    required this.courierTypeId,
    required this.originableType,
    required this.originableId,
    required this.destinationableType,
    required this.destinationableId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DeliveryHistory.fromJson(Map<String, dynamic> json) =>
      _$DeliveryHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$DeliveryHistoryToJson(this);
}

// RiderStatsModel class definition
@JsonSerializable()
class RiderStatsModel {
  @JsonKey(name: 'total_distance')
  final dynamic totalDistance;
  @JsonKey(name: 'total_earnings')
  final dynamic totalEarnings;
  @JsonKey(name: 'total_orders')
  final dynamic totalOrders;
  @JsonKey(name: 'shipments') // Adding the List of DeliveryHistory
  final List<DeliveryHistory> shipments;

  RiderStatsModel({
    required this.totalDistance,
    required this.totalEarnings,
    required this.totalOrders,
    required this.shipments,
  });

  /// Factory method to generate a `RiderStatsModel` instance from JSON
  factory RiderStatsModel.fromJson(Map<String, dynamic> json) =>
      _$RiderStatsModelFromJson(json);

  /// Method to convert `RiderStatsModel` instance to JSON
  Map<String, dynamic> toJson() => _$RiderStatsModelToJson(this);
}
