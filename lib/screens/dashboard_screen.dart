import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String ontbijt = '';
  String lunch = '';
  String diner = '';
  String snacks = '';
  String herinneringTijd = '';

  @override
  void initState() {
    super.initState();
    _laadGegevens();
  }

  Future<void> _laadGegevens() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      ontbijt = prefs.getString('ontbijt') ?? '';
      lunch = prefs.getString('lunch') ?? '';
      diner = prefs.getString('diner') ?? '';
      snacks = prefs.getString('snacks') ?? '';
      herinneringTijd = prefs.getString('herinneringTijd') ?? '';
    });
  }

  Widget _bouwKaart(String titel, String inhoud) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(titel, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(inhoud.isNotEmpty ? inhoud : "Nog niet ingesteld"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Jouw dag met Nouri")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _bouwKaart("Ontbijt", ontbijt),
            _bouwKaart("Lunch", lunch),
            _bouwKaart("Diner", diner),
            _bouwKaart("Tussendoortjes", snacks),
            _bouwKaart("Herinneringstijd", herinneringTijd),
          ],
        ),
      ),
    );
  }
}