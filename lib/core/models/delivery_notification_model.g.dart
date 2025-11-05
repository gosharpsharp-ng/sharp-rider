// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeliveryNotificationModel _$DeliveryNotificationModelFromJson(
        Map<String, dynamic> json) =>
    DeliveryNotificationModel(
      id: (json['id'] as num).toInt(),
      orderId: (json['order_id'] as num?)?.toInt(),
      trackingId: json['tracking_id'] as String,
      status: json['status'] as String,
      paymentStatus: json['payment_status'] as String? ?? '',
      distance: json['distance'] as String,
      cost: json['cost'] as String,
      userId: (json['user_id'] as num?)?.toInt() ?? 1,
      riderId: (json['rider_id'] as num?)?.toInt(),
      currencyId: (json['currency_id'] as num?)?.toInt(),
      originLocation: ShipmentLocation.fromJson(
          json['pickup_location'] as Map<String, dynamic>),
      destinationLocation: ShipmentLocation.fromJson(
          json['destination_location'] as Map<String, dynamic>),
      receiver: json['receiver'] == null
          ? null
          : DeliveryReceiver.fromJson(json['receiver'] as Map<String, dynamic>),
      user: json['user'] == null
          ? null
          : DeliveryUser.fromJson(json['user'] as Map<String, dynamic>),
      currency: json['currency'] == null
          ? null
          : DeliveryCurrency.fromJson(json['currency'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DeliveryNotificationModelToJson(
        DeliveryNotificationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order_id': instance.orderId,
      'tracking_id': instance.trackingId,
      'status': instance.status,
      'payment_status': instance.paymentStatus,
      'distance': instance.distance,
      'cost': instance.cost,
      'user_id': instance.userId,
      'rider_id': instance.riderId,
      'currency_id': instance.currencyId,
      'pickup_location': instance.originLocation,
      'destination_location': instance.destinationLocation,
      'receiver': instance.receiver,
      'user': instance.user,
      'currency': instance.currency,
    };

DeliveryReceiver _$DeliveryReceiverFromJson(Map<String, dynamic> json) =>
    DeliveryReceiver(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      address: json['address'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$DeliveryReceiverToJson(DeliveryReceiver instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'phone': instance.phone,
      'email': instance.email,
    };

DeliveryUser _$DeliveryUserFromJson(Map<String, dynamic> json) => DeliveryUser(
      id: (json['id'] as num).toInt(),
      fname: json['fname'] as String,
      lname: json['lname'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
    );

Map<String, dynamic> _$DeliveryUserToJson(DeliveryUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fname': instance.fname,
      'lname': instance.lname,
      'email': instance.email,
      'phone': instance.phone,
    };

DeliveryCurrency _$DeliveryCurrencyFromJson(Map<String, dynamic> json) =>
    DeliveryCurrency(
      id: (json['id'] as num).toInt(),
      code: json['code'] as String,
      name: json['name'] as String,
      symbol: json['symbol'] as String,
      exchangeRate: json['exchange_rate'] as String,
    );

Map<String, dynamic> _$DeliveryCurrencyToJson(DeliveryCurrency instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'symbol': instance.symbol,
      'exchange_rate': instance.exchangeRate,
    };
