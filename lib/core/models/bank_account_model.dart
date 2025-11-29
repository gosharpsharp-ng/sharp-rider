class BankAccount {
  final int id;
  final String bankAccountNumber;
  final String bankAccountName;
  final String bankName;
  final String bankCode;
  final String? recipientId;
  final String? accountableType;
  final int? accountableId;
  final String? deletedAt;
  final String? createdAt;
  final String? updatedAt;

  BankAccount({
    required this.id,
    required this.bankAccountNumber,
    required this.bankAccountName,
    required this.bankName,
    required this.bankCode,
    this.recipientId,
    this.accountableType,
    this.accountableId,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }

  static int? _parseNullableInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  factory BankAccount.fromJson(Map<String, dynamic> json) {
    return BankAccount(
      id: _parseInt(json['id']),
      bankAccountNumber: json['bank_account_number']?.toString() ?? '',
      bankAccountName: json['bank_account_name']?.toString() ?? '',
      bankName: json['bank_name']?.toString() ?? '',
      bankCode: json['bank_code']?.toString() ?? '',
      recipientId: json['recipient_id']?.toString(),
      accountableType: json['accountable_type']?.toString(),
      accountableId: _parseNullableInt(json['accountable_id']),
      deletedAt: json['deleted_at']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bank_account_number': bankAccountNumber,
      'bank_account_name': bankAccountName,
      'bank_name': bankName,
      'bank_code': bankCode,
      'recipient_id': recipientId,
      'accountable_type': accountableType,
      'accountable_id': accountableId,
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
