import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';
import '../../../core/storage/token_storage.dart';
import '../models/app_user.dart';

/// Signs users in and out and keeps the session in secure storage.
///
/// Pick the implementation with `--dart-define=AUTH_MODE=api|local`.
/// `local` (default) stores accounts on the device so the app works before
/// the backend has a login endpoint; `api` talks to Tufu-Movie-API.
abstract class AuthRepository {
  static const mode = String.fromEnvironment(
    'AUTH_MODE',
    defaultValue: 'local',
  );

  factory AuthRepository() =>
      mode == 'api' ? ApiAuthRepository() : LocalAuthRepository();

  /// Restores a saved session, or null when signed out.
  Future<AppUser?> restoreSession();

  Future<AppUser> login({required String email, required String password});

  /// Creates the account. Does not sign in.
  Future<void> register({
    required String name,
    required String email,
    required String password,
  });

  Future<void> logout();
}

/// Shared session persistence.
mixin _SessionStore {
  Future<AppUser?> restoreSession() async {
    final token = await TokenStorage.getToken();
    if (token == null || token.isEmpty) return null;
    final json = await TokenStorage.getUser();
    return json == null ? null : AppUser.fromJson(json);
  }

  Future<AppUser> saveSession(String token, AppUser user) async {
    await TokenStorage.saveToken(token);
    await TokenStorage.saveUser(user.toJson());
    return user;
  }

  Future<void> logout() => TokenStorage.clearToken();
}

// ---------------------------------------------------------------------------
// Real backend
// ---------------------------------------------------------------------------

class ApiAuthRepository with _SessionStore implements AuthRepository {
  final Dio _dio;

  ApiAuthRepository({Dio? dio}) : _dio = dio ?? ApiClient.dio;

  /// Expected contract (not yet implemented in Tufu-Movie-API):
  /// `POST /auth/login {email, password}` →
  /// `{accessToken | token, user?: {id, username, email}}`.
  @override
  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await _dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      final data = (res.data as Map).cast<String, dynamic>();
      final token =
          (data['accessToken'] ?? data['token'] ?? data['access_token'])
              ?.toString();
      if (token == null || token.isEmpty) {
        throw const AuthException('The server did not return a session.');
      }
      final userJson = data['user'];
      final user = userJson is Map
          ? AppUser.fromJson(userJson.cast<String, dynamic>())
          : AppUser(name: email.split('@').first, email: email);
      return await saveSession(token, user);
    } on DioException catch (e) {
      throw _mapError(e, onUnauthorized: 'Incorrect email or password.');
    }
  }

  /// `POST /users {username, email, password}` — UserController.create.
  @override
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      await _dio.post(
        '/users',
        data: {'username': name, 'email': email, 'password': password},
      );
    } on DioException catch (e) {
      throw _mapError(
        e,
        onConflict: 'An account with this email already exists.',
      );
    }
  }

  AuthException _mapError(
    DioException e, {
    String? onUnauthorized,
    String? onConflict,
  }) {
    switch (e.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return const AuthException(
          'Can\'t reach the server. Check your connection and try again.',
        );
      default:
        break;
    }
    final status = e.response?.statusCode;
    final serverMessage = _messageFrom(e.response?.data);
    if ((status == 401 || status == 403) && onUnauthorized != null) {
      return AuthException(onUnauthorized);
    }
    if (status == 409 && onConflict != null) {
      return AuthException(onConflict, field: 'email');
    }
    if (status == 404) {
      return const AuthException(
        'This feature isn\'t available on the server yet.',
      );
    }
    return AuthException(
      serverMessage ?? 'Something went wrong. Please try again.',
    );
  }

  static String? _messageFrom(Object? data) {
    if (data is Map) {
      final m = data['message'] ?? data['error'] ?? data['detail'];
      if (m is String && m.isNotEmpty) return m;
    }
    if (data is String && data.isNotEmpty && data.length < 200) return data;
    return null;
  }
}

// ---------------------------------------------------------------------------
// On-device demo accounts
// ---------------------------------------------------------------------------

class LocalAuthRepository with _SessionStore implements AuthRepository {
  static const _accountsKey = 'local_accounts';
  final _random = Random.secure();

  Future<Map<String, dynamic>> _accounts() async {
    final raw = await TokenStorage.read(_accountsKey);
    if (raw == null) return {};
    try {
      return (jsonDecode(raw) as Map).cast<String, dynamic>();
    } catch (_) {
      return {};
    }
  }

  static String _hash(String salt, String password) =>
      sha256.convert(utf8.encode('$salt:$password')).toString();

  String _randomHex(int bytes) => List.generate(
    bytes,
    (_) => _random.nextInt(256).toRadixString(16).padLeft(2, '0'),
  ).join();

  @override
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final key = email.toLowerCase();
    final accounts = await _accounts();
    if (accounts.containsKey(key)) {
      throw const AuthException(
        'An account with this email already exists.',
        field: 'email',
      );
    }
    final salt = _randomHex(16);
    accounts[key] = {
      'id': _randomHex(8),
      'name': name,
      'email': email,
      'salt': salt,
      'hash': _hash(salt, password),
    };
    await TokenStorage.write(_accountsKey, jsonEncode(accounts));
  }

  @override
  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final account = (await _accounts())[email.toLowerCase()];
    if (account is! Map ||
        _hash(account['salt'] as String, password) != account['hash']) {
      throw const AuthException('Incorrect email or password.');
    }
    final user = AppUser.fromJson(account.cast<String, dynamic>());
    return saveSession('local-${_randomHex(16)}', user);
  }
}
