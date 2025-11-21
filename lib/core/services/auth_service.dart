
import '../network/api_client.dart';

class AuthService {
  // Backend adresin (Emülatör için 10.0.2.2)
  // Backend'inin HTTP portunu kontrol et (5000 olabilir, 5123 olabilir)
  final ApiClient _apiClient = ApiClient(baseUrl: 'http://10.0.2.2:5269/api');

  Future<bool> login(String email, String password) async {
    try {
      final response = await _apiClient.post('/Auth/login', body: {
        'email': email,
        'password': password,
      });

      if (response != null && response['token'] != null) {
        print('Giriş Başarılı! Token: ${response['token']}');

        _apiClient.setToken(response['token']);

        return true;
      }
      return false;
    } catch (e) {
      print('Login Hatası: $e');
      return false;
    }
  }

  Future<bool> register(String username, String email, String password) async {
    try {
      final response = await _apiClient.post('/Auth/register', body: {
        'username': username,
        'email': email,
        'password': password,
        'confirmPassword': password,
      });

      print('Kayıt Başarılı: $response');
      return true;
    } catch (e) {
      print('Register Hatası: $e');
      return false;
    }
  }
}