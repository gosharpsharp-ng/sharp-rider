import 'package:json_annotation/json_annotation.dart';

part 'wallet_model.g.dart';

@JsonSerializable()
class Wallet {
  final int id;
  final String balance;
  @JsonKey(name: 'bonus_balance')
  final String bonusBalance;
  @JsonKey(name: 'currency_id')
  final int? currencyId;
  @JsonKey(name: 'walletable_type')
  final String? walletableType;
  @JsonKey(name: 'walletable_id')
  final int? walletableId;
  @JsonKey(name: 'deleted_at')
  final String? deletedAt;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
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

  // Factory method to create an instance from JSON
  factory Wallet.fromJson(Map<String, dynamic> json) => _$WalletFromJson(json);

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() => _$WalletToJson(this);

  // Convenience getters for calculations
  double get balanceDouble => double.tryParse(balance) ?? 0.0;
  double get bonusBalanceDouble => double.tryParse(bonusBalance) ?? 0.0;
  double get totalBalance => balanceDouble + bonusBalanceDouble;

  // Get available balance (main balance for withdrawals/payouts)
  String get availableBalance => balance;
}
