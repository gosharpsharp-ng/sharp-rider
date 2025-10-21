import 'package:gorider/core/models/delivery_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'delivery_notification_model.g.dart';

@JsonSerializable()
class DeliveryNotificationModel {
  final int id;
  @JsonKey(name: 'tracking_id')
  final String trackingId;
  final String status;
  @JsonKey(name: 'payment_status', defaultValue: "")
  final String paymentStatus;
  final String distance;
  final String cost;
  @JsonKey(name: 'user_id', defaultValue: 1)
  final int userId;
  @JsonKey(name: 'originable')
  final ShipmentLocation originLocation;
  @JsonKey(name: 'destinationable')
  final ShipmentLocation destinationLocation;
  DeliveryNotificationModel({
    required this.id,
    required this.trackingId,
    required this.status,
    required this.paymentStatus,
    required this.distance,
    required this.cost,
    required this.userId,
    required this.originLocation,
    required this.destinationLocation,
  });

  // Factory method to create an instance from JSON
  factory DeliveryNotificationModel.fromJson(Map<String, dynamic> json) =>
      _$DeliveryNotificationModelFromJson(json);

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() => _$DeliveryNotificationModelToJson(this);
}
