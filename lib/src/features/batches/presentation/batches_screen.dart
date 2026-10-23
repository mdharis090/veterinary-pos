import 'package:flutter/material.dart';

import '../../shared/presentation/clinic_ui.dart';

class BatchesPage extends StatelessWidget {
  const BatchesPage({super.key});
  @override
  Widget build(BuildContext context) => ClinicDataPage(
    title: 'Batches',
    action: 'Add batch',
    columns: const [
      'Batch no',
      'Medicine',
      'Expiry',
      'Qty',
      'Status',
      'Actions',
    ],
    rows: const [
      [
        'AMX-2408',
        'Amoxicillin 500mg',
        '20 Dec 2026',
        '15',
        'Expiring soon',
        'View',
      ],
      ['RAB-2531', 'Rabies vaccine', '14 Mar 2027', '38', 'Valid', 'View'],
      ['DWR-1720', 'Deworming tablet', '03 Aug 2027', '64', 'Valid', 'View'],
      ['FLT-1022', 'Flea treatment', '12 Sep 2026', '0', 'Expired', 'View'],
    ],
    onAction: () =>
        showClinicNotice(context, 'Batch form is ready to complete.'),
  );
}
