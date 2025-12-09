import 'package:shared_preferences/shared_preferences.dart';
import '../network/api_client.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient(baseUrl: 'http://10.0.2.2:5269/api');

  Future<void> login(String email, String password) async {

    final response = await _apiClient.post('/Auth/login', body: {
      'email': email,
      'password': password,
    });

    if (response != null && response['token'] != null) {
      _apiClient.setToken(response['token']);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', response['token']);
      await prefs.setString('user_email', response['email'] ?? '');
      await prefs.setString('user_name', response['username'] ?? '');
    }
  }

  Future<Map<String, String>> getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'email': prefs.getString('user_email') ?? 'Guest',
      'username': prefs.getString('user_name') ?? 'Guest User',
    };
  }

  Future<void> logout() async {
    _apiClient.setToken(null);
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<void> register(String username, String email, String password) async {
    await _apiClient.post('/Auth/register', body: {
      'username': username,
      'email': email,
      'password': password,
      'confirmPassword': password,
    });
  }
}