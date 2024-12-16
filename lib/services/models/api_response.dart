import 'dart:convert';

class APIResponse {
  bool success;
  String message;
  dynamic data;
  APIResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'success': success,
      'message': message,
      'data': data,
    };
  }

  factory APIResponse.fromMap(Map<String, dynamic> map) {
    return APIResponse(
      success: map['success'] ?? false,
      message: map['message']??"",
      data: map['data'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory APIResponse.fromJson(String source) =>
      APIResponse.fromMap(json.decode(source));
}
