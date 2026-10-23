import 'package:flutter/material.dart';

import '../../shared/presentation/clinic_ui.dart';

class MedicinesPage extends StatelessWidget {
  const MedicinesPage({super.key});
  @override
  Widget build(BuildContext context) => ClinicDataPage(
    title: 'Medicines',
    action: 'Add medicine',
    chips: const ['1 low stock', '1 expired'],
    columns: const ['ID', 'Name', 'Stock', 'Price', 'Status', 'Actions'],
    rows: const [
      [
        'MED-001',
        'Amoxicillin 500mg',
        '15',
        'Rs 10.00',
        'Low stock',
        'View · Edit',
      ],
      [
        'MED-002',
        'Rabies vaccine',
        '38',
        'Rs 250.00',
        'In stock',
        'View · Edit',
      ],
      [
        'MED-003',
        'Deworming tablet',
        '64',
        'Rs 75.00',
        'In stock',
        'View · Edit',
      ],
      ['MED-004', 'Flea treatment', '0', 'Rs 320.00', 'Expired', 'View · Edit'],
      [
        'MED-005',
        'Vitamin supplement',
        '42',
        'Rs 180.00',
        'In stock',
        'View · Edit',
      ],
    ],
    onAction: () =>
        showClinicNotice(context, 'Medicine form is ready to complete.'),
  );
}
