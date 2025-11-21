import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;

  String? _token;

  ApiClient({required this.baseUrl});

  void setToken(String? token) {
    _token = token;
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

  Future<dynamic> get(String endpoint) async {
    final uri = Uri.parse('$baseUrl$endpoint');

    final response = await http.get(uri, headers: _getHeaders());

    return _processResponse(response);
  }

  Future<dynamic> post(String endpoint, {dynamic body}) async {
    final uri = Uri.parse('$baseUrl$endpoint');

    final response = await http.post(
      uri,
      headers: _getHeaders(),
      body: body != null ? json.encode(body) : null,
    );

    return _processResponse(response);
  }

  dynamic _processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;

      try {
        return json.decode(response.body);
      } catch (e) {
        throw Exception('JSON çözümleme hatası: $e');
      }
    } else {
      switch (response.statusCode) {
        case 400:
          final errorData = json.decode(response.body);
          throw Exception(errorData['message'] ?? 'Hatalı istek (400).');
        case 401:
          throw Exception('Yetkisiz erişim (401). Oturum açmanız gerekebilir.');
        case 403:
          throw Exception('Erişim reddedildi (403).');
        case 404:
          throw Exception('Kaynak bulunamadı (404).');
        case 500:
          throw Exception('Sunucu hatası (500).');
        default:
          throw Exception('API hatası: ${response.statusCode}');
      }
    }
  }
}