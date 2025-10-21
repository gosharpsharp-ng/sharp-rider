// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_account_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BankAccount _$BankAccountFromJson(Map<String, dynamic> json) => BankAccount(
      id: (json['id'] as num).toInt(),
      bankAccountNumber: json['bank_account_number'] as String,
      bankAccountName: json['bank_account_name'] as String,
      bankName: json['bank_name'] as String,
      bankCode: json['bank_code'] as String,
      recipientId: json['recipient_id'] as String,
      userId: (json['user_id'] as num).toInt(),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$BankAccountToJson(BankAccount instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bank_account_number': instance.bankAccountNumber,
      'bank_account_name': instance.bankAccountName,
      'bank_name': instance.bankName,
      'bank_code': instance.bankCode,
      'recipient_id': instance.recipientId,
      'user_id': instance.userId,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
