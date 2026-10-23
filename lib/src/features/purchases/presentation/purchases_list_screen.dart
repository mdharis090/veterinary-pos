import 'package:flutter/material.dart';

import '../../shared/presentation/clinic_ui.dart';

class PurchasesPage extends StatelessWidget {
  const PurchasesPage({required this.onNavigate, super.key});
  final ValueChanged<String> onNavigate;
  @override
  Widget build(BuildContext context) => ClinicDataPage(
    title: 'Purchases',
    action: 'New purchase',
    columns: const [
      'Invoice',
      'Supplier',
      'Company',
      'Subtotal',
      'Discount',
      'Total',
      'Actions',
    ],
    rows: const [
      [
        'PUR-084',
        'Imran Qureshi',
        'PetCare Distributors',
        'Rs 12,400',
        'Rs 400',
        'Rs 12,000',
        'View',
      ],
      [
        'PUR-083',
        'Sana Mahmood',
        'MediVet Supplies',
        'Rs 8,200',
        'Rs 200',
        'Rs 8,000',
        'View',
      ],
      [
        'PUR-082',
        'Usman Tariq',
        'Animal Health Co.',
        'Rs 6,750',
        'Rs 0',
        'Rs 6,750',
        'View',
      ],
    ],
    onAction: () => onNavigate('New purchase'),
  );
}
