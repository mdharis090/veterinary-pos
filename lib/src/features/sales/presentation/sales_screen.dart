import 'package:flutter/material.dart';

import '../data/sales_api.dart';
import '../../shared/presentation/api_clinic_table.dart';
import '../../shared/presentation/clinic_ui.dart';

class SalesPage extends StatelessWidget {
  const SalesPage({super.key});
  @override
  Widget build(BuildContext context) => ClinicPageFrame(
    title: 'Sales',
    child: ApiClinicTable(
      title: 'Sales',
      columns: const ['Invoice', 'Owner', 'Animal', 'Total', 'Payment'],
      loadRows: SalesApi().list,
      mapRow: (sale) => [
        apiCell(sale, 'sal_invoice_no'),
        apiCell(sale, 'owner_name'),
        apiCell(sale, 'animal_name'),
        'Rs ${apiCell(sale, 'sal_total')}',
        apiCell(sale, 'sal_payment_method'),
      ],
    ),
  );
}
