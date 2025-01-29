// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewModel _$ReviewModelFromJson(Map<String, dynamic> json) => ReviewModel(
      averageRating: (json['average_rating'] as num).toDouble(),
      reviews: (json['reviews'] as List<dynamic>)
          .map((e) => Review.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ReviewModelToJson(ReviewModel instance) =>
    <String, dynamic>{
      'average_rating': instance.averageRating,
      'reviews': instance.reviews.map((e) => e.toJson()).toList(),
    };

Review _$ReviewFromJson(Map<String, dynamic> json) => Review(
      review: json['review'] as String,
      author: Author.fromJson(json['author'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ReviewToJson(Review instance) => <String, dynamic>{
      'review': instance.review,
      'author': instance.author,
    };

Author _$AuthorFromJson(Map<String, dynamic> json) => Author(
      id: (json['id'] as num).toInt(),
      avatar: json['avatar'] as String?,
      fname: json['fname'] as String,
      lname: json['lname'] as String,
      phone: json['phone'] as String,
      dob: json['dob'] as String?,
      email: json['email'] as String,
      role: json['role'] as String,
      status: json['status'] as String,
      referralCode: json['referral_code'] as String,
      referredBy: json['referred_by'] as String?,
      lastLoginAt: json['last_login_at'] as String?,
      failedLoginAttempts: (json['failed_login_attempts'] as num).toInt(),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$AuthorToJson(Author instance) => <String, dynamic>{
      'id': instance.id,
      'avatar': instance.avatar,
      'fname': instance.fname,
      'lname': instance.lname,
      'phone': instance.phone,
      'dob': instance.dob,
      'email': instance.email,
      'role': instance.role,
      'status': instance.status,
      'referral_code': instance.referralCode,
      'referred_by': instance.referredBy,
      'last_login_at': instance.lastLoginAt,
      'failed_login_attempts': instance.failedLoginAttempts,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
