import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home_navigation_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isHuman = false;
  String? errorMessage;

  final Map<String, TextEditingController> controllers = {
    'firstName': TextEditingController(),
    'lastName': TextEditingController(),
    'street': TextEditingController(),
    'houseNumber': TextEditingController(),
    'postalCode': TextEditingController(),
    'city': TextEditingController(),
    'phone': TextEditingController(),
    'email': TextEditingController(),
    'password': TextEditingController(),
  };

  @override
  void dispose() {
    for (final controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: Colors.grey[100],
    );
  }

  Widget _buildTextField(String key, String label, {bool obscure = false, TextInputType? type}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controllers[key],
        obscureText: obscure,
        keyboardType: type,
        decoration: _inputDecoration(label),
        validator: (value) => value == null || value.isEmpty ? 'Vul $label in' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Registreren'),
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField('firstName', 'Voornaam'),
                  _buildTextField('lastName', 'Achternaam'),
                  _buildTextField('street', 'Straat'),
                  _buildTextField('houseNumber', 'Huisnummer'),
                  _buildTextField('postalCode', 'Postcode'),
                  _buildTextField('city', 'Woonplaats'),
                  _buildTextField('phone', 'Telefoonnummer', type: TextInputType.phone),
                  _buildTextField('email', 'E-mailadres', type: TextInputType.emailAddress),
                  _buildTextField('password', 'Wachtwoord', obscure: true),
                  CheckboxListTile(
                    title: const Text("Ik ben geen robot"),
                    value: isHuman,
                    onChanged: (val) => setState(() => isHuman = val ?? false),
                  ),
                  const SizedBox(height: 16),
                  if (errorMessage != null)
                    Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: _submit,
                      child: const Text('Account aanmaken', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!isHuman) {
      setState(() => errorMessage = 'Bevestig dat je geen robot bent');
      return;
    }

    try {
      final response = await Supabase.instance.client.auth.signUp(
        email: controllers['email']!.text,
        password: controllers['password']!.text,
      );

      final user = response.user;
      if (user != null) {
        await Supabase.instance.client.from('profiles').insert({
          'id': user.id,
          'email': controllers['email']!.text,
          'first_name': controllers['firstName']!.text,
          'last_name': controllers['lastName']!.text,
          'street': controllers['street']!.text,
          'house_number': controllers['houseNumber']!.text,
          'postal_code': controllers['postalCode']!.text,
          'city': controllers['city']!.text,
          'phone': controllers['phone']!.text,
          'created_at': DateTime.now().toIso8601String(),
        });

        if (!mounted) return;
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeNavigationScreen()));
      } else {
        setState(() => errorMessage = 'Registratie vereist e-mailbevestiging');
      }
    } catch (e) {
      setState(() => errorMessage = 'Registratiefout: ${e.toString()}');
    }
  }
}