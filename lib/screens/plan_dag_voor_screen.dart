import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlanDagVoorScreen extends StatefulWidget {
  const PlanDagVoorScreen({super.key});

  @override
  State<PlanDagVoorScreen> createState() => _PlanDagVoorScreenState();
}

class _PlanDagVoorScreenState extends State<PlanDagVoorScreen> {
  final TextEditingController ontbijtController = TextEditingController();
  final TextEditingController lunchController = TextEditingController();
  final TextEditingController dinerController = TextEditingController();
  final TextEditingController snacksController = TextEditingController();

  final List<String> tijdstippen = ['07:00', '10:00', '12:00', '15:00', '18:00', '20:00'];
  String gekozenTijd = '07:00';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Plan je dag voor")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Dagplanning opgeslagen!")),
                );
              },
              child: const Text("Opslaan"),
            ),
          ],
        ),
      ),
    );
  }
}