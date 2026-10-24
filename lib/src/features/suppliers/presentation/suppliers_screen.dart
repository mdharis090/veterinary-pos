import 'package:flutter/material.dart';

import '../data/suppliers_api.dart';
import '../../shared/presentation/api_clinic_table.dart';
import '../../shared/presentation/clinic_ui.dart';

class SuppliersPage extends StatelessWidget {
  const SuppliersPage({super.key});
  @override
  Widget build(BuildContext context) => ClinicPageFrame(
    title: 'Suppliers',
    action: ClinicPrimaryButton(
      label: 'Add supplier',
      icon: Icons.add,
      onPressed: () =>
          showClinicNotice(context, 'Supplier form is ready to complete.'),
    ),
    child: ApiClinicTable(
      title: 'Suppliers',
      columns: const ['ID', 'Name', 'Company', 'Contact', 'Address', 'Status'],
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
