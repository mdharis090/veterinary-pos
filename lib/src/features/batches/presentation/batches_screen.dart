import 'package:flutter/material.dart';

import '../data/batches_api.dart';
import 'add_batch_dialog.dart';
import '../../shared/presentation/api_clinic_table.dart';
import '../../shared/presentation/clinic_ui.dart';

class BatchesPage extends StatefulWidget {
  const BatchesPage({super.key});

  @override
  State<BatchesPage> createState() => _BatchesPageState();
}

class _BatchesPageState extends State<BatchesPage> {
  int _refreshKey = 0;

  Future<void> _addBatch() async {
    final created = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AddBatchDialog(),
    );
    if (created == true && mounted) {
      setState(() => _refreshKey++);
    }
  }

  @override
  Widget build(BuildContext context) => ClinicPageFrame(
    title: 'Batches',
    action: ClinicPrimaryButton(
      label: 'Add batch',
      icon: Icons.add,
      onPressed: _addBatch,
    ),
    child: ApiClinicTable(
      key: ValueKey(_refreshKey),
      title: 'Batches',
      columns: const ['ID', 'Batch no', 'Medicine', 'Expiry', 'Quantity'],
      loadRows: BatchesApi().list,
      mapRow: (batch) => [
        apiCell(batch, 'batch_id'),
        apiCell(batch, 'bat_batch_no'),
        apiCell(batch, 'med_name'),
        apiCell(batch, 'bat_expiry_date'),
        apiCell(batch, 'bat_quantity'),
      ],
    ),
  );
}
