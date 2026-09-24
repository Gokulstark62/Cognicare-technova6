import 'api_client.dart';

/// Handles signup, login, logout, current user.
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final _api = ApiClient.instance;

  Future<Map<String, dynamic>> signup({
    required String email,
    required String password,
    required String fullName,
    String? phone,
    String role = 'caregiver',
  }) async {
    final response = await _api.post(
      '/auth/signup',
      withAuth: false,
      body: {
        'email': email,
        'password': password,
        'full_name': fullName,
        'phone': phone,
        'role': role,
      },
    );

    final token = response['access_token'] as String;
    await _api.saveToken(token);
    return response['user'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await _api.postForm(
      '/auth/login',
      {
        'grant_type': 'password',
        'username': email,
        'password': password,
      },
    );

    final token = response['access_token'] as String;
    await _api.saveToken(token);
    return response['user'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    final token = await _api.getToken();
    if (token == null) return null;
    try {
      return await _api.get('/auth/me');
    } catch (e) {
      await _api.clearToken();
      return null;
    }
  }

  Future<bool> isLoggedIn() async {
    final user = await getCurrentUser();
    return user != null;
  }

  Future<void> logout() async {
    await _api.clearToken();
  }
}