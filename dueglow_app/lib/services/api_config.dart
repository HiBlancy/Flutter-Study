class ApiConfig {

  static const String baseUrl = 'https://backend-dueglow.onrender.com';

  static String getRegisterUrl() => '$baseUrl/users/register';
  static String getLoginUrl() => '$baseUrl/users/login';
  static String getProfileUrl() => '$baseUrl/users/me';
  /// [DELETE] Borra la cuenta del usuario (el backend debe implementarlo).
  static String getDeleteAccountUrl() => '$baseUrl/users/me';
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