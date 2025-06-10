import 'package:flutter/material.dart';

class NotificationPopup extends StatelessWidget {
  final String message;
  const NotificationPopup({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notificatie"),
        automaticallyImplyLeading: true,
      ),
      body: AlertDialog(
        title: const Text("Nouri herinnert je:"),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text("Oké"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}