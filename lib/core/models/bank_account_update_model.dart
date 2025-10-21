class BankAccountUpdateRequest {
  final String bankAccountNumber;
  final String bankAccountName;
  final String bankName;
  final String bankCode;

  BankAccountUpdateRequest({
    required this.bankAccountNumber,
    required this.bankAccountName,
    required this.bankName,
    required this.bankCode,
  });

  factory BankAccountUpdateRequest.fromJson(Map<String, dynamic> json) {
    return BankAccountUpdateRequest(
      bankAccountNumber: json['bank_account_number'] ?? '',
      bankAccountName: json['bank_account_name'] ?? '',
      bankName: json['bank_name'] ?? '',
      bankCode: json['bank_code'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bank_account_number': bankAccountNumber,
      'bank_account_name': bankAccountName,
      'bank_name': bankName,
      'bank_code': bankCode,
    };
  }
}
