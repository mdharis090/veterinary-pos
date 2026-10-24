import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../dashboard/presentation/dashboard_screen.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/token_storage.dart';
import '../data/auth_api.dart';
import 'login_screen.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late Future<bool> _authentication;

  @override
  void initState() {
    super.initState();
    _authentication = _checkAuthentication();
  }

  Future<bool> _checkAuthentication() async {
    final token = await TokenStorage.instance.readToken();
    if (token == null || token.isEmpty) return false;
    try {
      await AuthApi().currentUser();
      return true;
    } on ApiException catch (error) {
      if (error.statusCode == 401 || error.statusCode == 403) {
        await TokenStorage.instance.clearToken();
        return false;
      }
      rethrow;
    }
  }

  void _retry() => setState(() => _authentication = _checkAuthentication());

  void _onSignIn() => setState(() => _authentication = Future.value(true));

  @override
  Widget build(BuildContext context) => FutureBuilder<bool>(
    future: _authentication,
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Scaffold(
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _errorMessage(snapshot.error!),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: _retry,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
      if (!snapshot.hasData) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }
      if (snapshot.data!) {
        return const DashboardScreen();
      }
      return LoginScreen(onSignIn: _onSignIn);
    },
  );

  String _errorMessage(Object error) => switch (error) {
    ApiException() => error.toString(),
    PlatformException() =>
      'Secure sign-in storage is unavailable. Check the device configuration.',
    _ => 'Could not verify the saved session. Please retry.',
  };
}
