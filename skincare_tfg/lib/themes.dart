
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemes {


  static const ColorScheme _lightHighContrastScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xff4b193c),
    surfaceTint: Color(0xff854b71),
    onPrimary: Color(0xffffffff),
    primaryContainer: Color(0xff6d375b),
    onPrimaryContainer: Color(0xffffffff),
    secondary: Color(0xff3a2632),
    onSecondary: Color(0xffffffff),
    secondaryContainer: Color(0xff5a4250),
    onSecondaryContainer: Color(0xffffffff),
    tertiary: Color(0xff421c4c),
    onTertiary: Color(0xffffffff),
    tertiaryContainer: Color(0xff623a6b),
    onTertiaryContainer: Color(0xffffffff),
    error: Color(0xff600004),
    onError: Color(0xffffffff),
    errorContainer: Color(0xff98000a),
    onErrorContainer: Color(0xffffffff),
    surface: Color(0xfffff8f9),
    onSurface: Color(0xff000000),
    onSurfaceVariant: Color(0xff000000),
    outline: Color(0xff34292f),
    outlineVariant: Color(0xff52464c),
    shadow: Color(0xff000000),
    scrim: Color(0xff000000),
    inverseSurface: Color(0xff362e32),
    inversePrimary: Color(0xfff8b1dc),
  );




  static const ColorScheme _darkHighContrastScheme = ColorScheme(
    brightness: Brightness.dark,

    primary: Color(0xfff4add8),
    surfaceTint: Color(0xfff8b1dc),
    onPrimary: Color(0xff3a1a2f),

    primaryContainer: Color(0xffd9a3c8),
    onPrimaryContainer: Color(0xff1e0016),

    secondary: Color(0xffe8c9d8),
    onSecondary: Color(0xff2d1721),
    secondaryContainer: Color(0xffcfb3c2),
    onSecondaryContainer: Color(0xff160611),

    tertiary: Color(0xffe8d5f2),
    onTertiary: Color(0xff3a1f45),
    tertiaryContainer: Color(0xffd4bfe8),
    onTertiaryContainer: Color(0xff1a0023),

    error: Color(0xffffb4ab),
    onError: Color(0xff5a1c1f),
    errorContainer: Color(0xffff8a7f),
    onErrorContainer: Color(0xff220001),

    surface: Color(0xff1a1419),
    onSurface: Color(0xfff4eff3),
    onSurfaceVariant: Color(0xffe8d5e0),

    outline: Color(0xffd9a3c8),
    outlineVariant: Color(0xffb095a8),
    shadow: Color(0xff000000),
    scrim: Color(0xff000000),
    inverseSurface: Color(0xffeddfe4),
    inversePrimary: Color(0xff6b355a),
  );



  static ThemeData _buildTheme(ColorScheme colorScheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: colorScheme.brightness,

      textTheme: TextTheme(
        displayLarge: GoogleFonts.crimsonText(
          fontSize: 40,
          fontWeight: FontWeight.w700,
          color: colorScheme.onSurface,
        ),
        displayMedium: GoogleFonts.crimsonText(
          fontSize: 34,
          fontWeight: FontWeight.w700,
          color: colorScheme.onSurface,
        ),
        displaySmall: GoogleFonts.crimsonText(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
        headlineLarge: GoogleFonts.sora(
          fontSize: 26,
          fontWeight: FontWeight.w700,
          color: colorScheme.onSurface,
        ),
        headlineMedium: GoogleFonts.sora(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
        headlineSmall: GoogleFonts.sora(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
        titleLarge: GoogleFonts.sora(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
        titleMedium: GoogleFonts.sora(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
        titleSmall: GoogleFonts.sora(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
        bodyLarge: GoogleFonts.lato(
          fontSize: 17,
          color: colorScheme.onSurface,
          height: 1.55,
        ),
        bodyMedium: GoogleFonts.lato(
          fontSize: 15,
          color: colorScheme.onSurface,
          height: 1.5,
        ),
        bodySmall: GoogleFonts.lato(
          fontSize: 13,
          color: colorScheme.onSurfaceVariant,
          height: 1.45,
        ),
        labelLarge: GoogleFonts.lato(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: colorScheme.onSurface,
        ),
        labelMedium: GoogleFonts.lato(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurfaceVariant,
        ),
        labelSmall: GoogleFonts.lato(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurfaceVariant,
        ),
      ),

      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.primary,
        titleTextStyle: GoogleFonts.crimsonText(
          fontSize: 30,
          fontWeight: FontWeight.w600,
          fontStyle: FontStyle.italic,
          color: colorScheme.primary,
        ),
        iconTheme: IconThemeData(color: colorScheme.primary),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          minimumSize: const Size(88, 48),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      scaffoldBackgroundColor: colorScheme.surface,
      dividerColor: colorScheme.outlineVariant.withValues(alpha: 0.35),

      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: colorScheme.surfaceContainerLow,
        margin: const EdgeInsets.all(8),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.22),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
        hintStyle: TextStyle(color: colorScheme.onSurfaceVariant.withValues(alpha: 0.8)),
        prefixIconColor: colorScheme.onSurfaceVariant,
        suffixIconColor: colorScheme.onSurfaceVariant,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.8),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error, width: 1.8),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error, width: 2.2),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: colorScheme.inverseSurface,
        contentTextStyle: TextStyle(
          color: colorScheme.onInverseSurface,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }



  static ThemeData get lightTheme => _buildTheme(_lightHighContrastScheme);
  static ThemeData get darkTheme => _buildTheme(_darkHighContrastScheme);
}