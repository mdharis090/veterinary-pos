import 'package:flutter/material.dart';

import '../data/batches_api.dart';
import '../../shared/presentation/api_clinic_table.dart';
import '../../shared/presentation/clinic_ui.dart';

class BatchesPage extends StatelessWidget {
  const BatchesPage({super.key});
  @override
  Widget build(BuildContext context) => ClinicPageFrame(
    title: 'Batches',
    action: ClinicPrimaryButton(
      label: 'Add batch',
      icon: Icons.add,
      onPressed: () =>
          showClinicNotice(context, 'Batch form is ready to complete.'),
    ),
    child: ApiClinicTable(
      title: 'Batches',
      columns: const ['Batch no', 'Medicine', 'Expiry', 'Qty'],
      loadRows: BatchesApi().list,
      mapRow: (batch) => [
        apiCell(batch, 'bat_batch_no'),
        apiCell(batch, 'med_name'),
        apiCell(batch, 'bat_expiry_date'),
        apiCell(batch, 'bat_quantity'),
      ],
    ),
  );
}
