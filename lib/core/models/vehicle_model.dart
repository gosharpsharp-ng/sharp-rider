class VehicleModel {
  final int id;
  final int courierTypeId;
  final String? brand;
  final String? model;
  final String regNum;
  final String status;
  final int? year;
  final CourierType? courierType;

  VehicleModel({
    required this.id,
    required this.courierTypeId,
    this.brand,
    required this.status,
    this.model,
    required this.regNum,
    this.year,
    this.courierType,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'] as int,
      courierTypeId: json['courier_type_id'] as int,
      brand: json['brand'] as String?,
      model: json['model'] as String?,
      regNum: json['reg_num'] as String,
      status: json['status'] as String,
      year: json['year'] as int?,
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
      'year': year,
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
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      pricePerKilometer: json['price_per_kilometer'] as String,
    );
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
