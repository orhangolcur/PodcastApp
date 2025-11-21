enum Environment { dev, prod }

class AppConfig {
  final String baseUrl;

  AppConfig._internal({required this.baseUrl});

  static AppConfig? _instance;

  static void initialize(Environment env) {
    if (_instance != null) return;

    switch (env) {
      case Environment.dev:
        _instance = AppConfig._internal(
          baseUrl: 'http://10.0.2.2:5269/api',
        );
        break;

      case Environment.prod:
        _instance = AppConfig._internal(
          baseUrl: 'https://listen-api-prod.listennotes.com/api/v2',
        );
        break;
    }
  }

  static AppConfig get instance {
    if (_instance == null) {
      throw Exception('AppConfig is not initialized. Call AppConfig.initialize(env) first.');
    }
    return _instance!;
  }
}