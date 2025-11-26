// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RatingStatsModel _$RatingStatsModelFromJson(Map<String, dynamic> json) =>
    RatingStatsModel(
      startDate: json['start_date'] as String?,
      endDate: json['end_date'] as String?,
      totalOrders: (json['total_orders'] as num?)?.toInt(),
      completedOrders: (json['completed_orders'] as num?)?.toInt(),
      totalRatings: (json['total_ratings'] as num?)?.toInt(),
      averageRating: json['average_rating'] as num?,
      ratingBreakdown: json['rating_breakdown'] == null
          ? null
          : RatingBreakdown.fromJson(
              json['rating_breakdown'] as Map<String, dynamic>),
      ratingPercentage: json['rating_percentage'] as num?,
    );

Map<String, dynamic> _$RatingStatsModelToJson(RatingStatsModel instance) =>
    <String, dynamic>{
      'start_date': instance.startDate,
      'end_date': instance.endDate,
      'total_orders': instance.totalOrders,
      'completed_orders': instance.completedOrders,
      'total_ratings': instance.totalRatings,
      'average_rating': instance.averageRating,
      'rating_breakdown': instance.ratingBreakdown,
      'rating_percentage': instance.ratingPercentage,
    };

RatingBreakdown _$RatingBreakdownFromJson(Map<String, dynamic> json) =>
    RatingBreakdown(
      fiveStar: (json['5_star'] as num?)?.toInt(),
      fourStar: (json['4_star'] as num?)?.toInt(),
      threeStar: (json['3_star'] as num?)?.toInt(),
      twoStar: (json['2_star'] as num?)?.toInt(),
      oneStar: (json['1_star'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RatingBreakdownToJson(RatingBreakdown instance) =>
    <String, dynamic>{
      '5_star': instance.fiveStar,
      '4_star': instance.fourStar,
      '3_star': instance.threeStar,
      '2_star': instance.twoStar,
      '1_star': instance.oneStar,
    };
