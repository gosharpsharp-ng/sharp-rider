import 'package:json_annotation/json_annotation.dart';

part 'delivery_notification_model.g.dart';

@JsonSerializable()
class DeliveryNotificationModel {
  final int id;
  @JsonKey(name: 'tracking_id')
  final String trackingId;
  final String status;
  @JsonKey(name: 'payment_status')
  final String paymentStatus;
  final String distance;
  final String cost;
  @JsonKey(name: 'user_id')
  final int userId;
  @JsonKey(name: 'rider_id')
  final int? riderId;
  @JsonKey(name: 'currency_id')
  final int? currencyId;
  @JsonKey(name: 'courier_type_id')
  final String courierTypeId;
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

  DeliveryNotificationModel({
    required this.id,
    required this.trackingId,
    required this.status,
    required this.paymentStatus,
    required this.distance,
    required this.cost,
    required this.userId,
    this.riderId,
    this.currencyId,
    required this.courierTypeId,
    required this.originableType,
    required this.originableId,
    required this.destinationableType,
    required this.destinationableId,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory method to create an instance from JSON
  factory DeliveryNotificationModel.fromJson(Map<String, dynamic> json) =>
      _$DeliveryNotificationModelFromJson(json);

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() => _$DeliveryNotificationModelToJson(this);
}
