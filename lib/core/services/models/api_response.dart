import 'dart:convert';

class APIResponse {
  String status;
  String message;
  dynamic data;
  APIResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'success': status,
      'message': message,
      'data': data,
    };
  }

  factory APIResponse.fromMap(Map<String, dynamic> map) {
    return APIResponse(
      status: map['status']?.toString() ?? "",
      message: map['message']?.toString() ?? map['error']?.toString() ?? "",
      data: map['data'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory APIResponse.fromJson(String source) =>
      APIResponse.fromMap(json.decode(source));
}
