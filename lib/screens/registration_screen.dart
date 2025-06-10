import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home_navigation_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController houseNumberController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isHuman = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registreren'),
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: firstNameController,
                decoration: const InputDecoration(labelText: 'Voornaam'),
                validator: (value) =>
                    value != null && value.isNotEmpty ? null : 'Vul uw voornaam in',
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: lastNameController,
                decoration: const InputDecoration(labelText: 'Achternaam'),
                validator: (value) =>
                    value != null && value.isNotEmpty ? null : 'Vul uw achternaam in',
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: streetController,
                decoration: const InputDecoration(labelText: 'Straat'),
                validator: (value) =>
                    value != null && value.isNotEmpty ? null : 'Vul uw straat in',
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: houseNumberController,
                decoration: const InputDecoration(labelText: 'Huisnummer'),
                validator: (value) =>
                    value != null && value.isNotEmpty ? null : 'Vul uw huisnummer in',
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: postalCodeController,
                decoration: const InputDecoration(labelText: 'Postcode'),
                validator: (value) =>
                    value != null && value.isNotEmpty ? null : 'Vul uw postcode in',
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: cityController,
                decoration: const InputDecoration(labelText: 'Woonplaats'),
                validator: (value) =>
                    value != null && value.isNotEmpty ? null : 'Vul uw woonplaats in',
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Telefoonnummer'),
                validator: (value) =>
                    value != null && value.isNotEmpty ? null : 'Vul uw telefoonnummer in',
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'E-mailadres'),
                validator: (value) =>
                    value != null && value.contains('@') ? null : 'Ongeldig e-mailadres',
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Wachtwoord'),
                validator: (value) =>
                    value != null && value.length >= 6 ? null : 'Minimaal 6 tekens vereist',
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text("Ik ben geen robot"),
                value: isHuman,
                onChanged: (val) => setState(() => isHuman = val ?? false),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (!isHuman) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Bevestig alstublieft dat u geen robot bent')),
                    );
                    return;
                  }
                  if (_formKey.currentState!.validate()) {
                    try {
                      final response = await Supabase.instance.client.auth.signUp(
                        email: emailController.text,
                        password: passwordController.text,
                      );

                      if (response.user != null) {
                        await Supabase.instance.client.from('profiles').insert({
                          'id': response.user!.id,
                          'email': emailController.text,
                          'first_name': firstNameController.text,
                          'last_name': lastNameController.text,
                          'street': streetController.text,
                          'house_number': houseNumberController.text,
                          'postal_code': postalCodeController.text,
                          'city': cityController.text,
                          'phone': phoneController.text,
                          'created_at': DateTime.now().toIso8601String(),
                        });

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const HomeNavigationScreen()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Registratie vereist e-mailbevestiging')),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Registratiefout: ${e.toString()}')),
                      );
                    }
                  }
                },
                child: const Text('Account aanmaken'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}