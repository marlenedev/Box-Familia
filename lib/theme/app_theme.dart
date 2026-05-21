import 'package:flutter/material.dart';

class AppTheme {
  static const Color darkGreen = Color(0xFF18534F);

  static const Color green = Color(0xFF226D68);

  static const Color light = Color(0xFFECF8F6);

  static const Color yellow = Color(0xFFFEEAA1);

  static const Color orange = Color(0xFFD6955B);

  static ThemeData themeData = ThemeData(
    scaffoldBackgroundColor: light,

    colorScheme: ColorScheme.fromSeed(
      seedColor: green,
      primary: darkGreen,
      secondary: orange,
      surface: Colors.white,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: darkGreen,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: orange,
      foregroundColor: Colors.white,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: green,
        foregroundColor: Colors.white,

        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),

    cardTheme: CardThemeData(
      color: Colors.white,

      elevation: 2,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,

      fillColor: Colors.white,

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),

        borderSide: BorderSide.none,
      ),
    ),
  );
}
