import 'package:flutter/material.dart';

import '../../features/batches/presentation/batches_screen.dart';
import '../../features/billing/presentation/pos_billing_screen.dart';
import '../../features/consultations/presentation/consultations_screen.dart';
import '../../features/inventory/presentation/inventory_screen.dart';
import '../../features/medicines/presentation/medicines_screen.dart';
import '../../features/owners/presentation/owners_screen.dart';
import '../../features/patients/presentation/patient_detail_screen.dart';
import '../../features/patients/presentation/patient_list_screen.dart';
import '../../features/payments/presentation/payments_screen.dart';
import '../../features/prescriptions/presentation/prescriptions_screen.dart';
import '../../features/purchases/presentation/purchase_screens.dart';
import '../../features/purchases/presentation/purchases_list_screen.dart';
import '../../features/reports/presentation/reports_screen.dart';
import '../../features/returns/presentation/returns_screen.dart';
import '../../features/sales/presentation/sales_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/suppliers/presentation/suppliers_screen.dart';
import 'app_routes_named.dart';

abstract final class AppRouteScreens {
  static Widget forDashboardSection(
    String section, {
    required ValueChanged<String> onNavigate,
  }) {
    final routeName = AppRoutesNamed.dashboardSections[section];
    if (routeName == null) {
      throw ArgumentError.value(
        section,
        'section',
        'Unknown dashboard section',
      );
    }
    return forRoute(routeName, onNavigate: onNavigate);
  }

  static Widget forRoute(
    String routeName, {
    required ValueChanged<String> onNavigate,
  }) => switch (routeName) {
    AppRoutesNamed.patients => PatientsListPage(onNavigate: onNavigate),
    AppRoutesNamed.patientProfile => PatientDetailScreen(
      onNavigate: onNavigate,
    ),
    AppRoutesNamed.owners => const OwnersPage(),
    AppRoutesNamed.consultations => const ConsultationsScreen(),
    AppRoutesNamed.prescriptions => const PrescriptionsPage(),
    AppRoutesNamed.medicines => const MedicinesPage(),
    AppRoutesNamed.inventory => const InventoryScreen(),
    AppRoutesNamed.batches => const BatchesPage(),
    AppRoutesNamed.suppliers => const SuppliersPage(),
    AppRoutesNamed.purchases => const PurchasesPage(),
    AppRoutesNamed.newPurchase => const NewPurchaseScreen(),
    AppRoutesNamed.posBilling => PosBillingScreen(),
    AppRoutesNamed.sales => const SalesPage(),
    AppRoutesNamed.returns => const ReturnsScreen(),
    AppRoutesNamed.payments => const PaymentsScreen(),
    AppRoutesNamed.reports => const ReportsScreen(),
    AppRoutesNamed.settings => const SettingsScreen(),
    _ => throw ArgumentError.value(routeName, 'routeName', 'Unknown screen'),
  };
}
