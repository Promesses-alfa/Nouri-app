import 'package:flutter/material.dart';

class GroceryListScreen extends StatelessWidget {
  const GroceryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Boodschappenlijst")),
      body: ListView(
        children: const [
          ListTile(title: Text("Havermout")),
          ListTile(title: Text("Banaan")),
          ListTile(title: Text("Volkoren crackers")),
        ],
      ),
    );
  }
}