import 'package:flutter/material.dart';

class AppTheme {
  // --- COLOR PALETTE ---
  // Primary (Purple/Indigo)
  static const Color _primaryLight = Color(0xFF6366F1);
  static const Color _primaryDark = Color(0xFF818CF8);

  // Secondary (Amber/Orange)
  static const Color _secondaryLight = Color(0xFFF59E0B);
  static const Color _secondaryDark = Color(0xFFFBBF24);

  // Error (Red)
  static const Color _errorLight = Color(0xFFDC2626);
  static const Color _errorDark = Color(0xFFEF4444);

  // Backgrounds
  static const Color _bgLight = Color(0xFFF8FAFC);
  static const Color _bgDark = Color(0xFF0F172A); // Slate 900

  // Surfaces (Cards, Dialogs)
  static const Color _surfaceLight = Colors.white;
  static const Color _surfaceDark = Color(0xFF1E293B); // Slate 800

  // Text
  static const Color _textPrimaryLight = Color(0xFF0F172A);
  static const Color _textSecondaryLight = Color(0xFF475569);

  static const Color _textPrimaryDark = Color(0xFFF1F5F9);
  static const Color _textSecondaryDark = Color(0xFF94A3B8);

  // --- LIGHT THEME ---
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _primaryLight,
      brightness: Brightness.light,
      primary: _primaryLight,
      secondary: _secondaryLight,
      error: _errorLight,
      surface: _surfaceLight,
      onSurface: _textPrimaryLight,
      background: _bgLight,
      onBackground: _textPrimaryLight,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: _bgLight,

      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: _textPrimaryLight,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: _textPrimaryLight,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          color: _textPrimaryLight,
          fontWeight: FontWeight.w600,
        ),
        headlineLarge: TextStyle(
          color: _textPrimaryLight,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: _textPrimaryLight,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          color: _textPrimaryLight,
          fontWeight: FontWeight.w500,
        ),
        titleLarge: TextStyle(
          color: _textPrimaryLight,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: _textPrimaryLight,
          fontWeight: FontWeight.w500,
        ),
        titleSmall: TextStyle(
          color: _textPrimaryLight,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(color: _textPrimaryLight),
        bodyMedium: TextStyle(color: _textPrimaryLight),
        bodySmall: TextStyle(color: _textSecondaryLight),
        labelLarge: TextStyle(
          color: _textPrimaryLight,
          fontWeight: FontWeight.w500,
        ),
      ),

      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: _surfaceLight,
        foregroundColor: _textPrimaryLight,
        elevation: 0,
        scrolledUnderElevation: 2,
        centerTitle: true,
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: _surfaceLight,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primaryLight, width: 2),
        ),
        labelStyle: const TextStyle(color: _textSecondaryLight),
        hintStyle: TextStyle(color: _textSecondaryLight.withOpacity(0.7)),
      ),

      // Button Themes
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: _primaryLight,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _primaryLight,
          side: const BorderSide(color: _primaryLight),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(color: _textPrimaryLight),
    );
  }

  // --- DARK THEME ---
  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _primaryDark,
      brightness: Brightness.dark,
      primary: _primaryDark,
      secondary: _secondaryDark,
      error: _errorDark,
      surface: _surfaceDark,
      onSurface: _textPrimaryDark,
      background: _bgDark,
      onBackground: _textPrimaryDark,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: _bgDark,

      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: _textPrimaryDark,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: _textPrimaryDark,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          color: _textPrimaryDark,
          fontWeight: FontWeight.w600,
        ),
        headlineLarge: TextStyle(
          color: _textPrimaryDark,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: _textPrimaryDark,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          color: _textPrimaryDark,
          fontWeight: FontWeight.w500,
        ),
        titleLarge: TextStyle(
          color: _textPrimaryDark,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: _textPrimaryDark,
          fontWeight: FontWeight.w500,
        ),
        titleSmall: TextStyle(
          color: _textPrimaryDark,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(color: _textPrimaryDark),
        bodyMedium: TextStyle(color: _textPrimaryDark),
        bodySmall: TextStyle(color: _textSecondaryDark),
        labelLarge: TextStyle(
          color: _textPrimaryDark,
          fontWeight: FontWeight.w500,
        ),
      ),

      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: _bgDark, // Blend with scaffold
        foregroundColor: _textPrimaryDark,
        elevation: 0,
        scrolledUnderElevation: 2,
        centerTitle: true,
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: _surfaceDark,
        elevation:
            0, // Flat in dark mode usually looks better, or slight elevation
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: Colors.white.withOpacity(0.05),
          ), // Subtle borderss
        ),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF334155), // Slate 700
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primaryDark, width: 2),
        ),
        labelStyle: const TextStyle(color: _textSecondaryDark),
        hintStyle: TextStyle(color: _textSecondaryDark.withOpacity(0.7)),
      ),

      // Button Themes
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: _primaryDark,
          foregroundColor: Colors.white, // Text on primary
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _primaryDark,
          side: const BorderSide(color: _primaryDark),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(color: _textPrimaryDark),
    );
  }
}
