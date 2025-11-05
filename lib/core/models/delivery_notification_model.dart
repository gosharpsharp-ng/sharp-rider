import 'package:gorider/core/models/delivery_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'delivery_notification_model.g.dart';

@JsonSerializable()
class DeliveryNotificationModel {
  final int id;
  @JsonKey(name: 'order_id')
  final int? orderId;
  @JsonKey(name: 'tracking_id')
  final String trackingId;
  final String status;
  @JsonKey(name: 'payment_status', defaultValue: "")
  final String paymentStatus;
  final String distance;
  final String cost;
  @JsonKey(name: 'user_id', defaultValue: 1)
  final int userId;
  @JsonKey(name: 'rider_id')
  final int? riderId;
  @JsonKey(name: 'currency_id')
  final int? currencyId;
  @JsonKey(name: 'pickup_location')
  final ShipmentLocation originLocation;
  @JsonKey(name: 'destination_location')
  final ShipmentLocation destinationLocation;
  @JsonKey(name: 'receiver')
  final DeliveryReceiver? receiver;
  @JsonKey(name: 'user')
  final DeliveryUser? user;
  @JsonKey(name: 'currency')
  final DeliveryCurrency? currency;

  DeliveryNotificationModel({
    required this.id,
    this.orderId,
    required this.trackingId,
    required this.status,
    required this.paymentStatus,
    required this.distance,
    required this.cost,
    required this.userId,
    this.riderId,
    this.currencyId,
    required this.originLocation,
    required this.destinationLocation,
    this.receiver,
    this.user,
    this.currency,
  });

  // Factory method to create an instance from JSON
  factory DeliveryNotificationModel.fromJson(Map<String, dynamic> json) =>
      _$DeliveryNotificationModelFromJson(json);

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() => _$DeliveryNotificationModelToJson(this);
}

@JsonSerializable()
class DeliveryReceiver {
  final int id;
  final String name;
  final String address;
  final String phone;
  final String? email;

  DeliveryReceiver({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    this.email,
  });

  factory DeliveryReceiver.fromJson(Map<String, dynamic> json) =>
      _$DeliveryReceiverFromJson(json);
  Map<String, dynamic> toJson() => _$DeliveryReceiverToJson(this);
}

@JsonSerializable()
class DeliveryUser {
  final int id;
  final String fname;
  final String lname;
  final String email;
  final String phone;

  DeliveryUser({
    required this.id,
    required this.fname,
    required this.lname,
    required this.email,
    required this.phone,
  });

  factory DeliveryUser.fromJson(Map<String, dynamic> json) =>
      _$DeliveryUserFromJson(json);
  Map<String, dynamic> toJson() => _$DeliveryUserToJson(this);
}

@JsonSerializable()
class DeliveryCurrency {
  final int id;
  final String code;
  final String name;
  final String symbol;
  @JsonKey(name: 'exchange_rate')
  final String exchangeRate;

  DeliveryCurrency({
    required this.id,
    required this.code,
    required this.name,
    required this.symbol,
    required this.exchangeRate,
  });

  factory DeliveryCurrency.fromJson(Map<String, dynamic> json) =>
      _$DeliveryCurrencyFromJson(json);
  Map<String, dynamic> toJson() => _$DeliveryCurrencyToJson(this);
}
