// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rider_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeliveryHistory _$DeliveryHistoryFromJson(Map<String, dynamic> json) =>
    DeliveryHistory(
      id: (json['id'] as num).toInt(),
      trackingId: json['tracking_id'] as String,
      status: json['status'] as String,
      paymentStatus: json['payment_status'] as String,
      distance: json['distance'] as String,
      cost: json['cost'] as String,
      earning: json['earning'] as String,
      userId: (json['user_id'] as num).toInt(),
      riderId: (json['rider_id'] as num).toInt(),
      currencyId: json['currency_id'],
      paymentMethodId: json['payment_method_id'],
      courierTypeId: (json['courier_type_id'] as num).toInt(),
      originableType: json['originable_type'] as String,
      originableId: (json['originable_id'] as num).toInt(),
      destinationableType: json['destinationable_type'] as String,
      destinationableId: (json['destinationable_id'] as num).toInt(),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$DeliveryHistoryToJson(DeliveryHistory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tracking_id': instance.trackingId,
      'status': instance.status,
      'payment_status': instance.paymentStatus,
      'distance': instance.distance,
      'cost': instance.cost,
      'earning': instance.earning,
      'user_id': instance.userId,
      'rider_id': instance.riderId,
      'currency_id': instance.currencyId,
      'payment_method_id': instance.paymentMethodId,
      'courier_type_id': instance.courierTypeId,
      'originable_type': instance.originableType,
      'originable_id': instance.originableId,
      'destinationable_type': instance.destinationableType,
      'destinationable_id': instance.destinationableId,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

RiderStatsModel _$RiderStatsModelFromJson(Map<String, dynamic> json) =>
    RiderStatsModel(
      totalDistance: json['total_distance'],
      totalEarnings: json['total_earnings'],
      totalOrders: json['total_orders'],
      shipments: (json['shipments'] as List<dynamic>)
          .map((e) => DeliveryHistory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RiderStatsModelToJson(RiderStatsModel instance) =>
    <String, dynamic>{
      'total_distance': instance.totalDistance,
      'total_earnings': instance.totalEarnings,
      'total_orders': instance.totalOrders,
      'shipments': instance.shipments,
    };
