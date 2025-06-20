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
    'first_name': TextEditingController(),
    'last_name': TextEditingController(),
    'street': TextEditingController(),
    'house_number': TextEditingController(),
    'postal_code': TextEditingController(),
    'city': TextEditingController(),
    'phone': TextEditingController(),
    'email': TextEditingController(),
    'password': TextEditingController(),
  };

  @override
  void dispose() {
    for (final c in controllers.values) {
      c.dispose();
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
        controller: controllers[key]!,
        obscureText: obscure,
        keyboardType: type,
        decoration: _inputDecoration(label, primary!),
        validator: (v) =>
            v == null || v.isEmpty ? 'Vul $label in' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final primary = const Color(0xFFD9B49C); // lichtroze tint

    return Scaffold(
      backgroundColor: colorScheme.surface,
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
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildTextField(
                            'first_name', 'Voornaam',
                            primary: primary),
                        _buildTextField(
                            'last_name', 'Achternaam',
                            primary: primary),
                        _buildTextField(
                            'street', 'Straat',
                            primary: primary),
                        _buildTextField(
                            'house_number', 'Huisnummer',
                            type: TextInputType.number,
                            primary: primary),
                        _buildTextField(
                            'postal_code', 'Postcode',
                            primary: primary),
                        _buildTextField(
                            'city', 'Woonplaats',
                            primary: primary),
                        _buildTextField(
                            'phone', 'Telefoonnummer',
                            type: TextInputType.phone,
                            primary: primary),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: TextFormField(
                            controller: controllers['email'],
                            keyboardType: TextInputType.emailAddress,
                            decoration: _inputDecoration('E-mailadres', primary),
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Vul E-mailadres in';
                              }
                              final emailRegex = RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$');
                              if (!emailRegex.hasMatch(v.trim())) {
                                return 'Ongeldig e-mailadres';
                              }
                              return null;
                            },
                          ),
                        ),
                        _buildTextField(
                            'password', 'Wachtwoord',
                            obscure: true,
                            primary: primary),
                        CheckboxListTile(
                          activeColor: primary,
                          title: const Text('Ik ben geen robot'),
                          value: isHuman,
                          onChanged: (v) =>
                              setState(() => isHuman = v!),
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
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(12)),
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
        ),
      ),
    );
  }

  Future<void> _submit() async {
    
    if (!_formKey.currentState!.validate()) return;
    if (!isHuman) {
      setState(() =>
          errorMessage = 'Bevestig dat je geen robot bent');
      return;
    }

    try {
      final resp = await Supabase.instance.client.auth.signUp(
        email: controllers['email']!.text.trim(),
        password: controllers['password']!.text.trim(),
      );

      // Haal de huidige sessie op en lees het user ID
      final user = resp.user;
      final session = resp.session;

      if (session != null && user != null) {
        final userId = user.id;

        final profileData = {
          'id': userId,
          'email': controllers['email']!.text.trim(),
          'first_name': controllers['first_name']!.text.trim(),
          'last_name': controllers['last_name']!.text.trim(),
          'street': controllers['street']!.text.trim(),
          'house_number': controllers['house_number']!.text.trim(),
          'postal_code': controllers['postal_code']!.text.trim(),
          'city': controllers['city']!.text.trim(),
          'phone': controllers['phone']!.text.trim(),
          'created_at': DateTime.now().toIso8601String(),
        };

        print('➡️ Profieldata om op te slaan: $profileData');

        final insertRes = await Supabase.instance.client
            .from('profiles')
            .insert(profileData);
        if (insertRes.error != null) {
          setState(() => errorMessage =
              'Registratiefout: ${insertRes.error!.message}');
          return;
        }

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) =>
                  const HomeNavigationScreen()),
        );
      } else {
        setState(() {
          errorMessage = 'Bevestig je e-mail via de link die is verstuurd voordat je kunt inloggen.';
        });
      }
      
    } on PostgrestException catch (e) {
      setState(() => errorMessage =
          'Registratiefout: ${e.message}');
    } catch (e) {
      setState(() => errorMessage =
          'Er is iets misgegaan: ${e.toString()}');
    }
  }
}