import 'package:flutter/material.dart';

import '../../features/auth/presentation/auth_gate.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import 'app_route_screens.dart';
import 'app_routes_named.dart';

abstract final class AppRoutes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final routeName = settings.name ?? AppRoutesNamed.root;
    final normalizedRoute = routeName;

    final WidgetBuilder? builder = switch (normalizedRoute) {
      AppRoutesNamed.root => (_) => const AuthGate(),
      AppRoutesNamed.dashboard => (_) => const DashboardScreen(),
      AppRoutesNamed.login => (context) => LoginScreen(
        onSignIn: () => Navigator.of(
          context,
        ).pushReplacementNamed(AppRoutesNamed.dashboard),
      ),
      AppRoutesNamed.patients ||
      AppRoutesNamed.patientProfile ||
      AppRoutesNamed.owners ||
      AppRoutesNamed.consultations ||
      AppRoutesNamed.prescriptions ||
      AppRoutesNamed.medicines ||
      AppRoutesNamed.inventory ||
      AppRoutesNamed.batches ||
      AppRoutesNamed.suppliers ||
      AppRoutesNamed.purchases ||
      AppRoutesNamed.newPurchase ||
      AppRoutesNamed.posBilling ||
      AppRoutesNamed.sales ||
      AppRoutesNamed.returns ||
      AppRoutesNamed.payments ||
      AppRoutesNamed.reports ||
      AppRoutesNamed.settings => (context) => AppRouteScreens.forRoute(
        normalizedRoute,
        onNavigate: (section) => _navigateToSection(context, section),
      ),
      _ => null,
    };

    if (builder == null) {
      return MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => _UnknownRouteScreen(routeName: routeName),
      );
    }

    return MaterialPageRoute<void>(settings: settings, builder: builder);
  }

  static void _navigateToSection(BuildContext context, String section) {
    final routeName = AppRoutesNamed.dashboardSections[section];
    if (routeName == null) {
      throw ArgumentError.value(section, 'section', 'Unknown dashboard section');
    }
    Navigator.of(context).pushNamed(routeName);
  }
}

class _UnknownRouteScreen extends StatelessWidget {
  const _UnknownRouteScreen({required this.routeName});

  final String routeName;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Page not found')),
    body: Center(
      child: Text('No screen is registered for "$routeName".'),
    ),
  );
}
