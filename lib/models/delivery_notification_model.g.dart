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
      paymentStatus: json['payment_status'] as String,
      distance: json['distance'] as String,
      cost: json['cost'] as String,
      userId: (json['user_id'] as num).toInt(),
      riderId: (json['rider_id'] as num?)?.toInt(),
      currencyId: (json['currency_id'] as num?)?.toInt(),
      courierTypeId: json['courier_type_id'] as String,
      originableType: json['originable_type'] as String,
      originableId: (json['originable_id'] as num).toInt(),
      destinationableType: json['destinationable_type'] as String,
      destinationableId: (json['destinationable_id'] as num).toInt(),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
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
      'rider_id': instance.riderId,
      'currency_id': instance.currencyId,
      'courier_type_id': instance.courierTypeId,
      'originable_type': instance.originableType,
      'originable_id': instance.originableId,
      'destinationable_type': instance.destinationableType,
      'destinationable_id': instance.destinationableId,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
