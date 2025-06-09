import 'package:flutter/material.dart';

class DayPrepScreen extends StatelessWidget {
  const DayPrepScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Avondvoorbereiding")),
      body: const Center(
        child: Text("Plan hier je voeding en hydratatie voor morgen."),
      ),
    );
  }
}