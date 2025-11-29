class RatingStatsModel {
  final String? startDate;
  final String? endDate;
  final int? totalOrders;
  final int? completedOrders;
  final int? totalRatings;
  final num? averageRating;
  final RatingBreakdown? ratingBreakdown;
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

  static int? _parseNullableInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  static num? _parseNullableNum(dynamic value) {
    if (value == null) return null;
    if (value is num) return value;
    return num.tryParse(value.toString());
  }

  factory RatingStatsModel.fromJson(Map<String, dynamic> json) {
    return RatingStatsModel(
      startDate: json['start_date']?.toString(),
      endDate: json['end_date']?.toString(),
      totalOrders: _parseNullableInt(json['total_orders']),
      completedOrders: _parseNullableInt(json['completed_orders']),
      totalRatings: _parseNullableInt(json['total_ratings']),
      averageRating: _parseNullableNum(json['average_rating']),
      ratingBreakdown: json['rating_breakdown'] != null
          ? RatingBreakdown.fromJson(json['rating_breakdown'] as Map<String, dynamic>)
          : null,
      ratingPercentage: _parseNullableNum(json['rating_percentage']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'start_date': startDate,
      'end_date': endDate,
      'total_orders': totalOrders,
      'completed_orders': completedOrders,
      'total_ratings': totalRatings,
      'average_rating': averageRating,
      'rating_breakdown': ratingBreakdown?.toJson(),
      'rating_percentage': ratingPercentage,
    };
  }
}

class RatingBreakdown {
  final int? fiveStar;
  final int? fourStar;
  final int? threeStar;
  final int? twoStar;
  final int? oneStar;

  RatingBreakdown({
    this.fiveStar,
    this.fourStar,
    this.threeStar,
    this.twoStar,
    this.oneStar,
  });

  static int? _parseNullableInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  factory RatingBreakdown.fromJson(Map<String, dynamic> json) {
    return RatingBreakdown(
      fiveStar: _parseNullableInt(json['5_star']),
      fourStar: _parseNullableInt(json['4_star']),
      threeStar: _parseNullableInt(json['3_star']),
      twoStar: _parseNullableInt(json['2_star']),
      oneStar: _parseNullableInt(json['1_star']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '5_star': fiveStar,
      '4_star': fourStar,
      '3_star': threeStar,
      '2_star': twoStar,
      '1_star': oneStar,
    };
  }
}
