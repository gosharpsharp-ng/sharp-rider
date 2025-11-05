// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Wallet _$WalletFromJson(Map<String, dynamic> json) => Wallet(
      id: (json['id'] as num).toInt(),
      balance: json['balance'] as String,
      bonusBalance: json['bonus_balance'] as String,
      currencyId: (json['currency_id'] as num?)?.toInt(),
      walletableType: json['walletable_type'] as String?,
      walletableId: (json['walletable_id'] as num?)?.toInt(),
      deletedAt: json['deleted_at'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$WalletToJson(Wallet instance) => <String, dynamic>{
      'id': instance.id,
      'balance': instance.balance,
      'bonus_balance': instance.bonusBalance,
      'currency_id': instance.currencyId,
      'walletable_type': instance.walletableType,
      'walletable_id': instance.walletableId,
      'deleted_at': instance.deletedAt,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
