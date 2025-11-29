class CourierTypeModel {
  final int id;
  final String name;
  final String description;
  final double pricePerKilometer;
  final double maxDistanceForDiscount;
  final double discountAmount;
  final String discountType;
  final double commission;
  final double additionalCharge;
  final String createdAt;
  final String updatedAt;

  CourierTypeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.pricePerKilometer,
    required this.maxDistanceForDiscount,
    required this.discountAmount,
    required this.discountType,
    required this.commission,
    required this.additionalCharge,
    required this.createdAt,
    required this.updatedAt,
  });

  // Helper to parse dynamic value to double
  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  // Helper to parse dynamic value to int
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  factory CourierTypeModel.fromJson(Map<String, dynamic> json) {
    return CourierTypeModel(
      id: _parseInt(json['id']),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      pricePerKilometer: _parseDouble(json['price_per_kilometer']),
      maxDistanceForDiscount: _parseDouble(json['max_distance_for_discount']),
      discountAmount: _parseDouble(json['discount_amount']),
      discountType: json['discount_type'] ?? '',
      commission: _parseDouble(json['commission']),
      additionalCharge: _parseDouble(json['additional_charge']),
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price_per_kilometer': pricePerKilometer,
      'max_distance_for_discount': maxDistanceForDiscount,
      'discount_amount': discountAmount,
      'discount_type': discountType,
      'commission': commission,
      'additional_charge': additionalCharge,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
