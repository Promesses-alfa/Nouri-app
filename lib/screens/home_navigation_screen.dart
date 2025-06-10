import 'package:flutter/material.dart';
// import 'dashboard_screen.dart';
import 'plan_dag_voor_screen.dart';
import 'grocery_list_screen.dart';
import 'settings_screen.dart';

class HomeNavigationScreen extends StatefulWidget {
  const HomeNavigationScreen({super.key});

  @override
  State<HomeNavigationScreen> createState() => _HomeNavigationScreenState();
}

class _HomeNavigationScreenState extends State<HomeNavigationScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = <Widget>[
      buildHomeOverviewScreen(),
      const PlanDagVoorScreen(),
      const GroceryListScreen(),
      const SettingsScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ['Home', 'Voorbereiding', 'Boodschappen', 'Instellingen'][_selectedIndex],
        ),
        automaticallyImplyLeading: false,
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFFE2B6AC),
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.nightlight),
            label: 'Voorbereiding',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Boodschappen',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Instellingen',
          ),
        ],
      ),
    );
  }

  Widget buildHomeOverviewScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welkom bij Nouri 👋',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Jouw welzijns-assistent voor voeding, hydratatie en structuur.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            child: ListTile(
              leading: const Icon(Icons.restaurant_menu, color: Color(0xFFE2B6AC)),
              title: const Text('Bekijk je dagplanning'),
              subtitle: const Text('Wat staat er vandaag op het menu?'),
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                });
              },
            ),
          ),
          const SizedBox(height: 16),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            child: ListTile(
              leading: const Icon(Icons.shopping_cart, color: Color(0xFFE2B6AC)),
              title: const Text('Boodschappenlijst'),
              subtitle: const Text('Slim en automatisch gegenereerd'),
              onTap: () {
                setState(() {
                  _selectedIndex = 2;
                });
              },
            ),
          ),
          const SizedBox(height: 16),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            child: ListTile(
              leading: const Icon(Icons.settings, color: Color(0xFFE2B6AC)),
              title: const Text('Instellingen'),
              subtitle: const Text('Notificaties, taal, account'),
              onTap: () {
                setState(() {
                  _selectedIndex = 3;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}