import 'package:flutter/material.dart';

import '../data/owners_api.dart';
import 'add_owner_dialog.dart';
import '../../shared/presentation/api_clinic_table.dart';
import '../../shared/presentation/clinic_ui.dart';

class OwnersPage extends StatefulWidget {
  const OwnersPage({super.key});

  @override
  State<OwnersPage> createState() => _OwnersPageState();
}

class _OwnersPageState extends State<OwnersPage> {
  int _refreshKey = 0;

  Future<void> _addOwner() async {
    final created = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AddOwnerDialog(),
    );
    if (created == true && mounted) {
      setState(() => _refreshKey++);
    }
  }

  @override
  Widget build(BuildContext context) => ClinicPageFrame(
    title: 'Owners',
    action: ClinicPrimaryButton(
      label: 'Add owner',
      icon: Icons.add,
      onPressed: _addOwner,
    ),
    child: ApiClinicTable(
      key: ValueKey(_refreshKey),
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
