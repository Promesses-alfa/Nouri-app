import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'home_navigation_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      'title': 'onboarding_title_1',
      'subtitle': 'onboarding_subtitle_1',
    },
    {
      'title': 'onboarding_title_2',
      'subtitle': 'onboarding_subtitle_2',
    },
    {
      'title': 'onboarding_title_3',
      'subtitle': 'onboarding_subtitle_3',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _controller,
        itemCount: onboardingData.length,
        onPageChanged: (index) => setState(() => _currentPage = index),
        itemBuilder: (context, index) {
          final data = onboardingData[index];
          return Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(data['title']!.tr(),
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center),
                const SizedBox(height: 24),
                Text(data['subtitle']!.tr(),
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center),
                const SizedBox(height: 48),
                if (index == onboardingData.length - 1)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const HomeNavigationScreen()),
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
          );
        },
      ),
    );
  }
}