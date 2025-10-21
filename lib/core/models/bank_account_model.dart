import 'package:json_annotation/json_annotation.dart';

part 'bank_account_model.g.dart';

@JsonSerializable()
class BankAccount {
  final int id;
  @JsonKey(name: 'bank_account_number')
  final String bankAccountNumber;
  @JsonKey(name: 'bank_account_name')
  final String bankAccountName;
  @JsonKey(name: 'bank_name')
  final String bankName;
  @JsonKey(name: 'bank_code')
  final String bankCode;
  @JsonKey(name: 'recipient_id')
  final String recipientId;
  @JsonKey(name: 'user_id')
  final int userId;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  BankAccount({
    required this.id,
    required this.bankAccountNumber,
    required this.bankAccountName,
    required this.bankName,
    required this.bankCode,
    required this.recipientId,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BankAccount.fromJson(Map<String, dynamic> json) => _$BankAccountFromJson(json);
  Map<String, dynamic> toJson() => _$BankAccountToJson(this);
}