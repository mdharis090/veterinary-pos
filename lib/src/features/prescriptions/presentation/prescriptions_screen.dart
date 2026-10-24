import 'package:flutter/material.dart';

import '../data/prescriptions_api.dart';
import '../../shared/presentation/api_clinic_table.dart';
import '../../shared/presentation/clinic_ui.dart';

class PrescriptionsPage extends StatelessWidget {
  const PrescriptionsPage({super.key});
  @override
  Widget build(BuildContext context) => ClinicPageFrame(
    title: 'Prescriptions',
    action: ClinicPrimaryButton(
      label: 'Add prescription',
      icon: Icons.add,
      onPressed: () =>
          showClinicNotice(context, 'Prescription form is ready to complete.'),
    ),
    child: ApiClinicTable(
      title: 'Prescriptions',
      columns: const ['Medicine', 'Dosage', 'Duration', 'Diagnosis', 'Notes'],
      loadRows: PrescriptionsApi().list,
      mapRow: (prescription) => [
        apiCell(prescription, 'med_name'),
        apiCell(prescription, 'pre_dosage'),
        apiCell(prescription, 'pre_duration'),
        apiCell(prescription, 'con_diagnosis'),
        apiCell(prescription, 'pre_notes'),
      ],
    ),
  );
}
