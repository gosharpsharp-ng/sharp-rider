class WalletBalanceDataModel {
  final int id;
  final String availableBalance;
  final String pendingBalance;
  final String bonusBalance;
  final int? currencyId;
  final int userId;
  final String createdAt;
  final String updatedAt;

  WalletBalanceDataModel({
    required this.id,
    required this.availableBalance,
    required this.pendingBalance,
    required this.bonusBalance,
    this.currencyId,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
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

  static String _parseString(dynamic value) {
    return value?.toString() ?? '0.00';
  }

  factory WalletBalanceDataModel.fromJson(Map<String, dynamic> json) {
    return WalletBalanceDataModel(
      id: _parseInt(json['id']),
      availableBalance: _parseString(json['available_balance']),
      pendingBalance: _parseString(json['pending_balance']),
      bonusBalance: _parseString(json['bonus_balance']),
      currencyId: _parseNullableInt(json['currency_id']),
      userId: _parseInt(json['user_id']),
      createdAt: _parseString(json['created_at']),
      updatedAt: _parseString(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'available_balance': availableBalance,
      'pending_balance': pendingBalance,
      'bonus_balance': bonusBalance,
      'currency_id': currencyId,
      'user_id': userId,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
