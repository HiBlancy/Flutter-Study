
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

      textTheme: TextTheme(
        displayLarge: GoogleFonts.crimsonText(
          fontSize: 48,
          color: colorScheme.onSurface,
        ),
        displaySmall: GoogleFonts.crimsonText(
          fontSize: 30,
          color: colorScheme.onSurface,
        ),
        headlineMedium: GoogleFonts.sora(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
        headlineSmall: GoogleFonts.sora(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: colorScheme.primary,
        ),
        titleLarge: GoogleFonts.sora(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
        ),
        titleMedium: GoogleFonts.literata(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          color: colorScheme.primary,
        ),
        bodyLarge: GoogleFonts.lato(
          fontSize: 16,
          color: colorScheme.onSurface,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.lato(
          fontSize: 14,
          color: colorScheme.onSurface,
          height: 1.5,
        ),
        bodySmall: GoogleFonts.lato(
          fontSize: 12,
          color: colorScheme.onSurfaceVariant,
          height: 1.4,
        ),
        labelLarge: GoogleFonts.lato(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: colorScheme.primary,
        ),
      ),

      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,

        backgroundColor: colorScheme.brightness == Brightness.light
            ? Color(0xfffff8f9)
            : Color(0xff3a1a2f),
        foregroundColor: colorScheme.brightness == Brightness.light
            ? colorScheme.primary
            : Color(0xfff4add8),
        titleTextStyle: GoogleFonts.crimsonText(
          fontSize: 30,
          fontWeight: FontWeight.w600,
          fontStyle: FontStyle.italic,
          color: colorScheme.brightness == Brightness.light
              ? colorScheme.primary
              : Color(0xfff4add8),
        ),
        iconTheme: IconThemeData(
          color: colorScheme.brightness == Brightness.light
              ? colorScheme.primary
              : Color(0xfff4add8),
        ),
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

      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: colorScheme.surface,
        margin: const EdgeInsets.all(8),
      ),
    );
  }



  static ThemeData get lightTheme => _buildTheme(_lightHighContrastScheme);
  static ThemeData get darkTheme => _buildTheme(_darkHighContrastScheme);
}