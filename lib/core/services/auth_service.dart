import 'package:shared_preferences/shared_preferences.dart';
import '../network/api_client.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient(baseUrl: 'http://10.0.2.2:5269/api');

  Future<bool> login(String email, String password) async {
    try {
      final response = await _apiClient.post('/Auth/login', body: {
        'email': email,
        'password': password,
      });

      if (response != null && response['token'] != null) {
        _apiClient.setToken(response['token']);

        final prefs = await SharedPreferences.getInstance();

        await prefs.setString('auth_token', response['token']);
        await prefs.setString('refresh_token', response['refreshToken']);
        await prefs.setString('username', response['username'] ?? '');
        await prefs.setString('email', response['email'] ?? '');
        await prefs.setString('bio', response['bio'] ?? '');
        await prefs.setString('imageUrl', response['imageUrl'] ?? '');

        return true;
      }
      return false;
    } catch (e) {
      print("Login Hatası: $e");
      return false;
    }
  }

  Future<Map<String, String>> getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'username': prefs.getString('username') ?? 'Misafir',
      'email': prefs.getString('email') ?? '',
      'bio': prefs.getString('bio') ?? '',
      'imageUrl': prefs.getString('imageUrl') ?? '',
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

  Future<bool> updateProfile({
    required String username,
    required String bio,
    required String imageUrl,
  }) async {
    try {
      final response = await _apiClient.put(
        '/Users/update-profile',
        body: {
          'username': username,
          'bio': bio,
          'imageUrl': imageUrl,
        },
      );

      if (response != null && response['success'] == true) {
        await updateLocalUserData(username, bio, imageUrl);
        return true;
      }
      return false;
    } catch (e) {
      print("Profil güncellenemedi: $e");
      rethrow;
    }
  }

  Future<void> updateLocalUserData(String username, String bio, String imageUrl) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('username', username);
    await prefs.setString('bio', bio);
    await prefs.setString('imageUrl', imageUrl);

    print("Lokal veri güncellendi -> Bio: $bio");
  }

  Future<String?> uploadProfileImage(String filePath) async {
    return await _apiClient.uploadImage(filePath);
  }
}