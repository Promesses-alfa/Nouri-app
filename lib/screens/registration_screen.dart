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

  InputDecoration _inputDecoration(String label, Color primary) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primary),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primary, width: 2),
      ),
      filled: true,
      fillColor: primary.withOpacity(0.05),
    );
  }

  Widget _buildTextField(
    String key,
    String label, {
    bool obscure = false,
    TextInputType? type,
    Color? primary,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controllers[key],
        obscureText: obscure,
        keyboardType: type,
        decoration: _inputDecoration(label, primary ?? Colors.blue),
        validator: (value) =>
            value == null || value.isEmpty ? 'Vul $label in' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final primary = colorScheme.primary;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: const Text('Registreren'),
        backgroundColor: primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField('firstName', 'Voornaam', primary: primary),
                    _buildTextField('lastName', 'Achternaam', primary: primary),
                    _buildTextField('street', 'Straat', primary: primary),
                    _buildTextField('houseNumber', 'Huisnummer',
                        type: TextInputType.number, primary: primary),
                    _buildTextField('postalCode', 'Postcode', primary: primary),
                    _buildTextField('city', 'Woonplaats', primary: primary),
                    _buildTextField('phone', 'Telefoonnummer',
                        type: TextInputType.phone, primary: primary),
                    _buildTextField('email', 'E-mailadres',
                        type: TextInputType.emailAddress, primary: primary),
                    _buildTextField('password', 'Wachtwoord',
                        obscure: true, primary: primary),
                    CheckboxListTile(
                      activeColor: primary,
                      title: const Text("Ik ben geen robot"),
                      value: isHuman,
                      onChanged: (val) =>
                          setState(() => isHuman = val ?? false),
                    ),
                    if (errorMessage != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        errorMessage!,
                        style: TextStyle(color: colorScheme.error),
                      ),
                    ],
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: _submit,
                        child: const Text(
                          'Account aanmaken',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
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
        email: controllers['email']!.text.trim(),
        password: controllers['password']!.text.trim(),
      );

      final user = response.user;
      if (user != null) {
        final insertRes = await Supabase.instance.client
            .from('profiles')
            .insert({
          'id': user.id,
          'email': controllers['email']!.text.trim(),
          'first_name': controllers['firstName']!.text.trim(),
          'last_name': controllers['lastName']!.text.trim(),
          'street': controllers['street']!.text.trim(),
          'house_number': controllers['houseNumber']!.text.trim(),
          'postal_code': controllers['postalCode']!.text.trim(),
          'city': controllers['city']!.text.trim(),
          'phone': controllers['phone']!.text.trim(),
          'created_at': DateTime.now().toIso8601String(),
        });

        if (insertRes.error != null) {
          setState(() => errorMessage =
              'Registratiefout: ${insertRes.error!.message}');
          return;
        }

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => const HomeNavigationScreen()),
        );
      } else {
        setState(() =>
            errorMessage = 'Registratie vereist e-mailbevestiging');
      }
    } on PostgrestException catch (e) {
      setState(() => errorMessage =
          'Registratiefout: ${e.message}');
    } catch (e) {
      setState(() =>
          errorMessage = 'Er is iets misgegaan: ${e.toString()}');
    }
  }
}