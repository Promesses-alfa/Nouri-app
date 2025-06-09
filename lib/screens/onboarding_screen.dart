import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'home_navigation_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("welcome".tr())),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("goal_question".tr()),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeNavigationScreen()),
                );
              },
              child: Text("start_button".tr()),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => context.setLocale(const Locale('en')),
                  child: const Text("EN"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => context.setLocale(const Locale('nl')),
                  child: const Text("NL"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}