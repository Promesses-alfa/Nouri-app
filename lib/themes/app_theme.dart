import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: const Color(0xFFFFF8F6),
      primaryColor: const Color(0xFFE2B6AC),
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFE2B6AC)),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        bodyMedium: TextStyle(fontSize: 16),
      ),
      fontFamily: 'Helvetica',
      useMaterial3: true,
    );
  }
}