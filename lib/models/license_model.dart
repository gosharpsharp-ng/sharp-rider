import 'package:json_annotation/json_annotation.dart';

part 'license_model.g.dart';

@JsonSerializable()
class LicenseModel {
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'number')
  final String number;
  @JsonKey(name: 'front_img')
  final String? frontImage;
  @JsonKey(name: 'back_img')
  final String? backImage;
  @JsonKey(name: 'expiry_date')
  final String expiryDate;
  @JsonKey(name: 'issued_at')
  final String issuedAt;
  @JsonKey(name: 'status')
  final String status;
  @JsonKey(name: 'user_id')
  final int userId;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
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

  factory LicenseModel.fromJson(Map<String, dynamic> json) =>
      _$LicenseModelFromJson(json);
  Map<String, dynamic> toJson() => _$LicenseModelToJson(this);
}
