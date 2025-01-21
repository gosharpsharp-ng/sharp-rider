// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rider_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RiderStatsModel _$RiderStatsModelFromJson(Map<String, dynamic> json) =>
    RiderStatsModel(
      totalDistance: json['total_distance'],
      totalEarnings: json['total_earnings'],
      totalOrders: json['total_orders'],
    );

Map<String, dynamic> _$RiderStatsModelToJson(RiderStatsModel instance) =>
    <String, dynamic>{
      'total_distance': instance.totalDistance,
      'total_earnings': instance.totalEarnings,
      'total_orders': instance.totalOrders,
    };
