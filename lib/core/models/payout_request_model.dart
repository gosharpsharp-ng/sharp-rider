import 'wallet_model.dart';

class PayoutRequest {
  final int id;
  final String ref;
  final String amount;
  final String status;
  final String? notes;
  final String requestedAt;
  final String? processedAt;
  final String requestableType;
  final int requestableId;
  final int? processedBy;
  final int? gatewayId;
  final int? currencyId;
  final int walletId;
  final String? paymentMethod;
  final String? paymentDetails;
  final String? deletedAt;
  final String createdAt;
  final String updatedAt;
  final dynamic processor;
  final Wallet? wallet;

  PayoutRequest({
    required this.id,
    required this.ref,
    required this.amount,
    required this.status,
    this.notes,
    required this.requestedAt,
    this.processedAt,
    required this.requestableType,
    required this.requestableId,
    this.processedBy,
    this.gatewayId,
    this.currencyId,
    required this.walletId,
    this.paymentMethod,
    this.paymentDetails,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    this.processor,
    this.wallet,
  });

  factory PayoutRequest.fromJson(Map<String, dynamic> json) {
    return PayoutRequest(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      ref: json['ref']?.toString() ?? '',
      amount: json['amount']?.toString() ?? '0',
      status: json['status']?.toString() ?? 'pending',
      notes: json['notes']?.toString() ?? json['note']?.toString(),
      requestedAt: json['requested_at']?.toString() ?? '',
      processedAt: json['processed_at']?.toString(),
      requestableType: json['requestable_type']?.toString() ?? '',
      requestableId: json['requestable_id'] is int ? json['requestable_id'] : int.tryParse(json['requestable_id']?.toString() ?? '0') ?? 0,
      processedBy: json['processed_by'] != null ? (json['processed_by'] is int ? json['processed_by'] : int.tryParse(json['processed_by'].toString())) : null,
      gatewayId: json['gateway_id'] != null ? (json['gateway_id'] is int ? json['gateway_id'] : int.tryParse(json['gateway_id'].toString())) : null,
      currencyId: json['currency_id'] != null ? (json['currency_id'] is int ? json['currency_id'] : int.tryParse(json['currency_id'].toString())) : null,
      walletId: json['wallet_id'] is int ? json['wallet_id'] : int.tryParse(json['wallet_id']?.toString() ?? '0') ?? 0,
      paymentMethod: json['payment_method']?.toString(),
      paymentDetails: json['payment_details']?.toString(),
      deletedAt: json['deleted_at']?.toString(),
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
      processor: json['processor'],
      wallet: json['wallet'] != null ? Wallet.fromJson(json['wallet']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ref': ref,
      'amount': amount,
      'status': status,
      'notes': notes,
      'requested_at': requestedAt,
      'processed_at': processedAt,
      'requestable_type': requestableType,
      'requestable_id': requestableId,
      'processed_by': processedBy,
      'gateway_id': gatewayId,
      'currency_id': currencyId,
      'wallet_id': walletId,
      'payment_method': paymentMethod,
      'payment_details': paymentDetails,
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'processor': processor,
      'wallet': wallet?.toJson(),
    };
  }

  // Convenience getters for better data handling
  double get amountDouble => double.tryParse(amount) ?? 0.0;

  bool get isPending => status.toLowerCase() == 'pending';
  bool get isApproved => status.toLowerCase() == 'approved';
  bool get isProcessed => status.toLowerCase() == 'processed';
  bool get isCompleted => status.toLowerCase() == 'completed';
  bool get isRejected => status.toLowerCase() == 'rejected';
  bool get isCancelled => status.toLowerCase() == 'cancelled';

  DateTime? get requestedAtDateTime {
    try {
      return DateTime.parse(requestedAt);
    } catch (e) {
      return null;
    }
  }

  DateTime? get processedAtDateTime {
    try {
      return processedAt != null ? DateTime.parse(processedAt!) : null;
    } catch (e) {
      return null;
    }
  }

  DateTime? get createdAtDateTime {
    try {
      return DateTime.parse(createdAt);
    } catch (e) {
      return null;
    }
  }

  String get formattedRequestedAt {
    final date = requestedAtDateTime;
    if (date == null) return requestedAt;

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

  String get statusDisplayText {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending Review';
      case 'approved':
        return 'Approved';
      case 'processed':
        return 'Processing';
      case 'completed':
        return 'Completed';
      case 'rejected':
        return 'Rejected';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status.toUpperCase();
    }
  }

  String get paymentMethodDisplayText {
    if (paymentMethod == null || paymentMethod!.isEmpty) {
      return 'Bank Transfer';
    }
    switch (paymentMethod!.toLowerCase()) {
      case 'bank':
        return 'Bank Transfer';
      case 'mobile_money':
        return 'Mobile Money';
      case 'card':
        return 'Card';
      default:
        return paymentMethod!.toUpperCase();
    }
  }
}

/// Model for creating payout requests
class PayoutRequestData {
  final double amount;
  final String paymentMethod;

  PayoutRequestData({
    required this.amount,
    required this.paymentMethod,
  });

  Map<String, dynamic> toJson() => {
    'amount': amount,
    'payment_method_code': paymentMethod,
  };
}
