import 'package:flutter/material.dart';
import 'package:podkes_app/core/config/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Bunu ekle
import 'my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppConfig.initialize(Environment.dev);

  final prefs = await SharedPreferences.getInstance();
  final savedToken = prefs.getString('auth_token');

  runApp(MyApp(initialToken: savedToken));
}