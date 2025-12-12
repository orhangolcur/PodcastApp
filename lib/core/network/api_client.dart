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

  Future<dynamic> put(String path, {Map<String, dynamic>? body}) async {
    final url = Uri.parse('$baseUrl$path');

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }

    print('PUT Request: $url');
    if (body != null) {
      print('Body: $body');
    }

    try {
      final response = await http.put(
        url,
        headers: headers,
        body: body != null ? json.encode(body) : null,
      );

      return _processResponse(response);
    } catch (e) {
      print("Network Error: $e");
      throw Exception("Bağlantı hatası. İnternetinizi kontrol edin.");
    }
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

  Future<String?> uploadImage(String filepath) async {
    final uri = Uri.parse('$baseUrl/Files/upload');

    var request = http.MultipartRequest('POST', uri);

    if (_token != null) {
      request.headers['Authorization'] = 'Bearer $_token';
    }

    request.files.add(await http.MultipartFile.fromPath('file', filepath));

    print("Resim yükleniyor... $uri");

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        print("Yükleme Başarılı: ${jsonResponse['url']}");
        return jsonResponse['url'];
      } else {
        print("Upload Hatası: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("Upload Exception: $e");
      return null;
    }
  }
}