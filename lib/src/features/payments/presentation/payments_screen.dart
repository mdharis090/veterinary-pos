import 'package:flutter/material.dart';

import '../../shared/presentation/clinic_ui.dart';

class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({super.key});
  @override
  Widget build(BuildContext context) => ClinicPageFrame(
    title: 'Payments',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ClinicStatsGrid(
          items: [
            ('Cash · 24 transactions', 'Rs 18,450', clinicTeal),
            ('Card · 12 transactions', 'Rs 12,600', Color(0xFF3B82F6)),
            ('Online · 8 transactions', 'Rs 8,200', Color(0xFFF97360)),
          ],
        ),
        const SizedBox(height: 16),
        const ClinicTable(
          title: 'Recent payments',
          columns: ['ID', 'Invoice', 'Amount', 'Method', 'Date', 'Actions'],
          rows: [
            ['PAY-108', 'INV-001', 'Rs 500.00', 'Cash', '05 Oct 2026', 'View'],
            ['PAY-107', 'INV-002', 'Rs 750.00', 'Card', '04 Oct 2026', 'View'],
            [
              'PAY-106',
              'INV-003',
              'Rs 180.00',
              'Online',
              '03 Oct 2026',
              'View',
            ],
          ],
        ),
      ],
    ),
  );
}
