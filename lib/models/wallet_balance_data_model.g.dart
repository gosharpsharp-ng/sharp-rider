// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_balance_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalletBalanceDataModel _$WalletBalanceDataModelFromJson(
        Map<String, dynamic> json) =>
    WalletBalanceDataModel(
      id: (json['id'] as num).toInt(),
      balance: json['balance'] as String,
      bonusBalance: json['bonus_balance'] as String,
      currencyId: (json['currency_id'] as num?)?.toInt(),
      userId: (json['user_id'] as num).toInt(),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$WalletBalanceDataModelToJson(
        WalletBalanceDataModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'balance': instance.balance,
      'bonus_balance': instance.bonusBalance,
      'currency_id': instance.currencyId,
      'user_id': instance.userId,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
