class DeliveryModel {
  final int id;
  final int? orderId;
  final String trackingId;
  final String? status;
  final String? paymentStatus;
  final String distance;
  final String cost;
  final int userId;
  final int? riderId;
  final int currencyId;
  final int? paymentMethodId;
  final int courierTypeId;
  final String? originableType;
  final int? originableId;
  final String? destinationableType;
  final int? destinationableId;
  final String? deletedAt;
  final String createdAt;
  final String updatedAt;
  final User? user;
  final Receiver? receiver;
  final List<Item>? items;
  final Currency? currency;
  final CourierType? courierType;
  final Rating? rating;
  final List<DeliveryLocation>? locations;

  // Get all pickup locations
  List<DeliveryLocation> get pickupLocations {
    if (locations == null || locations!.isEmpty) return [];
    return locations!.where((loc) => loc.isPickup).toList();
  }

  // Get all destination locations
  List<DeliveryLocation> get destinationLocations {
    if (locations == null || locations!.isEmpty) return [];
    return locations!.where((loc) => loc.isDestination).toList();
  }

  // Convenience getter for first pickup location
  DeliveryLocation get pickupLocation {
    final pickups = pickupLocations;
    if (pickups.isNotEmpty) return pickups.first;
    if (locations != null && locations!.isNotEmpty) return locations!.first;
    return DeliveryLocation.empty();
  }

  // Convenience getter for first destination location
  DeliveryLocation get destinationLocation {
    final destinations = destinationLocations;
    if (destinations.isNotEmpty) return destinations.first;
    if (locations != null && locations!.length > 1) return locations!.last;
    return DeliveryLocation.empty();
  }

  // Alias for backward compatibility
  DeliveryLocation get originLocation => pickupLocation;

  // Check if delivery has multiple stops
  bool get hasMultiplePickups => pickupLocations.length > 1;
  bool get hasMultipleDestinations => destinationLocations.length > 1;
  int get totalStops => (locations?.length ?? 0);

  DeliveryModel({
    required this.id,
    this.orderId,
    required this.trackingId,
    this.status,
    this.paymentStatus,
    required this.distance,
    required this.cost,
    required this.userId,
    this.riderId,
    required this.currencyId,
    this.paymentMethodId,
    required this.courierTypeId,
    this.originableType,
    this.originableId,
    this.destinationableType,
    this.destinationableId,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    this.user,
    this.receiver,
    this.items,
    this.currency,
    this.courierType,
    this.rating,
    this.locations,
  });

  factory DeliveryModel.fromJson(Map<String, dynamic> json) {
    return DeliveryModel(
      id: json['id'] as int,
      orderId: json['order_id'] as int?,
      trackingId: json['tracking_id'] as String,
      status: json['status'] as String?,
      paymentStatus: json['payment_status'] as String?,
      distance: _parseToString(json['distance']),
      cost: _parseToString(json['cost']),
      userId: json['user_id'] as int,
      riderId: json['rider_id'] as int?,
      currencyId: json['currency_id'] as int? ?? 0,
      paymentMethodId: json['payment_method_id'] as int?,
      courierTypeId: json['courier_type_id'] as int? ?? 0,
      originableType: json['originable_type'] as String?,
      originableId: json['originable_id'] as int?,
      destinationableType: json['destinationable_type'] as String?,
      destinationableId: json['destinationable_id'] as int?,
      deletedAt: json['deleted_at'] as String?,
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      receiver: json['receiver'] != null ? Receiver.fromJson(json['receiver']) : null,
      items: json['items'] != null
          ? (json['items'] as List).map((e) => Item.fromJson(e)).toList()
          : null,
      currency: json['currency'] != null ? Currency.fromJson(json['currency']) : null,
      courierType: json['courier_type'] != null ? CourierType.fromJson(json['courier_type']) : null,
      rating: json['rating'] != null ? Rating.fromJson(json['rating']) : null,
      locations: json['locations'] != null
          ? (json['locations'] as List).map((e) => DeliveryLocation.fromJson(e)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'tracking_id': trackingId,
      'status': status,
      'payment_status': paymentStatus,
      'distance': distance,
      'cost': cost,
      'user_id': userId,
      'rider_id': riderId,
      'currency_id': currencyId,
      'payment_method_id': paymentMethodId,
      'courier_type_id': courierTypeId,
      'originable_type': originableType,
      'originable_id': originableId,
      'destinationable_type': destinationableType,
      'destinationable_id': destinationableId,
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'user': user?.toJson(),
      'receiver': receiver?.toJson(),
      'items': items?.map((e) => e.toJson()).toList(),
      'currency': currency?.toJson(),
      'courier_type': courierType?.toJson(),
      'rating': rating?.toJson(),
      'locations': locations?.map((e) => e.toJson()).toList(),
    };
  }

  static String _parseToString(dynamic value) {
    if (value == null) return '0';
    if (value is String) return value;
    return value.toString();
  }
}

class DeliveryLocation {
  final int? id;
  final String? name;
  final String? latitude;
  final String? longitude;
  final String? locationableType;
  final int? locationableId;
  final String? deletedAt;
  final String? createdAt;
  final String? updatedAt;

