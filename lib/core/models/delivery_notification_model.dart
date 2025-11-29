class DeliveryNotificationModel {
  final int id;
  final int? orderId;
  final String trackingId;
  final String? status;
  final String paymentStatus;
  final String distance;
  final String cost;
  final int userId;
  final int? riderId;
  final int? courierTypeId;
  final NotificationLocation originLocation;
  final NotificationLocation destinationLocation;
  final DeliveryReceiver? receiver;
  final DeliveryNotificationSender? sender;
  final DeliveryUser? user;
  final DeliveryCurrency? currency;
  final String? message;

  DeliveryNotificationModel({
    required this.id,
    this.orderId,
    required this.trackingId,
    this.status,
    required this.paymentStatus,
    required this.distance,
    required this.cost,
    required this.userId,
    this.riderId,
    this.courierTypeId,
    required this.originLocation,
    required this.destinationLocation,
    this.receiver,
    this.sender,
    this.user,
    this.currency,
    this.message,
  });

  factory DeliveryNotificationModel.fromJson(Map<String, dynamic> json) {
    return DeliveryNotificationModel(
      id: json['deliveryId'] as int? ?? 0,
      orderId: json['orderId'] as int?,
      trackingId: json['trackingId'] as String? ?? '',
      status: json['status'] as String? ?? 'confirmed',
      paymentStatus: json['paymentStatus'] as String? ?? 'pending',
      distance: _parseToString(json['distance']),
      cost: _parseToString(json['price']),
      userId: json['userId'] as int? ?? 1,
      riderId: json['riderId'] as int?,
      courierTypeId: json['courierTypeId'] as int?,
      originLocation: json['pickupLocation'] != null
          ? NotificationLocation.fromJson(json['pickupLocation'])
          : NotificationLocation.empty(),
      destinationLocation: json['destinationLocation'] != null
          ? NotificationLocation.fromJson(json['destinationLocation'])
          : NotificationLocation.empty(),
      receiver: json['receiver'] != null
          ? DeliveryReceiver.fromJson(json['receiver'])
          : null,
      sender: json['sender'] != null
          ? DeliveryNotificationSender.fromJson(json['sender'])
          : null,
      user: json['user'] != null ? DeliveryUser.fromJson(json['user']) : null,
      currency: json['currency'] != null
          ? DeliveryCurrency.fromJson(json['currency'])
          : null,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deliveryId': id,
      'orderId': orderId,
      'trackingId': trackingId,
      'status': status,
      'paymentStatus': paymentStatus,
      'distance': distance,
      'price': cost,
      'userId': userId,
      'riderId': riderId,
      'courierTypeId': courierTypeId,
      'pickupLocation': originLocation.toJson(),
      'destinationLocation': destinationLocation.toJson(),
      'receiver': receiver?.toJson(),
      'sender': sender?.toJson(),
      'user': user?.toJson(),
      'currency': currency?.toJson(),
      'message': message,
    };
  }

  static String _parseToString(dynamic value) {
    if (value == null) return '0';
    if (value is String) return value;
    return value.toString();
  }
}

class DeliveryReceiver {
  final int? id;
  final String? name;
  final String? address;
  final String? phone;
  final String? email;

  DeliveryReceiver({
    this.id,
    this.name,
    this.address,
    this.phone,
    this.email,
  });

  factory DeliveryReceiver.fromJson(Map<String, dynamic> json) {
    return DeliveryReceiver(
      id: json['id'] as int?,
      name: json['name'] as String?,
      address: json['address'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phone': phone,
      'email': email,
    };
  }
}

class DeliveryUser {
  final int? id;
  final String? fname;
  final String? lname;
  final String? email;
  final String? phone;

  DeliveryUser({
    this.id,
    this.fname,
    this.lname,
    this.email,
    this.phone,
  });

  factory DeliveryUser.fromJson(Map<String, dynamic> json) {
    return DeliveryUser(
      id: json['id'] as int?,
      fname: json['fname'] as String?,
      lname: json['lname'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fname': fname,
      'lname': lname,
      'email': email,
      'phone': phone,
    };
  }
}

class DeliveryCurrency {
  final int? id;
  final String? code;
  final String? name;
  final String? symbol;
  final String? exchangeRate;

  DeliveryCurrency({
    this.id,
    this.code,
    this.name,
    this.symbol,
    this.exchangeRate,
  });

  factory DeliveryCurrency.fromJson(Map<String, dynamic> json) {
    return DeliveryCurrency(
      id: json['id'] as int?,
      code: json['code'] as String?,
      name: json['name'] as String?,
      symbol: json['symbol'] as String?,
      exchangeRate: json['exchange_rate'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'symbol': symbol,
      'exchange_rate': exchangeRate,
    };
  }
}

class NotificationLocation {
  final String? name;
  final String? latitude;
  final String? longitude;

  NotificationLocation({
    this.name,
    this.latitude,
    this.longitude,
  });

  factory NotificationLocation.empty() => NotificationLocation(
        name: '',
        latitude: '0.0',
        longitude: '0.0',
      );

  factory NotificationLocation.fromJson(Map<String, dynamic> json) {
    return NotificationLocation(
      name: json['name'] as String?,
      latitude: json['latitude']?.toString(),
      longitude: json['longitude']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

class DeliveryNotificationSender {
  final int? id;
  final String? name;
  final String? phone;
  final String? email;

  DeliveryNotificationSender({
    this.id,
    this.name,
    this.phone,
    this.email,
  });

  factory DeliveryNotificationSender.fromJson(Map<String, dynamic> json) {
    return DeliveryNotificationSender(
      id: json['id'] as int?,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
    };
  }
}
