import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Instellingen")),
      body: ListView(
        children: const [
          ListTile(title: Text("Doel aanpassen")),
          ListTile(title: Text("Voorkeuren voeding")),
          ListTile(title: Text("Tijdstip meldingen")),
          ListTile(title: Text("Budget voor boodschappen")),
        ],
      ),
    );
  }
}