  DeliveryLocation({
    this.id,
    this.name,
    this.latitude,
    this.longitude,
    this.locationableType,
    this.locationableId,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  String get displayName {
    if (name == null || name!.isEmpty) return '';
    final lowerName = name!.toLowerCase();
    if (lowerName.startsWith('pickup:')) {
      return name!.substring(7).trim();
    } else if (lowerName.startsWith('destination:')) {
      return name!.substring(12).trim();
    }
    return name!;
  }

  bool get isPickup => name?.toLowerCase().startsWith('pickup:') ?? false;
  bool get isDestination => name?.toLowerCase().startsWith('destination:') ?? false;

  factory DeliveryLocation.empty() => DeliveryLocation(
        id: 0,
        name: '',
        latitude: '0.0',
        longitude: '0.0',
      );

  factory DeliveryLocation.fromJson(Map<String, dynamic> json) {
    return DeliveryLocation(
      id: json['id'] as int?,
      name: json['name'] as String?,
      latitude: json['latitude']?.toString(),
      longitude: json['longitude']?.toString(),
      locationableType: json['locationable_type'] as String?,
      locationableId: json['locationable_id'] as int?,
      deletedAt: json['deleted_at'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'locationable_type': locationableType,
      'locationable_id': locationableId,
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class Receiver {
  final int? id;
  final String? name;
  final String? address;
  final String? phone;
  final String? email;
  final int? deliveryId;
  final String? deletedAt;
  final String? createdAt;
  final String? updatedAt;

  Receiver({
    this.id,
    this.name,
    this.address,
    this.phone,
    this.email,
    this.deliveryId,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory Receiver.fromJson(Map<String, dynamic> json) {
    return Receiver(
      id: json['id'] as int?,
      name: json['name'] as String?,
      address: json['address'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      deliveryId: json['delivery_id'] as int?,
      deletedAt: json['deleted_at'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phone': phone,
      'email': email,
      'delivery_id': deliveryId,
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class User {
  final int? id;
  final String? avatar;
  final String? avatarUrl;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? dob;
  final String? deviceTokenUpdatedAt;
  final String? email;
  final String? emailVerifiedAt;
  final String? phoneVerifiedAt;
  final String? status;
  final String? referralCode;
  final String? referredBy;
  final String? lastLoginAt;
  final int? failedLoginAttempts;
  final String? deletedAt;
  final String? createdAt;
  final String? updatedAt;

  User({
    this.id,
    this.avatar,
    this.avatarUrl,
    this.firstName,
    this.lastName,
    this.phone,
    this.dob,
    this.deviceTokenUpdatedAt,
    this.email,
    this.emailVerifiedAt,
    this.phoneVerifiedAt,
    this.status,
    this.referralCode,
    this.referredBy,
    this.lastLoginAt,
    this.failedLoginAttempts,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int?,
      avatar: json['avatar'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      firstName: json['fname'] as String?,
      lastName: json['lname'] as String?,
      phone: json['phone'] as String?,
      dob: json['dob'] as String?,
      deviceTokenUpdatedAt: json['device_token_updated_at'] as String?,
      email: json['email'] as String?,
      emailVerifiedAt: json['email_verified_at'] as String?,
      phoneVerifiedAt: json['phone_verified_at'] as String?,
      status: json['status'] as String?,
      referralCode: json['referral_code'] as String?,
      referredBy: json['referred_by'] as String?,
      lastLoginAt: json['last_login_at'] as String?,
      failedLoginAttempts: json['failed_login_attempts'] as int?,
      deletedAt: json['deleted_at'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'avatar': avatar,
      'avatar_url': avatarUrl,
      'fname': firstName,
      'lname': lastName,
      'phone': phone,
      'dob': dob,
      'device_token_updated_at': deviceTokenUpdatedAt,
      'email': email,
      'email_verified_at': emailVerifiedAt,
      'phone_verified_at': phoneVerifiedAt,
      'status': status,
      'referral_code': referralCode,
      'referred_by': referredBy,
      'last_login_at': lastLoginAt,
      'failed_login_attempts': failedLoginAttempts,
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class Currency {
  final int? id;
  final String? code;
  final String? name;
  final String? symbol;
  final String? exchangeRate;
  final String? deletedAt;
  final String? createdAt;
  final String? updatedAt;

  Currency({
    this.id,
    this.code,
    this.name,
    this.symbol,
    this.exchangeRate,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      id: json['id'] as int?,
      code: json['code'] as String?,
      name: json['name'] as String?,
      symbol: json['symbol'] as String?,
      exchangeRate: json['exchange_rate'] as String?,
      deletedAt: json['deleted_at'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'symbol': symbol,
      'exchange_rate': exchangeRate,
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class CourierType {
  final int? id;
  final String? name;
  final String? description;
  final String? pricePerKilometer;
  final String? commission;
  final String? additionalCharge;
  final String? maxDistanceForDiscount;
  final String? discountAmount;
  final String? discountType;
  final String? deletedAt;
  final String? createdAt;
  final String? updatedAt;

  CourierType({
    this.id,
    this.name,
    this.description,
    this.pricePerKilometer,
    this.commission,
    this.additionalCharge,
    this.maxDistanceForDiscount,
    this.discountAmount,
    this.discountType,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory CourierType.fromJson(Map<String, dynamic> json) {
    return CourierType(
      id: json['id'] as int?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      pricePerKilometer: json['price_per_kilometer'] as String?,
      commission: json['commission'] as String?,
      additionalCharge: json['additional_charge'] as String?,
      maxDistanceForDiscount: json['max_distance_for_discount'] as String?,
      discountAmount: json['discount_amount'] as String?,
      discountType: json['discount_type'] as String?,
      deletedAt: json['deleted_at'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price_per_kilometer': pricePerKilometer,
      'commission': commission,
      'additional_charge': additionalCharge,
      'max_distance_for_discount': maxDistanceForDiscount,
      'discount_amount': discountAmount,
      'discount_type': discountType,
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class Rating {
  final int? id;
  final int? points;
  final String? review;
  final int? shipmentId;
  final int? userId;

  Rating({
    this.id,
    this.points,
    this.review,
    this.shipmentId,
    this.userId,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      id: json['id'] as int?,
      points: json['points'] as int?,
      review: json['review'] as String?,
      shipmentId: json['shipment_id'] as int?,
      userId: json['user_id'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'points': points,
      'review': review,
      'shipment_id': shipmentId,
      'user_id': userId,
    };
  }
}

class Item {
  final int? id;
  final String? name;
  final String? image;
  final String? description;
  final String? category;
  final String? weight;
  final int? quantity;
  final int? deliveryId;
  final String? deletedAt;
  final String? createdAt;
  final String? updatedAt;

  Item({
    this.id,
    this.name,
    this.image,
    this.description,
    this.category,
    this.weight,
    this.quantity,
    this.deliveryId,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] as int?,
      name: json['name'] as String?,
      image: json['image'] as String?,
      description: json['description'] as String?,
      category: json['category'] as String?,
      weight: json['weight'] as String?,
      quantity: json['quantity'] as int?,
      deliveryId: json['delivery_id'] as int?,
      deletedAt: json['deleted_at'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'description': description,
      'category': category,
      'weight': weight,
      'quantity': quantity,
      'delivery_id': deliveryId,
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class CourierTypePrice {
  final int? courierTypeId;
  final String? courierType;
  final double? price;

  CourierTypePrice({
    this.courierTypeId,
    this.courierType,
    this.price,
  });

  factory CourierTypePrice.fromJson(Map<String, dynamic> json) {
    return CourierTypePrice(
      courierTypeId: json['courier_type_id'] as int?,
      courierType: json['courier_type'] as String?,
      price: (json['price'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courier_type_id': courierTypeId,
      'courier_type': courierType,
      'price': price,
    };
  }
}

class Sender {
  final int? id;
  final String? avatar;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? dob;
  final String? email;
  final String? role;
  final String? status;
  final String? referralCode;
  final String? referredBy;
  final String? lastLoginAt;
  final int? failedLoginAttempts;
  final String? createdAt;
  final String? updatedAt;

  Sender({
    this.id,
    this.avatar,
    this.firstName,
    this.lastName,
    this.phone,
    this.dob,
    this.email,
    this.role,
    this.status,
    this.referralCode,
    this.referredBy,
    this.lastLoginAt,
    this.failedLoginAttempts,
    this.createdAt,
    this.updatedAt,
  });

  factory Sender.fromJson(Map<String, dynamic> json) {
    return Sender(
      id: json['id'] as int?,
      avatar: json['avatar'] as String?,
      firstName: json['fname'] as String?,
      lastName: json['lname'] as String?,
      phone: json['phone'] as String?,
      dob: json['dob'] as String?,
      email: json['email'] as String?,
      role: json['role'] as String?,
      status: json['status'] as String?,
      referralCode: json['referral_code'] as String?,
      referredBy: json['referred_by'] as String?,
      lastLoginAt: json['last_login_at'] as String?,
      failedLoginAttempts: json['failed_login_attempts'] as int?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'avatar': avatar,
      'fname': firstName,
      'lname': lastName,
      'phone': phone,
      'dob': dob,
      'email': email,
      'role': role,
      'status': status,
      'referral_code': referralCode,
      'referred_by': referredBy,
      'last_login_at': lastLoginAt,
      'failed_login_attempts': failedLoginAttempts,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class Rider {
  final int? id;
  final String? avatar;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? dob;
  final String? email;
  final String? role;
  final String? status;
  final String? referralCode;
  final String? referredBy;
  final String? lastLoginAt;
  final int? failedLoginAttempts;
  final String? createdAt;
  final String? updatedAt;

  Rider({
    this.id,
    this.avatar,
    this.firstName,
    this.lastName,
    this.phone,
    this.dob,
    this.email,
    this.role,
    this.status,
    this.referralCode,
    this.referredBy,
    this.lastLoginAt,
    this.failedLoginAttempts,
    this.createdAt,
    this.updatedAt,
  });

  factory Rider.fromJson(Map<String, dynamic> json) {
    return Rider(
      id: json['id'] as int?,
      avatar: json['avatar'] as String?,
      firstName: json['fname'] as String?,
      lastName: json['lname'] as String?,
      phone: json['phone'] as String?,
      dob: json['dob'] as String?,
      email: json['email'] as String?,
      role: json['role'] as String?,
      status: json['status'] as String?,
      referralCode: json['referral_code'] as String?,
      referredBy: json['referred_by'] as String?,
      lastLoginAt: json['last_login_at'] as String?,
      failedLoginAttempts: json['failed_login_attempts'] as int?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'avatar': avatar,
      'fname': firstName,
      'lname': lastName,
      'phone': phone,
      'dob': dob,
      'email': email,
      'role': role,
      'status': status,
      'referral_code': referralCode,
      'referred_by': referredBy,
      'last_login_at': lastLoginAt,
      'failed_login_attempts': failedLoginAttempts,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
