class Wallet {
  final int id;
  final String balance;
  final String bonusBalance;
  final int? currencyId;
  final String? walletableType;
  final int? walletableId;
  final String? deletedAt;
  final String? createdAt;
  final String? updatedAt;

  Wallet({
    required this.id,
    required this.balance,
    required this.bonusBalance,
    this.currencyId,
    this.walletableType,
    this.walletableId,
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

  static String _parseString(dynamic value) {
    return value?.toString() ?? '0.00';
  }

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      id: _parseInt(json['id']),
      balance: _parseString(json['balance']),
      bonusBalance: _parseString(json['bonus_balance']),
      currencyId: _parseNullableInt(json['currency_id']),
      walletableType: json['walletable_type']?.toString(),
      walletableId: _parseNullableInt(json['walletable_id']),
      deletedAt: json['deleted_at']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'balance': balance,
      'bonus_balance': bonusBalance,
      'currency_id': currencyId,
      'walletable_type': walletableType,
      'walletable_id': walletableId,
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  // Convenience getters for calculations
  double get balanceDouble => double.tryParse(balance) ?? 0.0;
  double get bonusBalanceDouble => double.tryParse(bonusBalance) ?? 0.0;
  double get totalBalance => balanceDouble + bonusBalanceDouble;

  // Get available balance (main balance for withdrawals/payouts)
  String get availableBalance => balance;
}
