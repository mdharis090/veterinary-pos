import 'package:flutter/material.dart';

import 'src/features/dashboard/presentation/dashboard_screen.dart';

void main() {
  runApp(const VeterinaryPosApp());
}

class VeterinaryPosApp extends StatelessWidget {
  const VeterinaryPosApp({super.key});

  @override
  Widget build(BuildContext context) {
    const teal = Color(0xFF128078);

    return MaterialApp(
      title: 'Vetnaly Veterinary POS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF3F6F7),
        colorScheme: ColorScheme.fromSeed(
          seedColor: teal,
          primary: teal,
          surface: Colors.white,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Color(0xFF34445B), fontSize: 12),
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}
