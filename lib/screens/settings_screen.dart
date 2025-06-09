import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("settings_title".tr())),
      body: ListView(
        children: [
          ListTile(title: Text("goal_question".tr())),
          ListTile(title: Text("Voorkeuren voeding")),
          ListTile(title: Text("Tijdstip meldingen")),
          ListTile(title: Text("Budget voor boodschappen")),
          const Divider(),
          ListTile(
            title: Text("Taal / Language"),
            trailing: DropdownButton<Locale>(
              value: context.locale,
              onChanged: (Locale? locale) {
                if (locale != null) {
                  context.setLocale(locale);
                }
              },
              items: const [
                DropdownMenuItem(
                  value: Locale('en'),
                  child: Text('English'),
                ),
                DropdownMenuItem(
                  value: Locale('nl'),
                  child: Text('Nederlands'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}