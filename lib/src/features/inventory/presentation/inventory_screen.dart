import 'package:flutter/material.dart';

import '../../shared/presentation/clinic_ui.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});
  @override
  Widget build(BuildContext context) => ClinicPageFrame(
    title: 'Inventory',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ClinicTabs(labels: ['Stock', 'Low stock', 'Expired', 'Logs']),
        const SizedBox(height: 16),
        const ClinicStatsGrid(
          items: [
            ('Medicines', '5', clinicTeal),
            ('Low stock', '1', Color(0xFFF59E0B)),
            ('Out of stock', '1', Color(0xFFEF4444)),
            ('Expired batches', '0', Color(0xFF3B82F6)),
          ],
        ),
        const SizedBox(height: 16),
        const ClinicTable(
          title: 'Stock overview',
          columns: [
            'Medicine',
            'Category',
            'Stock',
            'Reorder at',
            'Price',
            'Status',
          ],
          rows: [
            [
              'Amoxicillin 500mg',
              'Antibiotic',
              '15',
              '20',
              'Rs 10.00',
              'Low stock',
            ],
            ['Rabies vaccine', 'Vaccine', '38', '10', 'Rs 250.00', 'OK'],
            ['Deworming tablet', 'Parasite care', '64', '15', 'Rs 75.00', 'OK'],
            [
              'Flea treatment',
              'Parasite care',
              '0',
              '10',
              'Rs 320.00',
              'Out of stock',
            ],
            ['Vitamin supplement', 'Supplement', '42', '12', 'Rs 180.00', 'OK'],
          ],
        ),
      ],
    ),
  );
}
