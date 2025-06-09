import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'themes/app_theme.dart';

void main() {
  runApp(const NouriApp());
}

class NouriApp extends StatelessWidget {
  const NouriApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nouri',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
