import 'package:flutter/material.dart';

import '../../shared/presentation/clinic_ui.dart';

class PrescriptionsPage extends StatelessWidget {
  const PrescriptionsPage({super.key});
  @override
  Widget build(BuildContext context) => ClinicDataPage(
    title: 'Prescriptions',
    action: 'Add prescription',
    columns: const [
      'Medicine',
      'Dosage',
      'Duration',
      'Diagnosis',
      'Notes',
      'Actions',
    ],
    rows: const [
      [
        'Amoxicillin 500mg',
        '1 tablet, twice daily',
        '5 days',
        'Viral infection',
        'Give with food',
        'View',
      ],
      [
        'Rabies vaccine',
        '1 dose',
        'Annual',
        'Vaccination',
        'Booster due Oct 2027',
        'View',
      ],
      [
        'Deworming tablet',
        '1 tablet',
        'Once',
        'Routine care',
        'Repeat in 3 months',
        'View',
      ],
    ],
    onAction: () =>
        showClinicNotice(context, 'Prescription form is ready to complete.'),
  );
}
