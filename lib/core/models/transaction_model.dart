class Transaction {
  final int id;
  final String paymentReference;
  final String amount;
  final String type;
  final String description;
  final String status;
  final int? currencyId;
  final int? gatewayId;
  final int userId;
  final String createdAt;
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
    return value?.toString() ?? '';
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: _parseInt(json['id']),
      paymentReference: _parseString(json['payment_reference']),
      amount: _parseString(json['amount']),
      type: _parseString(json['type']),
      description: _parseString(json['description']),
      status: _parseString(json['status']),
      currencyId: _parseNullableInt(json['currency_id']),
      gatewayId: _parseNullableInt(json['gateway_id']),
      userId: _parseInt(json['user_id']),
      createdAt: _parseString(json['created_at']),
      updatedAt: _parseString(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'payment_reference': paymentReference,
      'amount': amount,
      'type': type,
      'description': description,
      'status': status,
      'currency_id': currencyId,
      'gateway_id': gatewayId,
      'user_id': userId,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  // ==================== Convenience Getters ====================

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
