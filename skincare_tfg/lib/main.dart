import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'providers/theme_provider.dart';
import 'providers/locale_provider.dart';
import 'screens/about_screen.dart';
import 'screens/edit_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/my_products_screen.dart';
import 'themes.dart';
import 'widgets/bottom_app_bar.dart';
import 'constants/app_constants.dart';
import '../l10n/app_localizations.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
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
          
          // 🎨 Temas - CORREGIDO (solo un theme, un darkTheme)
          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,
          themeMode: themeProvider.themeMode,
          
          // 🌍 Internacionalización
          locale: localeProvider.locale,
          supportedLocales: const [
            Locale('es', ''), // Español
            Locale('en', ''), // Inglés
          ],
          localizationsDelegates: const [
            // Aquí irán tus delegates de traducción
            AppLocalizations.delegate,
            // Por ahora usamos los básicos
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          
          // Rutas
          initialRoute: AppConstants.routeLogin,
          routes: {
            AppConstants.routeRegister: (context) => const RegisterScreen(),
            AppConstants.routeLogin: (context) => const LoginScreen(),
            AppConstants.routeHome: (context) => const BottomNavBar(),
            AppConstants.routeProfile: (context) => const BottomNavBar(initialIndex: 4),
            AppConstants.routeSettings: (context) => const SettingsScreen(),
            AppConstants.routeEdit: (context) => const EditScreen(),
            AppConstants.routeAbout: (context) => const AboutScreen(),
            AppConstants.routeMyProducts: (context) => const MyProductsScreen(),
          },
        );
      },
    );
  }
}