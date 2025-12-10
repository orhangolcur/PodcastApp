import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;

  static String? _token;

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
    dynamic body;

    try {
      body = response.body.isNotEmpty ? json.decode(response.body) : null;
    } catch (e) {
      body = response.body;
    }

    switch (response.statusCode) {
      case 200:
      case 201:
        return body;

      case 400:
        if (body is Map && body['errors'] != null) {
          final errors = body['errors'];

          if (errors is List && errors.isNotEmpty) {
            throw Exception(errors.first.toString());
          }
          if (errors is String) {
            throw Exception(errors);
          }
        }
        throw Exception("Lütfen girdiğiniz bilgileri kontrol edin.");

      case 401:
        throw Exception("E-posta veya şifre hatalı.");
      case 403:
        throw Exception("Yetkisiz işlem.");
      case 500:
        print("Server Error Detayı: $body");
        throw Exception("Sunucu hatası. Lütfen daha sonra tekrar deneyin.");
      default:
        throw Exception("Bir hata oluştu: ${response.statusCode}");
    }
  }
}