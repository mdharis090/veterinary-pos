import 'package:flutter/material.dart';

import '../../shared/presentation/clinic_ui.dart';

class SalesPage extends StatelessWidget {
  const SalesPage({super.key});
  @override
  Widget build(BuildContext context) => const ClinicDataPage(
    title: 'Sales',
    columns: ['Invoice', 'Owner', 'Animal', 'Total', 'Payment', 'Actions'],
    rows: [
      ['INV-001', 'Sara Krugs', 'Nyxie', 'Rs 500.00', 'Cash', 'View · Print'],
      ['INV-002', 'Ali Raza', 'Tommy', 'Rs 750.00', 'Card', 'View · Print'],
      ['INV-003', 'Hina Khan', 'Kitty', 'Rs 180.00', 'Online', 'View · Print'],
    ],
    footer: 'Showing 1-3 of 3',
  );
}
