class PayStackAuthorizationModel {
  final String authorizationUrl;
  final String accessCode;
  final String reference;

  PayStackAuthorizationModel({
    required this.authorizationUrl,
    required this.accessCode,
    required this.reference,
  });

  static String _parseString(dynamic value) {
    return value?.toString() ?? '';
  }

  factory PayStackAuthorizationModel.fromJson(Map<String, dynamic> json) {
    return PayStackAuthorizationModel(
      authorizationUrl: _parseString(json['authorization_url']),
      accessCode: _parseString(json['access_code']),
      reference: _parseString(json['reference']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'authorization_url': authorizationUrl,
      'access_code': accessCode,
      'reference': reference,
    };
  }
}
