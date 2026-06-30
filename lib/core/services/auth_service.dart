import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService extends ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  bool _isLoggedIn = false;
  String? _phoneNumber;

  bool get isLoggedIn => _isLoggedIn;
  String? get phoneNumber => _phoneNumber;

  AuthService() {
    _loadSession();
  }

  Future<void> _loadSession() async {
    final phone = await _storage.read(key: 'phone_number');
    if (phone != null) {
      _phoneNumber = phone;
      _isLoggedIn = true;
      notifyListeners();
    }
  }

  Future<void> login(String phone) async {
    await _storage.write(key: 'phone_number', value: phone);
    _phoneNumber = phone;
    _isLoggedIn = true;
    notifyListeners();
  }

  Future<void> logout() async {
    await _storage.delete(key: 'phone_number');
    _phoneNumber = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}
