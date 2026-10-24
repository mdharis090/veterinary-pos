import 'package:flutter/material.dart';

import '../data/suppliers_api.dart';
import 'add_supplier_dialog.dart';
import '../../shared/presentation/api_clinic_table.dart';
import '../../shared/presentation/clinic_ui.dart';

class SuppliersPage extends StatefulWidget {
  const SuppliersPage({super.key});

  @override
  State<SuppliersPage> createState() => _SuppliersPageState();
}

class _SuppliersPageState extends State<SuppliersPage> {
  int _refreshKey = 0;

  Future<void> _addSupplier() async {
    final created = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AddSupplierDialog(),
    );
    if (created == true && mounted) {
      setState(() => _refreshKey++);
    }
  }

  @override
  Widget build(BuildContext context) => ClinicPageFrame(
    title: 'Suppliers',
    subtitle: 'Manage supplier contacts and company details.',
    action: ClinicPrimaryButton(
      label: 'Add supplier',
      icon: Icons.add,
      onPressed: _addSupplier,
    ),
    child: ApiClinicTable(
      key: ValueKey(_refreshKey),
      title: 'Suppliers',
      columns: const [
        'ID',
        'Supplier name',
        'Company',
        'Contact',
        'Address',
        'Status',
      ],
      loadRows: SuppliersApi().list,
      mapRow: (supplier) => [
        apiCell(supplier, 'supplier_id'),
        apiCell(supplier, 'sup_name'),
        apiCell(supplier, 'sup_company'),
        apiCell(supplier, 'sup_contact'),
        apiCell(supplier, 'sup_address'),
        apiCell(supplier, 'sup_status'),
      ],
    ),
  );
}
