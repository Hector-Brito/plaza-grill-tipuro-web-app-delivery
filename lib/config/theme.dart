import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors
  static const Color primaryRed = Color(0xFFB80035);
  static const Color primaryYellow = Color(0xFFFBBF24);
  static const Color darkText = Color(0xFF1B1B1B);
  static const Color background = Color(0xFFF9F9F9);
  static const Color cardBackground = Colors.white;
  static const Color textMuted = Color(0xFF5C3F40);
  static const Color hintText = Color(0xFF906F70);
  static const Color errorRed = Colors.red;
  static const Color successGreen = Color(0xFF25D366);
  static const Color disabledBackground = Color(0xFFE5BDBE);

  // Borders
  static const BorderSide defaultBorderSide =
      BorderSide(color: darkText, width: 1.5);
  static const BorderSide thickBorderSide =
      BorderSide(color: darkText, width: 2.0);

  static ThemeData get lightTheme {
    final baseTheme = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      primaryColor: primaryRed,
      colorScheme: const ColorScheme.light(
        primary: primaryRed,
        secondary: primaryYellow,
        surface: cardBackground,
        error: errorRed,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        iconTheme: IconThemeData(color: darkText),
        titleTextStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: primaryRed,
          letterSpacing: -0.5,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryRed,
          foregroundColor: Colors.white,
          disabledBackgroundColor: disabledBackground,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: thickBorderSide,
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );

    return baseTheme.copyWith(
      textTheme: GoogleFonts.interTextTheme(baseTheme.textTheme),
    );
  }
}
