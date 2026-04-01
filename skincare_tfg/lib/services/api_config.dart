import 'package:flutter/foundation.dart';

class ApiConfig {
  // Para Flutter Web (Chrome) usa localhost
  // Si tu backend corre en http://localhost:3000
  static const String _baseUrlWeb = 'http://localhost:3000';
  static const String _baseUrlMobile = 'http://192.168.1.32:3000'; // Para Android Emulator
  
  static String get baseUrl {
    // Detectar si es web
    if (kIsWeb) {
      return _baseUrlWeb;
    }
    // Para móvil (Android/iOS)
    return _baseUrlMobile;
  }
  
  //USER
  static String getRegisterUrl() => '$baseUrl/users/register';
  static String getLoginUrl() => '$baseUrl/users/login';
  static String getProfileUrl() => '$baseUrl/users/me';
  static String getUsersUrl() => '$baseUrl/users';
  static String getUserByIdUrl(String id) => '$baseUrl/users/$id';

  //PRODUCTS
  static String getProductsUrl() => '$baseUrl/products';
  static String getProductByIdUrl(String id) => '$baseUrl/products/$id';
  static String getProductStatsUrl() => '$baseUrl/products/stats/summary';
  static String getExpiredProductsUrl() => '$baseUrl/products/expired/all';
  static String getExpiringSoonUrl({int days = 30}) => '$baseUrl/products/expiring/soon?days=$days';
}