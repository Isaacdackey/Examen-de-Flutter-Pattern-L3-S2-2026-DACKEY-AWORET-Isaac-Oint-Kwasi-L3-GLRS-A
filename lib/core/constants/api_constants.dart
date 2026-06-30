class ApiConstants {
  static const String baseUrl = 'http://10.0.2.2:8080';
  
  static const String login = '/api/auth/login';
  static const String register = '/api/auth/register';
  static const String wallets = '/api/wallets';
  static const String balance = '/api/wallets/{phone}/balance';
  static const String transfer = '/api/wallets/transfer';
  static const String transactions = '/api/wallets/{phone}/transactions';
  static const String bills = '/api/external/factures/{code}/current';
  static const String payBills = '/api/wallets/pay-factures';
  static const String deposit = '/api/wallets/{id}/deposit';
  static const String withdraw = '/api/wallets/withdraw';
}
