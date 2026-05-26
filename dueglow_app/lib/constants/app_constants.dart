class AppConstants {
  static const String appName = 'DueGlow';
  static const String version = '1.2.0';

  static const String routeSplash = '/';
  static const String routeLogin = '/login';
  static const String routeHome = '/home';
  static const String routeRegister = '/register';
  static const String routeProfile = '/profile';
  static const String routeScan = '/scan';
  static const String routeAdd = '/add';
  static const String routeSearch = '/search';
  static const String routeSettings = '/settings';
  static const String routeAbout = '/about';
  static const String routeEdit = '/edit';
  static const String routeMyProducts = '/my_products';
  static const String routeMyRoutines = '/routines';
  static const String routeFAQs = '/faqs';

  static const String prefUserEmail = 'user_email';
  static const String prefUserName = 'user_name';
  static const String prefUserId = 'user_id';
  static const String prefUserPhone = 'user_phone';
  static const String prefUserBD = 'user_birthday';
  static const String prefUserProfileImage = 'user_profile_image';
  static const String prefIsLoggedIn = 'is_logged_in';
  static const String prefOnboardingComplete = 'onboarding_complete';

  static const String prefNotificationsEnabled = 'notifications_enabled';
  static const String prefNotifExpiration = 'notif_expiration_enabled';
  static const String prefNotifRoutines = 'notif_routines_enabled';
  static const String prefNotifWeeklyDigest = 'notif_weekly_digest_enabled';

  /// Days before expiration when a reminder is sent.
  static const List<int> expirationReminderDays = [30, 25, 20, 15, 10, 5, 0];
}