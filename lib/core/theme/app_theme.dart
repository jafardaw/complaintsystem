import 'package:flutter/material.dart';
import '../style/color.dart';

class AppTheme {
  // ===== LIGHT =====
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    colorScheme: ColorScheme.fromSeed(
      seedColor: Palette.primary,
      brightness: Brightness.light,
    ),

    scaffoldBackgroundColor: Palette.backgroundColor,

    inputDecorationTheme: _inputTheme(false),
    elevatedButtonTheme: _buttonTheme(false),
  );

  // ===== DARK =====
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    colorScheme: ColorScheme.fromSeed(
      seedColor: Palette.primary,
      brightness: Brightness.dark,
    ),

    scaffoldBackgroundColor: const Color(0xFF121212),

    inputDecorationTheme: _inputTheme(true),
    elevatedButtonTheme: _buttonTheme(true),
  );

  // ===== Shared =====
  static InputDecorationTheme _inputTheme(bool dark) {
    return InputDecorationTheme(
      filled: true,
      fillColor: dark ? const Color(0xFF1E1E1E) : Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: _border(dark),
      enabledBorder: _border(dark),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Palette.primary, width: 1.5),
      ),
      floatingLabelBehavior: FloatingLabelBehavior.never,
    );
  }

  static ElevatedButtonThemeData _buttonTheme(bool dark) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Palette.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  static CardTheme _cardTheme(bool dark) {
    return CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: dark ? const Color(0xFF1E1E1E) : Colors.white,
    );
  }

  static OutlineInputBorder _border(bool dark) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: dark ? Colors.grey.shade700 : Colors.grey.shade400,
      ),
    );
  }
}
