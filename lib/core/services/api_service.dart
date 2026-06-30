import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../constants/api_constants.dart';
import '../models/wallet.dart';
import '../models/transaction.dart';
import '../models/facture.dart';

class ApiService extends ChangeNotifier {
  String? _token;
  String? _phoneNumber;
  double _balance = 0;
  List<Transaction> _transactions = [];
  List<Facture> _factures = [];
  bool _isLoading = false;

  String? get token => _token;
  String? get phoneNumber => _phoneNumber;
  double get balance => _balance;
  List<Transaction> get transactions => _transactions;
  List<Facture> get factures => _factures;
  bool get isLoading => _isLoading;

  void setToken(String token) {
    _token = token;
    notifyListeners();
  }

  void setPhoneNumber(String phone) {
    _phoneNumber = phone;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void updateBalance(double newBalance) {
    _balance = newBalance;
    notifyListeners();
  }

  void updateTransactions(List<Transaction> newTransactions) {
    _transactions = newTransactions;
    notifyListeners();
  }

  void updateFactures(List<Facture> newFactures) {
    _factures = newFactures;
    notifyListeners();
  }

  Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (_token != null) 'Authorization': 'Bearer $_token',
    };
  }

  Future<Map<String, dynamic>> getWalletByPhone(String phone) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.wallets}/$phone'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return {'success': true, 'data': data['data']};
        }
      }
      return {'success': false, 'message': 'Erreur'};
    } catch (e) {
      return {'success': false, 'message': 'Erreur de connexion'};
    }
  }

  Future<Map<String, dynamic>> login(
    String phoneNumber,
    String password,
  ) async {
    setLoading(true);
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.login}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'phoneNumber': phoneNumber, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final token = data['data']['token'];
          setToken(token);
          setPhoneNumber(phoneNumber);
          await getBalance(phoneNumber);
          await getTransactions(phoneNumber);
          setLoading(false);
          return {'success': true, 'data': data['data']};
        }
      }
      setLoading(false);
      return {'success': false, 'message': 'Identifiants incorrects'};
    } catch (e) {
      setLoading(false);
      return {'success': false, 'message': 'Erreur de connexion'};
    }
  }

  Future<Map<String, dynamic>> register(
    String phoneNumber,
    String email,
    String password,
    String role,
  ) async {
    setLoading(true);
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.register}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'phoneNumber': phoneNumber,
          'email': email,
          'password': password,
          'role': role,
        }),
      );

      setLoading(false);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final token = data['data']['token'];
          setToken(token);
          setPhoneNumber(phoneNumber);
          await getBalance(phoneNumber);
          await getTransactions(phoneNumber);
          return {'success': true, 'data': data['data']};
        }
        return {'success': false, 'message': data['message'] ?? 'Erreur'};
      }
      return {'success': false, 'message': 'Erreur lors de l\'inscription'};
    } catch (e) {
      setLoading(false);
      return {'success': false, 'message': 'Erreur de connexion'};
    }
  }

  Future<void> getBalance(String phone) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.balance.replaceAll('{phone}', phone)}',
        ),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          updateBalance((data['data'] ?? 0).toDouble());
        }
      }
    } catch (e) {
      debugPrint('Error getting balance: $e');
    }
  }

  Future<void> getTransactions(String phone) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.transactions.replaceAll('{phone}', phone)}',
        ),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final List<dynamic> list = data['data'] ?? [];
          updateTransactions(list.map((e) => Transaction.fromJson(e)).toList());
        }
      }
    } catch (e) {
      debugPrint('Error getting transactions: $e');
    }
  }

  Future<Map<String, dynamic>> transfer(
    String senderPhone,
    String receiverPhone,
    double amount,
  ) async {
    setLoading(true);
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.transfer}'),
        headers: _getHeaders(),
        body: json.encode({
          'senderPhone': senderPhone,
          'receiverPhone': receiverPhone,
          'amount': amount,
        }),
      );

      setLoading(false);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          await getBalance(senderPhone);
          await getTransactions(senderPhone);
          return {'success': true, 'message': 'Transfert réussi'};
        }
        return {'success': false, 'message': data['message'] ?? 'Erreur'};
      }
      return {'success': false, 'message': 'Erreur lors du transfert'};
    } catch (e) {
      setLoading(false);
      return {'success': false, 'message': 'Erreur de connexion'};
    }
  }

  Future<Map<String, dynamic>> getBills(String walletCode) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.bills.replaceAll('{code}', walletCode)}',
        ),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final List<dynamic> list = data['data'] ?? [];
          updateFactures(list.map((e) => Facture.fromJson(e)).toList());
          return {'success': true, 'data': _factures};
        }
      }
      return {'success': false, 'message': 'Erreur'};
    } catch (e) {
      return {'success': false, 'message': 'Erreur de connexion'};
    }
  }

  Future<Map<String, dynamic>> payBills(
    String phoneNumber,
    String serviceName,
    List<String> references,
  ) async {
    setLoading(true);
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.payBills}'),
        headers: _getHeaders(),
        body: json.encode({
          'phoneNumber': phoneNumber,
          'serviceName': serviceName,
          'factureReferences': references,
        }),
      );

      setLoading(false);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          await getBalance(phoneNumber);
          await getTransactions(phoneNumber);
          return {'success': true, 'message': 'Paiement réussi'};
        }
        return {'success': false, 'message': data['message'] ?? 'Erreur'};
      }
      return {'success': false, 'message': 'Erreur lors du paiement'};
    } catch (e) {
      setLoading(false);
      return {'success': false, 'message': 'Erreur de connexion'};
    }
  }

  void logout() {
    _token = null;
    _phoneNumber = null;
    _balance = 0;
    _transactions = [];
    _factures = [];
    notifyListeners();
  }
}