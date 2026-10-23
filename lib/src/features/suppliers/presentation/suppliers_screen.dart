import 'package:flutter/material.dart';

import '../../shared/presentation/clinic_ui.dart';

class SuppliersPage extends StatelessWidget {
  const SuppliersPage({super.key});
  @override
  Widget build(BuildContext context) => ClinicDataPage(
    title: 'Suppliers',
    action: 'Add supplier',
    columns: const [
      'ID',
      'Name',
      'Company',
      'Contact',
      'Address',
      'Status',
      'Actions',
    ],
    rows: const [
      [
        'SUP-001',
        'Imran Qureshi',
        'PetCare Distributors',
        '+92 300 1112233',
        'Gulberg, Lahore',
        'Active',
        'View · Edit',
      ],
      [
        'SUP-002',
        'Sana Mahmood',
        'MediVet Supplies',
        '+92 321 2223344',
        'Clifton, Karachi',
        'Active',
        'View · Edit',
      ],
      [
        'SUP-003',
        'Usman Tariq',
        'Animal Health Co.',
        '+92 333 3334455',
        'Blue Area, Islamabad',
        'Active',
        'View · Edit',
      ],
    ],
    onAction: () =>
        showClinicNotice(context, 'Supplier form is ready to complete.'),
  );
}
