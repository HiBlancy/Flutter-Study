import 'package:flutter/foundation.dart';

class ApiConfig {
  // Para Flutter Web (Chrome) usa localhost
  // Si tu backend corre en http://localhost:3000
  static const String _baseUrlWeb = 'http://localhost:3000';
  static const String _baseUrlMobile = 'http://10.0.2.2:3000'; // Para Android Emulator
  
  static String get baseUrl {
    // Detectar si es web
    if (kIsWeb) {
      return _baseUrlWeb;
    }
    // Para móvil (Android/iOS)
    return _baseUrlMobile;
  }
  
  static String getRegisterUrl() => '$baseUrl/users/register';
  static String getLoginUrl() => '$baseUrl/users/login';
  static String getProfileUrl() => '$baseUrl/users/me';
  static String getUsersUrl() => '$baseUrl/users';
  static String getUserByIdUrl(String id) => '$baseUrl/users/$id';
}