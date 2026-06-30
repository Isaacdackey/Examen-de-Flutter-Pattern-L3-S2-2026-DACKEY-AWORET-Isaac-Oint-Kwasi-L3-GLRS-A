class Wallet {
  final int id;
  final String code;
  final String phoneNumber;
  final String email;
  final double balance;
  final String currency;
  final String createdAt;
  final String? role;

  Wallet({
    required this.id,
    required this.code,
    required this.phoneNumber,
    required this.email,
    required this.balance,
    required this.currency,
    required this.createdAt,
    this.role,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      id: json['id'] ?? 0,
      code: json['code'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      email: json['email'] ?? '',
      balance: (json['balance'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'XOF',
      createdAt: json['createdAt'] ?? '',
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'phoneNumber': phoneNumber,
      'email': email,
      'balance': balance,
      'currency': currency,
      'createdAt': createdAt,
      'role': role,
    };
  }
}
