import 'package:flutter/material.dart';

import '../data/auth_repository.dart';
import '../../../core/storage/token_storage.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository = AuthRepository();

  bool isLoading = false;
  bool isAuthenticated = false;
  String? errorMessage;

  Future<void> checkAuth() async {
    final token = await TokenStorage.getToken();

    isAuthenticated = token != null && token.isNotEmpty;

    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      await _repository.login(email: email, password: password);

      isAuthenticated = true;
      return true;
    } catch (e) {
      errorMessage = 'Login failed. Please check your credentials.';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register(String name, String email, String password) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      await _repository.register(name: name, email: email, password: password);

      return true;
    } catch (e) {
      errorMessage = 'Registration failed. Please try again.';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _repository.logout();

    isAuthenticated = false;
    notifyListeners();
  }
}
