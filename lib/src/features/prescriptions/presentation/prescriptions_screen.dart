import 'package:flutter/material.dart';

import '../data/prescriptions_api.dart';
import 'add_prescription_dialog.dart';
import '../../shared/presentation/api_clinic_table.dart';
import '../../shared/presentation/clinic_ui.dart';

class PrescriptionsPage extends StatefulWidget {
  const PrescriptionsPage({super.key});

  @override
  State<PrescriptionsPage> createState() => _PrescriptionsPageState();
}

class _PrescriptionsPageState extends State<PrescriptionsPage> {
  int _refreshKey = 0;

  Future<void> _addPrescription() async {
    final saved = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AddPrescriptionDialog(),
    );
    if (saved == true && mounted) {
      setState(() => _refreshKey++);
    }
  }

  @override
  Widget build(BuildContext context) => ClinicPageFrame(
    title: 'Prescriptions',
    action: ClinicPrimaryButton(
      label: 'Add prescription',
      icon: Icons.add,
      onPressed: _addPrescription,
    ),
    child: ApiClinicTable(
      key: ValueKey(_refreshKey),
      title: 'Prescriptions',
      columns: const [
        'ID',
        'Consultation',
        'Medicine',
        'Dosage',
        'Duration',
        'Diagnosis',
        'Notes',
      ],
      loadRows: PrescriptionsApi().list,
      mapRow: (prescription) => [
        apiCell(prescription, 'prescription_id'),
        apiCell(prescription, 'consultation_id'),
        apiCell(prescription, 'med_name'),
        apiCell(prescription, 'pre_dosage'),
        apiCell(prescription, 'pre_duration'),
        apiCell(prescription, 'con_diagnosis'),
        apiCell(prescription, 'pre_notes'),
      ],
    ),
  );
}
