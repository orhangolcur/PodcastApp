import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  final String baseUrl;
  String? _token;
  Completer<bool>? _refreshCompleter;
  static const String kAccessTokenKey = 'auth_token';
  static const String kRefreshTokenKey = 'refresh_token';

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
        bool success = await _refreshCompleter!.future;
        if (success) {
          return _processResponse(await requestFn());
        } else {
          return null;
        }
      }

      _refreshCompleter = Completer<bool>();
      bool refreshed = await _refreshToken();
      _refreshCompleter?.complete(refreshed);
      _refreshCompleter = null;

      if (refreshed) {
        response = await requestFn();
      }
    }
    return _processResponse(response);
  }

  Future<bool> _refreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString(kRefreshTokenKey);
      final accessToken = prefs.getString(kAccessTokenKey);

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
          final newToken = data['accessToken'] ?? data['token'];
          final newRefreshToken = data['refreshToken'];

          await prefs.setString(kAccessTokenKey, newToken);
          if (newRefreshToken != null) {
            await prefs.setString(kRefreshTokenKey, newRefreshToken);
          }
          setToken(newToken);
          return true;
        }
      }
      return false;
    } catch (e) {
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
    String responseBody = utf8.decode(response.bodyBytes);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (responseBody.isEmpty) return null;
      return json.decode(responseBody);
    }

    else {
      String errorMessage = "Bir hata oluştu (${response.statusCode})";

      try {
        if (responseBody.isNotEmpty) {
          dynamic decoded = json.decode(responseBody);
          if (decoded is Map && decoded['message'] != null) {
            errorMessage = decoded['message'];
          } else if (decoded is String) {
            errorMessage = decoded;
          } else if (decoded is List && decoded.isNotEmpty) {
            errorMessage = decoded.first.toString();
          }
        }
      } catch (e) {
        if (responseBody.isNotEmpty) errorMessage = responseBody;
      }

      print("❌ API Error: $errorMessage");
      throw Exception(errorMessage);
    }
  }
}