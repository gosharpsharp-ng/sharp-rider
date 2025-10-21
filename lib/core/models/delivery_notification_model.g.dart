// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeliveryNotificationModel _$DeliveryNotificationModelFromJson(
        Map<String, dynamic> json) =>
    DeliveryNotificationModel(
      id: (json['id'] as num).toInt(),
      trackingId: json['tracking_id'] as String,
      status: json['status'] as String,
      paymentStatus: json['payment_status'] as String? ?? '',
      distance: json['distance'] as String,
      cost: json['cost'] as String,
      userId: (json['user_id'] as num?)?.toInt() ?? 1,
      originLocation:
          ShipmentLocation.fromJson(json['originable'] as Map<String, dynamic>),
      destinationLocation: ShipmentLocation.fromJson(
          json['destinationable'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DeliveryNotificationModelToJson(
        DeliveryNotificationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tracking_id': instance.trackingId,
      'status': instance.status,
      'payment_status': instance.paymentStatus,
      'distance': instance.distance,
      'cost': instance.cost,
      'user_id': instance.userId,
      'originable': instance.originLocation,
      'destinationable': instance.destinationLocation,
    };
