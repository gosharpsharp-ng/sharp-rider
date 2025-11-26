import 'package:json_annotation/json_annotation.dart';

part 'rating_stats_model.g.dart';

@JsonSerializable()
class RatingStatsModel {
  @JsonKey(name: 'start_date')
  final String? startDate;
  @JsonKey(name: 'end_date')
  final String? endDate;
  @JsonKey(name: 'total_orders')
  final int? totalOrders;
  @JsonKey(name: 'completed_orders')
  final int? completedOrders;
  @JsonKey(name: 'total_ratings')
  final int? totalRatings;
  @JsonKey(name: 'average_rating')
  final num? averageRating;
  @JsonKey(name: 'rating_breakdown')
  final RatingBreakdown? ratingBreakdown;
  @JsonKey(name: 'rating_percentage')
  final num? ratingPercentage;

  RatingStatsModel({
    this.startDate,
    this.endDate,
    this.totalOrders,
    this.completedOrders,
    this.totalRatings,
    this.averageRating,
    this.ratingBreakdown,
    this.ratingPercentage,
  });

  factory RatingStatsModel.fromJson(Map<String, dynamic> json) =>
      _$RatingStatsModelFromJson(json);

  Map<String, dynamic> toJson() => _$RatingStatsModelToJson(this);
}

@JsonSerializable()
class RatingBreakdown {
  @JsonKey(name: '5_star')
  final int? fiveStar;
  @JsonKey(name: '4_star')
  final int? fourStar;
  @JsonKey(name: '3_star')
  final int? threeStar;
  @JsonKey(name: '2_star')
  final int? twoStar;
  @JsonKey(name: '1_star')
  final int? oneStar;

  RatingBreakdown({
    this.fiveStar,
    this.fourStar,
    this.threeStar,
    this.twoStar,
    this.oneStar,
  });

  factory RatingBreakdown.fromJson(Map<String, dynamic> json) =>
      _$RatingBreakdownFromJson(json);

  Map<String, dynamic> toJson() => _$RatingBreakdownToJson(this);
}
