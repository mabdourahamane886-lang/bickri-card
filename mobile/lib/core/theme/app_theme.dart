import 'package:flutter/material.dart';

class AppTheme {
  static const navy = Color(0xFF071B3A);
  static const blue = Color(0xFF0D47A1);
  static const gold = Color(0xFFD4AF37);
  static const surface = Color(0xFFF5F7FB);

  static ThemeData light() => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: surface,
    colorScheme: ColorScheme.fromSeed(seedColor: blue),
    appBarTheme: const AppBarTheme(
      backgroundColor: surface,
      foregroundColor: navy,
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: blue)),
    ),
  );
}
