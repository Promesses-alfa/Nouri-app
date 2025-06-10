import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class PlanDagVoorScreen extends StatefulWidget {
  const PlanDagVoorScreen({super.key});

  @override
  State<PlanDagVoorScreen> createState() => _PlanDagVoorScreenState();
}

class _PlanDagVoorScreenState extends State<PlanDagVoorScreen> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final TextEditingController ontbijtController = TextEditingController();
  final TextEditingController lunchController = TextEditingController();
  final TextEditingController dinerController = TextEditingController();
  final TextEditingController snacksController = TextEditingController();

  final List<String> tijdstippen = ['07:00', '10:00', '12:00', '15:00', '18:00', '20:00'];
  String gekozenTijd = '07:00';

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Plan je dag voor"),
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text("Voor morgen plan je vooruit om gezonder te leven en minder stress te ervaren.",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            const Text("Voer je voeding in voor morgen", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(controller: ontbijtController, decoration: const InputDecoration(labelText: "Ontbijt")),
            TextField(controller: lunchController, decoration: const InputDecoration(labelText: "Lunch")),
            TextField(controller: dinerController, decoration: const InputDecoration(labelText: "Diner")),
            TextField(controller: snacksController, decoration: const InputDecoration(labelText: "Tussendoortjes")),
            const SizedBox(height: 32),
            const Text("Kies tijdstip voor herinneringen", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: gekozenTijd,
              isExpanded: true,
              items: tijdstippen.map((tijd) {
                return DropdownMenuItem<String>(
                  value: tijd,
                  child: Text(tijd),
                );
              }).toList(),
              onChanged: (waarde) => setState(() => gekozenTijd = waarde!),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('ontbijt', ontbijtController.text);
                await prefs.setString('lunch', lunchController.text);
                await prefs.setString('diner', dinerController.text);
                await prefs.setString('snacks', snacksController.text);
                await prefs.setString('herinneringTijd', gekozenTijd);

                final tijdDelen = gekozenTijd.split(':');
                final hour = int.parse(tijdDelen[0]);
                final minute = int.parse(tijdDelen[1]);
                scheduleNotification(hour, minute);

                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Dagplanning opgeslagen"),
                    content: const Text("Je krijgt morgen een herinnering om je voeding te volgen."),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("Oké"),
                      ),
                    ],
                  ),
                );
              },
              child: const Text("Opslaan"),
            ),
          ],
        ),
      ),
    );
  }

  void scheduleNotification(int hour, int minute) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'nouri_channel',
      'Nouri Herinneringen',
      importance: Importance.high,
      priority: Priority.high,
    );
    const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);

    final now = tz.TZDateTime.now(tz.local);
    final scheduledTime = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Tijd om goed voor jezelf te zorgen',
      'Je geplande voeding of drankje staat klaar.',
      scheduledTime,
      platformDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}