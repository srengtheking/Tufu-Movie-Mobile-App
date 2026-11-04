import 'package:flutter/foundation.dart';

import '../data/auth_repository.dart';
import '../models/app_user.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

enum RegisterResult { signedIn, createdOnly, failed }

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository;

  AuthProvider({AuthRepository? repository})
    : _repository = repository ?? AuthRepository();

  AuthStatus status = AuthStatus.unknown;
  AppUser? user;
  bool isLoading = false;
  String? errorMessage;

  /// Field the current error belongs to ('email', 'password', 'name').
  String? errorField;

  bool get isAuthenticated => status == AuthStatus.authenticated;

  Future<void> checkAuth() async {
    try {
      user = await _repository.restoreSession();
    } catch (_) {
      user = null;
    }
    status = user == null
        ? AuthStatus.unauthenticated
        : AuthStatus.authenticated;
    notifyListeners();
  }

  void clearError() {
    if (errorMessage == null) return;
    errorMessage = null;
    errorField = null;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _start();
    try {
      user = await _repository.login(email: email, password: password);
      status = AuthStatus.authenticated;
      return true;
    } catch (e) {
      _fail(e);
      return false;
    } finally {
      _finish();
    }
  }

  /// Creates the account, then signs straight in. If the account is created
  /// but sign-in fails (e.g. no login endpoint yet), returns [createdOnly].
  Future<RegisterResult> register(
    String name,
    String email,
    String password,
  ) async {
    _start();
    try {
      await _repository.register(name: name, email: email, password: password);
    } catch (e) {
      _fail(e);
      _finish();
      return RegisterResult.failed;
    }
    try {
      user = await _repository.login(email: email, password: password);
      status = AuthStatus.authenticated;
      return RegisterResult.signedIn;
    } catch (_) {
      return RegisterResult.createdOnly;
    } finally {
      _finish();
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    user = null;
    status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  void _start() {
    isLoading = true;
    errorMessage = null;
    errorField = null;
    notifyListeners();
  }

  void _fail(Object e) {
    if (e is AuthException) {
      errorMessage = e.message;
      errorField = e.field;
    } else {
      errorMessage = 'Something went wrong. Please try again.';
    }
  }

  void _finish() {
    isLoading = false;
    notifyListeners();
  }
}
