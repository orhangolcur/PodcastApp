import 'dart:async'; // 👈 Completer için bunu ekle
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  final String baseUrl;
  String? _token;
  Completer<bool>? _refreshCompleter;

  ApiClient({required this.baseUrl});

  void setToken(String? token) {
    _token = token;
  }

  Future<dynamic> get(String path) async {
    return _requestWithRetry(() async {
      final uri = Uri.parse('$baseUrl$path');
      return await http.get(uri, headers: _getHeaders());
    });
  }

  Future<dynamic> post(String path, {Map<String, dynamic>? body}) async {
    return _requestWithRetry(() async {
      final uri = Uri.parse('$baseUrl$path');
      return await http.post(uri, headers: _getHeaders(), body: json.encode(body));
    });
  }

  Future<dynamic> put(String path, {Map<String, dynamic>? body}) async {
    return _requestWithRetry(() async {
      final uri = Uri.parse('$baseUrl$path');
      return await http.put(uri, headers: _getHeaders(), body: json.encode(body));
    });
  }

  Future<String?> uploadImage(String filepath) async {
    final uri = Uri.parse('$baseUrl/Files/upload');
    var request = http.MultipartRequest('POST', uri);
    if (_token != null) request.headers['Authorization'] = 'Bearer $_token';

    var extension = filepath.split('.').last.toLowerCase();
    var mediaType = MediaType('image', extension == 'png' ? 'png' : 'jpeg');

    request.files.add(await http.MultipartFile.fromPath('file', filepath, contentType: mediaType));

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200) {
        return json.decode(response.body)['url'];
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> _requestWithRetry(Future<http.Response> Function() requestFn) async {
    var response = await requestFn();

    if (response.statusCode == 401) {
      print("⚠️ Token süresi dolmuş! (401)");

      if (_refreshCompleter != null) {
        print("⏳ Zaten yenileme yapılıyor, sırada bekleniyor...");
        bool success = await _refreshCompleter!.future;

        if (success) {
          print("✅ Bekleme bitti, token yenilenmiş. İstek tekrar ediliyor...");
          return _processResponse(await requestFn());
        } else {
          print("❌ Bekleme bitti ama yenileme başarısız olmuş.");
          return null;
        }
      }

      _refreshCompleter = Completer<bool>();

      print("🔄 Yenileme işlemi başlatılıyor...");
      bool refreshed = await _refreshToken();

      _refreshCompleter?.complete(refreshed);
      _refreshCompleter = null;

      if (refreshed) {
        print("✅ Token yenilendi! İstek tekrar ediliyor...");
        response = await requestFn();
      } else {
        print("❌ Token yenilenemedi. Çıkış yapılmalı.");
      }
    }

    return _processResponse(response);
  }

  Future<bool> _refreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString('refresh_token');
      final accessToken = prefs.getString('auth_token');

      if (refreshToken == null) return false;

      final uri = Uri.parse('$baseUrl/Auth/refresh-token');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'accessToken': accessToken ?? "",
          'refreshToken': refreshToken
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['success'] == true) {
          final newToken = data['accessToken'];
          final newRefreshToken = data['refreshToken'];

          await prefs.setString('auth_token', newToken);
          if (newRefreshToken != null) {
            await prefs.setString('refresh_token', newRefreshToken);
          }

          setToken(newToken);
          return true;
        }
      }
      return false;
    } catch (e) {
      print("Refresh Error: $e");
      return false;
    }
  }

  Map<String, String> _getHeaders() {
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  dynamic _processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return json.decode(utf8.decode(response.bodyBytes));
    } else {
      print("API Error: ${response.statusCode} - ${response.body}");
      return null;
    }
  }
}