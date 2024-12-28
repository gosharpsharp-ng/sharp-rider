// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shipment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShipmentModel _$ShipmentModelFromJson(Map<String, dynamic> json) =>
    ShipmentModel(
      id: (json['id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      trackingId: json['tracking_id'] as String,
      status: json['status'] as String?,
      originLocation: ShipmentLocation.fromJson(
          json['origin_location'] as Map<String, dynamic>),
      destinationLocation: ShipmentLocation.fromJson(
          json['destination_location'] as Map<String, dynamic>),
      receiver: Receiver.fromJson(json['receiver'] as Map<String, dynamic>),
      items: (json['items'] as List<dynamic>)
          .map((e) => Item.fromJson(e as Map<String, dynamic>))
          .toList(),
      distance: json['distance'] as String,
      courierTypePrices: (json['courier_type_prices'] as List<dynamic>?)
          ?.map((e) => CourierTypePrice.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      timestamp: json['timestamp'] as String? ?? '',
    );

Map<String, dynamic> _$ShipmentModelToJson(ShipmentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'tracking_id': instance.trackingId,
      'status': instance.status,
      'origin_location': instance.originLocation,
      'destination_location': instance.destinationLocation,
      'receiver': instance.receiver,
      'items': instance.items,
      'distance': instance.distance,
      'courier_type_prices': instance.courierTypePrices,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'timestamp': instance.timestamp,
    };

ShipmentLocation _$ShipmentLocationFromJson(Map<String, dynamic> json) =>
    ShipmentLocation(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      latitude: json['latitude'] as String,
      longitude: json['longitude'] as String,
      locationableType: json['locationable_type'] as String,
      locationableId: (json['locationable_id'] as num).toInt(),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$ShipmentLocationToJson(ShipmentLocation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'locationable_type': instance.locationableType,
      'locationable_id': instance.locationableId,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

Receiver _$ReceiverFromJson(Map<String, dynamic> json) => Receiver(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      address: json['address'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      shipmentId: (json['shipment_id'] as num).toInt(),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$ReceiverToJson(Receiver instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'phone': instance.phone,
      'email': instance.email,
      'shipment_id': instance.shipmentId,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

Item _$ItemFromJson(Map<String, dynamic> json) => Item(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      category: json['category'] as String,
      weight: json['weight'] as String,
      quantity: (json['quantity'] as num).toInt(),
      shipmentId: (json['shipment_id'] as num).toInt(),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'category': instance.category,
      'weight': instance.weight,
      'quantity': instance.quantity,
      'shipment_id': instance.shipmentId,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

CourierTypePrice _$CourierTypePriceFromJson(Map<String, dynamic> json) =>
    CourierTypePrice(
      courierType: json['courier_type'] as String,
      price: (json['price'] as num).toDouble(),
    );

Map<String, dynamic> _$CourierTypePriceToJson(CourierTypePrice instance) =>
    <String, dynamic>{
      'courier_type': instance.courierType,
      'price': instance.price,
    };
