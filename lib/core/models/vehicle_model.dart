class VehicleModel {
  final int id;
  final int courierTypeId;
  final String? brand;
  final String? model;
  final String regNum;
  final String status;
  final String? availabilityStatus;
  final int? year;
  final int? userId;
  final String? interiorPhoto;
  final String? exteriorPhoto;
  final bool? verified;
  final String? deletedAt;
  final String? createdAt;
  final String? updatedAt;
  final CourierType? courierType;

  VehicleModel({
    required this.id,
    required this.courierTypeId,
    this.brand,
    required this.status,
    this.availabilityStatus,
    this.model,
    required this.regNum,
    this.year,
    this.userId,
    this.interiorPhoto,
    this.exteriorPhoto,
    this.verified,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.courierType,
  });

  // Helper to parse int from dynamic (handles String or int)
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  // Helper to parse nullable int
  static int? _parseNullableInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  // Helper to parse bool from dynamic (handles int 0/1, String, or bool)
  static bool? _parseBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) return value.toLowerCase() == 'true' || value == '1';
    return null;
  }

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: _parseInt(json['id']),
      courierTypeId: _parseInt(json['courier_type_id']),
      brand: json['brand']?.toString(),
      model: json['model']?.toString(),
      regNum: json['reg_num']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      availabilityStatus: json['availability_status']?.toString(),
      year: _parseNullableInt(json['year']),
      userId: _parseNullableInt(json['user_id']),
      interiorPhoto: json['interior_photo']?.toString(),
      exteriorPhoto: json['exterior_photo']?.toString(),
      verified: _parseBool(json['verified']),
      deletedAt: json['deleted_at']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
      courierType: json['courier_type'] != null
          ? CourierType.fromJson(json['courier_type'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'courier_type_id': courierTypeId,
      'brand': brand,
      'model': model,
      'reg_num': regNum,
      'status': status,
      'availability_status': availabilityStatus,
      'year': year,
      'user_id': userId,
      'interior_photo': interiorPhoto,
      'exterior_photo': exteriorPhoto,
      'verified': verified,
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'courier_type': courierType?.toJson(),
    };
  }
}

class CourierType {
  final int id;
  final String name;
  final String description;
  final String pricePerKilometer;

  CourierType({
    required this.id,
    required this.name,
    required this.description,
    required this.pricePerKilometer,
  });

  factory CourierType.fromJson(Map<String, dynamic> json) {
    return CourierType(
      id: _parseInt(json['id']),
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      pricePerKilometer: json['price_per_kilometer']?.toString() ?? '0',
    );
  }

  // Helper to parse int from dynamic
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price_per_kilometer': pricePerKilometer,
    };
  }
}
