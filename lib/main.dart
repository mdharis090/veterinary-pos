import 'package:flutter/material.dart';

import 'src/core/routes/app_routes.dart';
import 'src/core/routes/app_routes_named.dart';

void main() {
  runApp(const VeterinaryPosApp());
}

class VeterinaryPosApp extends StatelessWidget {
  const VeterinaryPosApp({super.key});

  @override
  Widget build(BuildContext context) {
    const teal = Color(0xFF0F766E);

    return MaterialApp(
      title: 'Vetnalay – Veterinary POS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF4F7F6),
        colorScheme: ColorScheme.fromSeed(
          seedColor: teal,
          primary: teal,
          surface: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: teal, width: 2),
          ),
        ),
        navigationBarTheme: const NavigationBarThemeData(
          labelTextStyle: WidgetStatePropertyAll(
            TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Color(0xFF0F172A), fontSize: 14),
          bodySmall: TextStyle(color: Color(0xFF64748B), fontSize: 14),
          titleMedium: TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          headlineSmall: TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 26,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      initialRoute: AppRoutesNamed.root,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
