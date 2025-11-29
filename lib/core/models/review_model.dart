class ReviewModel {
  final double averageRating;
  final List<Review> reviews;

  ReviewModel({
    required this.averageRating,
    required this.reviews,
  });

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      averageRating: _parseDouble(json['average_rating']),
      reviews: (json['reviews'] as List<dynamic>?)
              ?.map((e) => Review.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'average_rating': averageRating,
      'reviews': reviews.map((e) => e.toJson()).toList(),
    };
  }
}

class Review {
  final String review;
  final Author author;

  Review({
    required this.review,
    required this.author,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      review: json['review']?.toString() ?? '',
      author: Author.fromJson(json['author'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'review': review,
      'author': author.toJson(),
    };
  }
}

class Author {
  final int id;
  final String? avatar;
  final String fname;
  final String lname;
  final String phone;
  final String? dob;
  final String email;
  final String role;
  final String status;
  final String referralCode;
  final String? referredBy;
  final String? lastLoginAt;
  final int failedLoginAttempts;
  final String createdAt;
  final String updatedAt;

  Author({
    required this.id,
    this.avatar,
    required this.fname,
    required this.lname,
    required this.phone,
    this.dob,
    required this.email,
    required this.role,
    required this.status,
    required this.referralCode,
    this.referredBy,
    this.lastLoginAt,
    required this.failedLoginAttempts,
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

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: _parseInt(json['id']),
      avatar: json['avatar']?.toString(),
      fname: _parseString(json['fname']),
      lname: _parseString(json['lname']),
      phone: _parseString(json['phone']),
      dob: json['dob']?.toString(),
      email: _parseString(json['email']),
      role: _parseString(json['role']),
      status: _parseString(json['status']),
      referralCode: _parseString(json['referral_code']),
      referredBy: json['referred_by']?.toString(),
      lastLoginAt: json['last_login_at']?.toString(),
      failedLoginAttempts: _parseInt(json['failed_login_attempts']),
      createdAt: _parseString(json['created_at']),
      updatedAt: _parseString(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'avatar': avatar,
      'fname': fname,
      'lname': lname,
      'phone': phone,
      'dob': dob,
      'email': email,
      'role': role,
      'status': status,
      'referral_code': referralCode,
      'referred_by': referredBy,
      'last_login_at': lastLoginAt,
      'failed_login_attempts': failedLoginAttempts,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
