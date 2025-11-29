class BankModel {
  final int id;
  final String name;
  final String slug;
  final String code;
  final String? longcode;
  final String? gateway;
  final bool payWithBank;
  final bool supportsTransfer;
  final bool active;
  final String country;
  final String currency;
  final String type;
  final bool isDeleted;
  final String createdAt;
  final String updatedAt;

  BankModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.code,
    this.longcode,
    this.gateway,
    required this.payWithBank,
    required this.supportsTransfer,
    required this.active,
    required this.country,
    required this.currency,
    required this.type,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }

  static String _parseString(dynamic value) {
    return value?.toString() ?? '';
  }

  static bool _parseBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) return value.toLowerCase() == 'true' || value == '1';
    return false;
  }

  factory BankModel.fromJson(Map<String, dynamic> json) {
    return BankModel(
      id: _parseInt(json['id']),
      name: _parseString(json['name']),
      slug: _parseString(json['slug']),
      code: _parseString(json['code']),
      longcode: json['longcode']?.toString(),
      gateway: json['gateway']?.toString(),
      payWithBank: _parseBool(json['pay_with_bank']),
      supportsTransfer: _parseBool(json['supports_transfer']),
      active: _parseBool(json['active']),
      country: _parseString(json['country']),
      currency: _parseString(json['currency']),
      type: _parseString(json['type']),
      isDeleted: _parseBool(json['is_deleted']),
      createdAt: _parseString(json['createdAt']),
      updatedAt: _parseString(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'code': code,
      'longcode': longcode,
      'gateway': gateway,
      'pay_with_bank': payWithBank,
      'supports_transfer': supportsTransfer,
      'active': active,
      'country': country,
      'currency': currency,
      'type': type,
      'is_deleted': isDeleted,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
