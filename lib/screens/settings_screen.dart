import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:nouri_app/screens/splash_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("settings_title".tr())),
      body: ListView(
        children: [
          ListTile(title: Text("goal_question".tr())),
          ListTile(title: Text("preferences_food".tr())),
          ListTile(title: Text("notification_time".tr())),
          ListTile(title: Text("grocery_budget".tr())),
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
          const Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("logout".tr()),
            onTap: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("logout_confirm_title".tr()),
                  content: Text("logout_confirm_message".tr()),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text("cancel".tr()),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text("confirm_logout".tr()),
                    ),
                  ],
                ),
              );

              if (confirmed == true) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const SplashScreen()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}