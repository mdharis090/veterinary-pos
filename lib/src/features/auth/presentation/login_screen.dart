import 'package:flutter/material.dart';

import '../../shared/presentation/clinic_ui.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({required this.onSignIn, super.key});
  final VoidCallback onSignIn;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _username = TextEditingController();
  final _password = TextEditingController();
  bool _hidePassword = true;
  bool _remember = true;
  String? _usernameError;
  String? _passwordError;

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    setState(() {
      _usernameError = _username.text.trim().isEmpty
          ? 'Username is required.'
          : null;
      _passwordError = _password.text.isEmpty ? 'Password is required.' : null;
    });
    if (_usernameError == null && _passwordError == null) widget.onSignIn();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF134E4A),
    body: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(child: ClinicLogo()),
                const SizedBox(height: 20),
                const Text(
                  'Veterinary POS',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: clinicInk,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Welcome back. Sign in to continue.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: clinicMuted),
                ),
                const SizedBox(height: 28),
                ClinicField(
                  label: 'Username',
                  hint: 'Enter your username',
                  controller: _username,
                  errorText: _usernameError,
                ),
                const SizedBox(height: 18),
                ClinicField(
                  label: 'Password',
                  hint: 'Enter your password',
                  controller: _password,
                  obscure: _hidePassword,
                  errorText: _passwordError,
                  suffix: IconButton(
                    tooltip: _hidePassword ? 'Show password' : 'Hide password',
                    onPressed: () =>
                        setState(() => _hidePassword = !_hidePassword),
                    icon: Icon(
                      _hidePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                        title: const Text(
                          'Remember me',
                          style: TextStyle(fontSize: 14),
                        ),
                        value: _remember,
                        onChanged: (value) =>
                            setState(() => _remember = value ?? false),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Forgot password?'),
                    ),
                  ],
                ),
                ClinicPrimaryButton(label: 'Sign In', onPressed: _submit),
                const SizedBox(height: 20),
                const Text(
                  'New here? Contact admin',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: clinicMuted),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
