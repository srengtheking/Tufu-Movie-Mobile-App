import '../../../core/network/api_client.dart';
import '../../../core/storage/token_storage.dart';
import '../models/auth_response.dart';

class AuthRepository {
  Future<void> login({required String email, required String password}) async {
    final response = await ApiClient.dio.post(
      '/auth/login',
      data: {'email': email, 'password': password},
    );

    final auth = AuthResponse.fromJson(response.data);
    await TokenStorage.saveToken(auth.accessToken);
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await ApiClient.dio.post(
      '/auth/register',
      data: {'name': name, 'email': email, 'password': password},
    );
  }

  Future<void> logout() async {
    await TokenStorage.clearToken();
  }
}
