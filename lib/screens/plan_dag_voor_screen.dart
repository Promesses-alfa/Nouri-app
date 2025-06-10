import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/supabase_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:lottie/lottie.dart';

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
            Lottie.asset('assets/morning_animation.json', height: 150),
            Text("Je dag begint goed!", style: Theme.of(context).textTheme.headline6),
            const SizedBox(height: 8),
            Text("Voor morgen plan je vooruit om gezonder te leven en minder stress te ervaren.",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            DagSectie(
              titel: "Ochtend",
              icoon: Icons.wb_sunny,
              suggesties: ["Fruit", "Yoghurt", "Koffie"],
              controller: ontbijtController,
            ),
            const SizedBox(height: 16),
            DagSectie(
              titel: "Middag",
              icoon: Icons.wb_cloudy,
              suggesties: ["Salade", "Broodje", "Sap"],
              controller: lunchController,
            ),
            const SizedBox(height: 16),
            DagSectie(
              titel: "Avond",
              icoon: Icons.nights_stay,
              suggesties: ["Pasta", "Vis", "Groenten"],
              controller: dinerController,
            ),
            const SizedBox(height: 16),
            DagSectie(
              titel: "Tussendoortjes",
              icoon: Icons.fastfood,
              suggesties: ["Noten", "Yoghurt", "Fruit"],
              controller: snacksController,
            ),
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
            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.play_arrow),
        label: const Text("Start je dag"),
        onPressed: () async {
          final now = DateTime.now();
          final morgen = DateTime(now.year, now.month, now.day).add(Duration(days: 1));

          await SupabaseService().saveDayPlan(
            timeBlock: 'morning',
            items: ontbijtController.text.split(',').map((e) => e.trim()).toList(),
            repeat: true,
            date: morgen,
          );
          await SupabaseService().saveDayPlan(
            timeBlock: 'afternoon',
            items: lunchController.text.split(',').map((e) => e.trim()).toList(),
            repeat: true,
            date: morgen,
          );
          await SupabaseService().saveDayPlan(
            timeBlock: 'evening',
            items: dinerController.text.split(',').map((e) => e.trim()).toList(),
            repeat: true,
            date: morgen,
          );
          await SupabaseService().saveDayPlan(
            timeBlock: 'snacks',
            items: snacksController.text.split(',').map((e) => e.trim()).toList(),
            repeat: true,
            date: morgen,
          );

          final tijdDelen = gekozenTijd.split(':');
          final hour = int.parse(tijdDelen[0]);
          final minute = int.parse(tijdDelen[1]);
          scheduleNotification(hour, minute);

          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Dagplanning opgeslagen"),
              content: const Text("Je planning is nu opgeslagen in Supabase en je krijgt morgen een herinnering."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Oké"),
                ),
              ],
            ),
          );
        },
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

class DagSectie extends StatefulWidget {
  final String titel;
  final IconData icoon;
  final List<String> suggesties;
  final TextEditingController controller;

  const DagSectie({
    Key? key,
    required this.titel,
    required this.icoon,
    required this.suggesties,
    required this.controller,
  }) : super(key: key);

  @override
  State<DagSectie> createState() => _DagSectieState();
}

class _DagSectieState extends State<DagSectie> {
  bool repeatFlag = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(widget.icoon, size: 28),
                const SizedBox(width: 8),
                Text(widget.titel, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: widget.suggesties.map((suggestie) {
                return ActionChip(
                  label: Text(suggestie),
                  onPressed: () {
                    final text = widget.controller.text;
                    final insertText = suggestie + (text.isEmpty ? '' : ', ');
                    setState(() {
                      widget.controller.text = insertText + text;
                      widget.controller.selection = TextSelection.fromPosition(TextPosition(offset: widget.controller.text.length));
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: widget.controller,
              decoration: InputDecoration(
                labelText: widget.titel,
                border: const OutlineInputBorder(),
              ),
              maxLines: null,
            ),
            SwitchListTile(
              title: const Text("Altijd dit plannen?"),
              value: repeatFlag,
              onChanged: (value) => setState(() => repeatFlag = value),
            ),
          ],
        ),
      ),
    );
  }
}