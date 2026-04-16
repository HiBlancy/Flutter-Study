// themes.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemes {
  // ==================== PALETAS DE ALTO CONTRASTE ====================

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

  // ==================== TEMA OSCURO MEJORADO ====================
  // Colores más vibrantes y accesibles, AppBar con color

  static const ColorScheme _darkHighContrastScheme = ColorScheme(
    brightness: Brightness.dark,
    // Primario: Rosa/Magenta más claro y vibrante para oscuro
    primary: Color(0xfff4add8),
    surfaceTint: Color(0xfff8b1dc),
    onPrimary: Color(0xff3a1a2f), // Texto oscuro sobre primario claro
    // Contenedor primario: Rosa más saturada
    primaryContainer: Color(0xffd9a3c8),
    onPrimaryContainer: Color(0xff1e0016),
    // Secundario: Tonos cálidos complementarios
    secondary: Color(0xffe8c9d8),
    onSecondary: Color(0xff2d1721),
    secondaryContainer: Color(0xffcfb3c2),
    onSecondaryContainer: Color(0xff160611),
    // Terciario: Púrpura más vibrante
    tertiary: Color(0xffe8d5f2),
    onTertiary: Color(0xff3a1f45),
    tertiaryContainer: Color(0xffd4bfe8),
    onTertiaryContainer: Color(0xff1a0023),
    // Error: Rojo coral más visible
    error: Color(0xffffb4ab),
    onError: Color(0xff5a1c1f),
    errorContainer: Color(0xffff8a7f),
    onErrorContainer: Color(0xff220001),
    // Superficie: Gris oscuro con toque púrpura (no puro negro)
    surface: Color(0xff1a1419),
    onSurface: Color(0xfff4eff3),
    onSurfaceVariant: Color(0xffe8d5e0),
    // Outline: Colores definidos, no grises
    outline: Color(0xffd9a3c8),
    outlineVariant: Color(0xffb095a8),
    shadow: Color(0xff000000),
    scrim: Color(0xff000000),
    inverseSurface: Color(0xffeddfe4),
    inversePrimary: Color(0xff6b355a),
  );

  // ==================== GENERADOR DE TEMA ====================

  static ThemeData _buildTheme(ColorScheme colorScheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      
      // Tipografía: Sora para títulos, Lato para cuerpo
      textTheme: TextTheme(
        displayLarge: GoogleFonts.crimsonText(
          fontSize: 48,
          color: colorScheme.onSurface,
        ),
        displaySmall: GoogleFonts.crimsonText(
          fontSize: 24,
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
        // En modo oscuro: AppBar con color (primario), en claro: el primario original
        backgroundColor: colorScheme.brightness == Brightness.light 
            ? Color(0xfffff8f9)
            : Color(0xff3a1a2f), // Gris oscuro con toque púrpura (base del primario oscuro)
        foregroundColor: colorScheme.brightness == Brightness.light 
            ? colorScheme.primary 
            : Color(0xfff4add8), // Texto rosa claro en oscuro
        titleTextStyle: GoogleFonts.crimsonText(
          fontSize: 30,
          fontWeight: FontWeight.w600,
          fontStyle: FontStyle.italic,
          color: colorScheme.brightness == Brightness.light 
              ? colorScheme.primary 
              : Color(0xfff4add8), // Título rosa en oscuro
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

  // ==================== EXPOSICIÓN FINAL ====================

  static ThemeData get lightTheme => _buildTheme(_lightHighContrastScheme);
  static ThemeData get darkTheme => _buildTheme(_darkHighContrastScheme);
}