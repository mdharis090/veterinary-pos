import 'package:flutter/material.dart';

import '../data/payments_api.dart';
import '../../shared/presentation/api_clinic_table.dart';
import '../../shared/presentation/clinic_ui.dart';

class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({super.key});
  @override
  Widget build(BuildContext context) => ClinicPageFrame(
    title: 'Payments',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ApiClinicTable(
          title: 'Recent payments',
          columns: const ['ID', 'Invoice', 'Amount', 'Method'],
          loadRows: PaymentsApi().list,
          mapRow: (payment) => [
            apiCell(payment, 'payment_id'),
            apiCell(payment, 'sal_invoice_no'),
            'Rs ${apiCell(payment, 'pay_amount')}',
            apiCell(payment, 'pay_method'),
          ],
        ),
      ],
    ),
  );
}
