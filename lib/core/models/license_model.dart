class LicenseModel {
  final int id;
  final String number;
  final String? frontImage;
  final String? backImage;
  final String expiryDate;
  final String issuedAt;
  final String status;
  final int userId;
  final String createdAt;
  final String updatedAt;

  LicenseModel({
    required this.id,
    required this.number,
    this.frontImage,
    this.backImage,
    required this.expiryDate,
    required this.issuedAt,
    required this.status,
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

  static String _parseString(dynamic value) {
    return value?.toString() ?? '';
  }

  factory LicenseModel.fromJson(Map<String, dynamic> json) {
    return LicenseModel(
      id: _parseInt(json['id']),
      number: _parseString(json['number']),
      frontImage: json['front_img']?.toString(),
      backImage: json['back_img']?.toString(),
      expiryDate: _parseString(json['expiry_date']),
      issuedAt: _parseString(json['issued_at']),
      status: _parseString(json['status']),
      userId: _parseInt(json['user_id']),
      createdAt: _parseString(json['created_at']),
      updatedAt: _parseString(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'number': number,
      'front_img': frontImage,
      'back_img': backImage,
      'expiry_date': expiryDate,
      'issued_at': issuedAt,
      'status': status,
      'user_id': userId,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
