class CourierTypeModel {
  final int id;
  final String name;
  final String description;
  final double pricePerKilometer;
  final int maxDistanceForDiscount;
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

  factory CourierTypeModel.fromJson(Map<String, dynamic> json) {
    return CourierTypeModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      pricePerKilometer: (json['price_per_kilometer'] as num).toDouble(),
      maxDistanceForDiscount: json['max_distance_for_discount'],
      discountAmount: (json['discount_amount'] as num).toDouble(),
      discountType: json['discount_type'],
      commission: (json['commission'] as num).toDouble(),
      additionalCharge: (json['additional_charge'] as num).toDouble(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
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
