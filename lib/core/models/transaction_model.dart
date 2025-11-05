import 'package:json_annotation/json_annotation.dart';

part 'transaction_model.g.dart';

@JsonSerializable()
class Transaction {
  final int id;
  @JsonKey(name: 'payment_reference')
  final String paymentReference;
  final String amount;
  final String type;
  final String description;
  final String status;
  @JsonKey(name: 'currency_id')
  final int? currencyId;
  @JsonKey(name: 'gateway_id')
  final int? gatewayId;
  @JsonKey(name: 'user_id')
  final int userId;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  Transaction({
    required this.id,
    required this.paymentReference,
    required this.amount,
    required this.type,
    required this.description,
    required this.status,
    this.currencyId,
    this.gatewayId,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory method to create an instance from JSON
  factory Transaction.fromJson(Map<String, dynamic> json) => _$TransactionFromJson(json);

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() => _$TransactionToJson(this);

  // ==================== Sharp-vendor Convenience Getters ====================

  /// Parse amount as double for calculations
  double get amountDouble => double.tryParse(amount) ?? 0.0;

  /// Check if transaction is a credit (incoming money)
  bool get isCredit => type.toLowerCase() == 'credit';

  /// Check if transaction is a debit (outgoing money)
  bool get isDebit => type.toLowerCase() == 'debit';

  /// Check if transaction is successful
  bool get isSuccessful => status.toLowerCase() == 'successful';

  /// Check if transaction is pending
  bool get isPending => status.toLowerCase() == 'pending';

  /// Check if transaction is failed
  bool get isFailed => status.toLowerCase() == 'failed';

  /// Parse created_at to DateTime
  DateTime? get createdAtDateTime {
    try {
      return DateTime.parse(createdAt);
    } catch (e) {
      return null;
    }
  }

  /// Parse updated_at to DateTime
  DateTime? get updatedAtDateTime {
    try {
      return DateTime.parse(updatedAt);
    } catch (e) {
      return null;
    }
  }

  /// Format created_at as relative time (e.g., "2d ago", "5h ago", "Just now")
  String get formattedCreatedAt {
    final date = createdAtDateTime;
    if (date == null) return createdAt;

    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  /// Get user-friendly status text
  String get statusDisplayText {
    switch (status.toLowerCase()) {
      case 'successful':
        return 'Successful';
      case 'pending':
        return 'Pending';
      case 'failed':
        return 'Failed';
      default:
        return status.toUpperCase();
    }
  }

  /// Get user-friendly type text
  String get typeDisplayText {
    switch (type.toLowerCase()) {
      case 'credit':
        return 'Credit';
      case 'debit':
        return 'Debit';
      case 'wallet':
        return 'Wallet Transaction';
      case 'order':
        return 'Order Payment';
      case 'withdrawal':
        return 'Withdrawal';
      default:
        return type.toUpperCase();
    }
  }
}
