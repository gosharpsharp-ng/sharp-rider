class DeliveryHistory {
  final int id;
  final String trackingId;
  final String status;
  final String paymentStatus;
  final String distance;
  final String cost;
  final String earning;
  final int userId;
  final int riderId;
  final dynamic currencyId;
  final dynamic paymentMethodId;
  final int courierTypeId;
  final String originableType;
  final int originableId;
  final String destinationableType;
  final int destinationableId;
  final String createdAt;
  final String updatedAt;

  DeliveryHistory({
    required this.id,
    required this.trackingId,
    required this.status,
    required this.paymentStatus,
    required this.distance,
    required this.cost,
    required this.earning,
    required this.userId,
    required this.riderId,
    required this.currencyId,
    required this.paymentMethodId,
    required this.courierTypeId,
    required this.originableType,
    required this.originableId,
    required this.destinationableType,
    required this.destinationableId,
    required this.createdAt,
    required this.updatedAt,
  });

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }

  static String _parseString(dynamic value) {
    return value?.toString() ?? '';
  }

  factory DeliveryHistory.fromJson(Map<String, dynamic> json) {
    return DeliveryHistory(
      id: _parseInt(json['id']),
      trackingId: _parseString(json['tracking_id']),
      status: _parseString(json['status']),
      paymentStatus: _parseString(json['payment_status']),
      distance: _parseString(json['distance']),
      cost: _parseString(json['cost']),
      earning: _parseString(json['earning']),
      userId: _parseInt(json['user_id']),
      riderId: _parseInt(json['rider_id']),
      currencyId: json['currency_id'],
      paymentMethodId: json['payment_method_id'],
      courierTypeId: _parseInt(json['courier_type_id']),
      originableType: _parseString(json['originable_type']),
      originableId: _parseInt(json['originable_id']),
      destinationableType: _parseString(json['destinationable_type']),
      destinationableId: _parseInt(json['destinationable_id']),
      createdAt: _parseString(json['created_at']),
      updatedAt: _parseString(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tracking_id': trackingId,
      'status': status,
      'payment_status': paymentStatus,
      'distance': distance,
      'cost': cost,
      'earning': earning,
      'user_id': userId,
      'rider_id': riderId,
      'currency_id': currencyId,
      'payment_method_id': paymentMethodId,
      'courier_type_id': courierTypeId,
      'originable_type': originableType,
      'originable_id': originableId,
      'destinationable_type': destinationableType,
      'destinationable_id': destinationableId,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class RiderStatsModel {
  final dynamic totalDistance;
  final dynamic totalEarnings;
  final dynamic totalOrders;
  final List<DeliveryHistory> shipments;

  RiderStatsModel({
    required this.totalDistance,
    required this.totalEarnings,
    required this.totalOrders,
    required this.shipments,
  });

  factory RiderStatsModel.fromJson(Map<String, dynamic> json) {
    return RiderStatsModel(
      totalDistance: json['total_distance'],
      totalEarnings: json['total_earnings'],
      totalOrders: json['total_orders'],
      shipments: (json['shipments'] as List<dynamic>?)
              ?.map((e) => DeliveryHistory.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_distance': totalDistance,
      'total_earnings': totalEarnings,
      'total_orders': totalOrders,
      'shipments': shipments.map((e) => e.toJson()).toList(),
    };
  }
}
