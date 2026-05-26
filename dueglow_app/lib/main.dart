import 'package:dueglow/screens/faqs_screen.dart';
import 'package:dueglow/screens/routines_screen.dart';
import 'package:dueglow/screens/scan_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'providers/theme_provider.dart';
import 'providers/locale_provider.dart';
import 'providers/notification_preferences_provider.dart';
import 'services/notification_service.dart';
import 'screens/about_screen.dart';
import 'screens/edit_screen.dart';
import 'screens/search_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/my_products_screen.dart';
import 'themes.dart';
import 'widgets/bottom_app_bar.dart';
import 'constants/app_constants.dart';
import '../l10n/app_localizations.dart';
import 'screens/auth_gate_screen.dart';
import 'models/tutorial_launch.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.instance.initialize();
  final initialTheme = await ThemeProvider.readInitialThemeMode();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(initial: initialTheme),
        ),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(
          create: (_) => NotificationPreferencesProvider()..load(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, LocaleProvider>(
      builder: (context, themeProvider, localeProvider, child) {

        return MaterialApp(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,

          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,
          themeMode: themeProvider.themeMode,

          locale: localeProvider.locale,
          supportedLocales: const [
            Locale('es', ''),
            Locale('en', ''),
            Locale('ru', ''),
          ],
          localizationsDelegates: const [

            AppLocalizations.delegate,

            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],


          initialRoute: AppConstants.routeSplash,
          routes: {
            AppConstants.routeRegister: (context) => const RegisterScreen(),
            AppConstants.routeSplash: (context) => const AuthGateScreen(),
            AppConstants.routeLogin: (context) => const LoginScreen(),
            AppConstants.routeHome: (context) {
              final args = ModalRoute.of(context)?.settings.arguments;
              final launch = args is TutorialLaunch ? args : null;
              return BottomNavBar(tutorialLaunch: launch);
            },
            AppConstants.routeProfile: (context) {
              final args = ModalRoute.of(context)?.settings.arguments;
              final launch = args is TutorialLaunch ? args : null;
              return BottomNavBar(initialIndex: 4, tutorialLaunch: launch);
            },
            AppConstants.routeSettings: (context) => const SettingsScreen(),
            AppConstants.routeScan: (context) => const ScanScreen(),
            AppConstants.routeSearch: (context) => const SearchScreen(),
            AppConstants.routeEdit: (context) => const EditScreen(),
            AppConstants.routeAbout: (context) => const AboutScreen(),
            AppConstants.routeMyProducts: (context) => const MyProductsScreen(),
            AppConstants.routeMyRoutines: (context) => const RoutinesScreen(),
            AppConstants.routeFAQs: (context) => const FAQsScreen()
          },
        );
      },
    );
  }
}