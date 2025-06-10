import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  Future<void> checkAndShowNotifications() async {
    final supabase = Supabase.instance.client;
    final prefs = await SharedPreferences.getInstance();
    var sessionId = prefs.getString('session_id');
    if (sessionId == null) return;

    final response = await supabase
        .from('flow_notifications')
        .select()
        .eq('session_id', sessionId)
        .eq('is_read', false)
        .order('created_at', ascending: false)
        .limit(1);

    if (response.isNotEmpty) {
      final note = response.first;
      final message = note['message'] as String;

      const notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails('flowly', 'Flow Coach'),
        iOS: DarwinNotificationDetails(),
      );

      await flutterLocalNotificationsPlugin.show(
        0,
        'Flow Coach',
        message,
        notificationDetails,
      );

      await supabase
          .from('flow_notifications')
          .update({'is_read': true})
          .eq('id', note['id']);
    }
  }

  await checkAndShowNotifications();

  await Supabase.initialize(
    url: 'https://jstsvfuyriludksxvsig.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpzdHN2ZnV5cmlsdWRrc3h2c2lnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDk1Mzg1NDgsImV4cCI6MjA2NTExNDU0OH0.j0uwf9eIYXyACLLqcmTnC59fAGyaQXtOmG4zpE7Vnkw',
  );

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
