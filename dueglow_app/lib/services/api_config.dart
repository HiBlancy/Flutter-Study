import 'package:flutter/foundation.dart';

class ApiConfig {

  static const String _baseUrlWeb = 'https://backend-dueglow.onrender.com';
  static const String _baseUrlMobile = 'http://192.168.1.21:3000';

  static String get baseUrl {

    if (kIsWeb) {
      return _baseUrlWeb;
    }
    return _baseUrlMobile;
  }

  static String getRegisterUrl() => '$baseUrl/users/register';
  static String getLoginUrl() => '$baseUrl/users/login';
  static String getProfileUrl() => '$baseUrl/users/me';
  static String getUploadProfileImageUrl() => '$baseUrl/users/me/upload-image';
  static String getDeleteProfileImageUrl() => '$baseUrl/users/me/image';


  static String getProductsUrl() => '$baseUrl/products';
  static String getProductStatsUrl() => '$baseUrl/products/stats/summary';
  static String getExpiredProductsUrl() => '$baseUrl/products/expired/all';
  static String getExpiringSoonUrl({int days = 30}) => '$baseUrl/products/expiring/soon?days=$days';
  static String getMonthlyHistoryUrl() => '$baseUrl/products/stats/monthly-history';
  static String getYearlyOverviewUrl() => '$baseUrl/products/stats/yearly-overview';
  static String getCurrentMonthStatsUrl() => '$baseUrl/products/stats/current-month';

  static String getRoutinesUrl() => '$baseUrl/routines';
}