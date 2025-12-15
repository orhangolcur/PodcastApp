import 'package:shared_preferences/shared_preferences.dart';
import '../network/api_client.dart'; // Dosya yolunu kontrol et

class AuthService {
  final ApiClient _apiClient = ApiClient(baseUrl: 'http://10.0.2.2:5269/api');

  Future<bool> login(String email, String password) async {
    try {
      final response = await _apiClient.post('/Auth/login', body: {
        'email': email,
        'password': password,
      });

      String? token;
      if (response != null) {
        token = response['token'] ?? response['accessToken'];
        if (token == null && response['data'] != null) {
          token = response['data']['token'] ?? response['data']['accessToken'];
        }
      }

      if (token != null) {
        _apiClient.setToken(token);

        final prefs = await SharedPreferences.getInstance();

        await prefs.setString(ApiClient.kAccessTokenKey, token);

        // Refresh token varsa kaydet
        String? refreshToken = response['refreshToken'];
        if (refreshToken != null) {
          await prefs.setString(ApiClient.kRefreshTokenKey, refreshToken);
        }

        await prefs.setString('username', response['username'] ?? response['data']?['username'] ?? '');
        await prefs.setString('email', response['email'] ?? response['data']?['email'] ?? '');
        await prefs.setString('bio', response['bio'] ?? response['data']?['bio'] ?? '');
        await prefs.setString('imageUrl', response['imageUrl'] ?? response['data']?['imageUrl'] ?? '');

        return true;
      }
      return false;
    } catch (e) {
      String message = e.toString().replaceAll("Exception: ", "");
      throw Exception(message);
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
  }

  Future<String?> uploadProfileImage(String filePath) async {
    return await _apiClient.uploadImage(filePath);
  }

  Future<bool> forgotPassword(String email) async {
    try {
      final response = await _apiClient.post('/Auth/forgot-password', body: {
        'email': email,
      });

      if (response != null && response['success'] == true) {
        return true;
      }
      return false;
    } catch (e) {
      print("Forgot Password Hatası: $e");
      return false;
    }
  }

  Future<bool> resetPassword({
    required String email,
    required String token,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final response = await _apiClient.post('/Auth/reset-password', body: {
        'email': email,
        'resetToken': token,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      });

      if (response != null && response['success'] == true) {
        return true;
      }
      return false;
    } catch (e) {
      print("Reset Password Hatası: $e");
      return false;
    }
  }
}