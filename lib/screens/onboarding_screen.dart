import 'package:flutter/material.dart';
import 'home_navigation_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Welkom bij Nouri")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Wat is jouw doel?"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeNavigationScreen()),
                );
              },
              child: const Text("Balans vinden"),
            ),
          ],
        ),
      ),
    );
  }
}