import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'screens/splash_screen.dart';
import 'themes/app_theme.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  const initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const initializationSettingsIOS = DarwinInitializationSettings();

  const initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

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
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      home: const SplashScreen(),
    );
  }
}
