import 'package:flutter/foundation.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _error;
  bool _isAuthenticated = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _isAuthenticated;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    if (email == 'test@test.com' && password == 'password') {
      _user = User(
        id: '1',
        name: 'John Doe',
        email: email,
        phone: '+1 234 567 8900',
        address: '123 Main Street, New York, NY 10001',
      );
      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } else if (email.isNotEmpty && password.length >= 6) {
      _user = User(
        id: '1',
        name: 'Guest User',
        email: email,
        phone: '+1 234 567 8900',
        address: '123 Main Street, New York, NY 10001',
      );
      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _error = 'Invalid email or password';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signup(String name, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    if (email.isNotEmpty && password.length >= 6 && name.isNotEmpty) {
      _user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
      );
      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _error = 'Please fill all fields correctly';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _user = null;
    _isAuthenticated = false;
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void updateUser(User updatedUser) {
    _user = updatedUser;
    notifyListeners();
  }
}