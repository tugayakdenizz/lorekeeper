import 'package:flutter/material.dart';

class AppTheme {
  static const navy = Color(0xFF0F172A);
  static const card = Color(0xFF1E293B);
  static const cardLight = Color(0xFF334155);
  static const gold = Color(0xFFD4AF37);

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: navy,
    colorScheme: ColorScheme.fromSeed(
      seedColor: gold,
      brightness: Brightness.dark,
    ),
  );
}