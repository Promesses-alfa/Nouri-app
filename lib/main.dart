import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'screens/splash_screen.dart';
import 'themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('nl')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const NouriApp(),
    ),
  );
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
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}
