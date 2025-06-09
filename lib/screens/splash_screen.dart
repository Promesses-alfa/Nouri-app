import 'package:flutter/material.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    });

    return Scaffold(
      body: Center(
        child: Text(
          'Nouri',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}