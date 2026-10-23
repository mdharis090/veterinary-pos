import 'package:flutter/material.dart';

import '../../shared/presentation/clinic_ui.dart';

class PatientsListPage extends StatelessWidget {
  const PatientsListPage({this.onNavigate, super.key});
  final ValueChanged<String>? onNavigate;
  @override
  Widget build(BuildContext context) => ClinicDataPage(
    title: 'Patients',
    action: 'Add animal',
    columns: const [
      'ID',
      'Name',
      'Species / Breed',
      'Owner',
      'Weight',
      'Status',
      'Actions',
    ],
    rows: const [
      [
        'PAT-001',
        'Nyxie',
        'Dog · German Shepherd',
        'Sara Krugs',
        '78 lbs',
        'Active',
        'View',
      ],
      [
        'PAT-002',
        'Tommy',
        'Dog · Labrador',
        'Ali Raza',
        '62 lbs',
        'Active',
        'View',
      ],
      [
        'PAT-003',
        'Kitty',
        'Cat · Persian',
        'Hina Khan',
        '9 lbs',
        'Active',
        'View',
      ],
      [
        'PAT-004',
        'Rocky',
        'Dog · Beagle',
        'Ahmed Malik',
        '24 lbs',
        'Follow-up',
        'View',
      ],
    ],
    footer: 'Showing 1-4 of 4',
    onAction: () =>
        showClinicNotice(context, 'Animal form is ready to complete.'),
    onRowTap: (_) => onNavigate?.call('Patient profile'),
  );
}
