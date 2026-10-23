import 'package:flutter/material.dart';

import '../../shared/presentation/clinic_ui.dart';

class OwnersPage extends StatelessWidget {
  const OwnersPage({super.key});
  @override
  Widget build(BuildContext context) => ClinicDataPage(
    title: 'Owners',
    action: 'Add owner',
    columns: const ['ID', 'Name', 'Phone', 'City', 'Actions'],
    rows: const [
      ['OWN-001', 'Sara Krugs', '+92 300 1234567', 'Lahore', 'View · Edit'],
      ['OWN-002', 'Ali Raza', '+92 321 2345678', 'Karachi', 'View · Edit'],
      ['OWN-003', 'Hina Khan', '+92 333 3456789', 'Islamabad', 'View · Edit'],
      ['OWN-004', 'Ahmed Malik', '+92 345 4567890', 'Lahore', 'View · Edit'],
      [
        'OWN-005',
        'Fatima Sheikh',
        '+92 312 5678901',
        'Faisalabad',
        'View · Edit',
      ],
    ],
    footer: 'Showing 1-5 of 5',
    onAction: () =>
        showClinicNotice(context, 'Owner form is ready to complete.'),
  );
}
