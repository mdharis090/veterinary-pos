import 'package:flutter/material.dart';

import '../data/owners_api.dart';
import '../../shared/presentation/api_clinic_table.dart';
import '../../shared/presentation/clinic_ui.dart';

class OwnersPage extends StatelessWidget {
  const OwnersPage({super.key});
  @override
  Widget build(BuildContext context) => ClinicPageFrame(
    title: 'Owners',
    action: ClinicPrimaryButton(
      label: 'Add owner',
      icon: Icons.add,
      onPressed: () =>
          showClinicNotice(context, 'Owner form is ready to complete.'),
    ),
    child: ApiClinicTable(
      title: 'Owners',
      columns: const ['ID', 'Name', 'Phone', 'Address'],
      loadRows: OwnersApi().list,
      mapRow: (owner) => [
        apiCell(owner, 'owner_id'),
        apiCell(owner, 'ow_name'),
        apiCell(owner, 'ow_phone'),
        apiCell(owner, 'ow_address'),
      ],
    ),
  );
}
