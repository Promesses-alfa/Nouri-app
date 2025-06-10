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
            'Goedemorgen 👋',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Hier is je overzicht voor vandaag.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 24),

          // Watermomenten
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            child: ListTile(
              leading: const Icon(Icons.water_drop, color: Color(0xFFE2B6AC)),
              title: const Text('Waterinname'),
              subtitle: const Text('2 van 5 glazen vandaag'),
              trailing: const CircularProgressIndicator(value: 0.4),
              onTap: () {
                // toekomstige navigatie naar waterdetails
              },
            ),
          ),
          const SizedBox(height: 16),

          // Rustmoment
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            child: ListTile(
              leading: const Icon(Icons.self_improvement, color: Color(0xFFE2B6AC)),
              title: const Text('Rustmoment'),
              subtitle: const Text('Laatste pauze: 09:30 – volgende om 11:00'),
              onTap: () {
                // toekomstige navigatie naar rustdata
              },
            ),
          ),
          const SizedBox(height: 16),

          // Actie van de dag
          Card(
            color: Colors.green[50],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            child: ListTile(
              leading: const Icon(Icons.check_circle_outline, color: Color(0xFFE2B6AC)),
              title: const Text('Actie: Neem ontbijt'),
              subtitle: const Text('Voorgesteld om 08:30 – nog niet afgevinkt'),
              onTap: () {
                // toekomstige actie-tracking
              },
            ),
          ),
          const SizedBox(height: 16),

          // Boodschappenlijst
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            child: ListTile(
              leading: const Icon(Icons.shopping_cart, color: Color(0xFFE2B6AC)),
              title: const Text('Boodschappenlijst'),
              subtitle: const Text('3 producten toegevoegd'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                setState(() {
                  _selectedIndex = 2;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}