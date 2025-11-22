import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design Tokens: Centralized colors, fonts, spacing, and transitions
class AppTokens {
  // ========== COLOR TOKENS ==========
  static const Color colorOrange = Color(0xFFED5833); // Primary orange
  static const Color colorBlack = Color(0xFF0D0D0D); // Deep black
  static const Color colorDarkGrey = Color(0xFF1A1A1A); // Dark grey
  static const Color colorLightGrey = Color(0xFFE3EEF1); // Light accent
  static const Color colorWhite = Colors.white;
  static const Color colorRed = Colors.red;
  static const Color colorTeal = Colors.teal;

  // ========== TYPOGRAPHY ==========
  static TextStyle get headingLarge => GoogleFonts.poppins(
        fontSize: 56,
        fontWeight: FontWeight.w700,
        color: colorWhite,
      );

  static TextStyle get headingMedium => GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: colorOrange,
      );

  static TextStyle get headingSmall => GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: colorWhite,
      );

  static TextStyle get bodyLarge => GoogleFonts.openSans(
        fontSize: 18,
        color: colorLightGrey,
      );

  static TextStyle get bodyMedium => GoogleFonts.openSans(
        fontSize: 15,
        color: colorWhite,
      );

  static TextStyle get bodySmall => GoogleFonts.openSans(
        fontSize: 12,
        color: colorLightGrey,
      );

  static TextStyle get labelLarge => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: colorWhite,
      );

  static TextStyle get labelSmall => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: colorLightGrey,
      );

  static TextStyle get priceTag => GoogleFonts.openSans(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: colorWhite,
      );

  // ========== SPACING SCALE ==========
  static const double spacing2xs = 4.0;
  static const double spacingXs = 8.0;
  static const double spacingSm = 12.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  static const double spacing2xl = 40.0;

  // ========== TRANSITION TIMINGS ==========
  static const Duration transitionFast = Duration(milliseconds: 200);
  static const Duration transitionNormal = Duration(milliseconds: 300);
  static const Duration transitionSlow = Duration(milliseconds: 500);
  static const Duration transitionVerySlow = Duration(milliseconds: 800);

  // ========== BORDER RADIUS ==========
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 28.0;

  // ========== RESPONSIVE BREAKPOINTS ==========
  static const double breakpointMobile = 320;
  static const double breakpointTablet = 768;
  static const double breakpointDesktop = 1024;
  static const double breakpointUltraWide = 1440;

  // ========== THEME DATA ==========
  static ThemeData get appTheme => ThemeData(
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: colorOrange,
          secondary: colorLightGrey,
          surface: colorDarkGrey,
        ),
        scaffoldBackgroundColor: colorBlack,
        appBarTheme: const AppBarTheme(
          backgroundColor: colorOrange,
          foregroundColor: colorWhite,
          elevation: 0,
        ),
        textTheme: GoogleFonts.poppinsTextTheme().copyWith(
          displayLarge: headingLarge,
          displayMedium: headingMedium,
          displaySmall: headingSmall,
          bodyLarge: bodyLarge,
          bodyMedium: bodyMedium,
          bodySmall: bodySmall,
          labelLarge: labelLarge,
          labelSmall: labelSmall,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorOrange,
            foregroundColor: colorWhite,
            padding: const EdgeInsets.symmetric(
              horizontal: spacing2xl,
              vertical: spacingMd,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radiusXl),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: colorWhite,
          ),
        ),
      );
}
