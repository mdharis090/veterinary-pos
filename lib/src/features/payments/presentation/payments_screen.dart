import 'package:flutter/material.dart';

import '../../../core/network/api_client.dart';
import '../data/payments_api.dart';
import '../../shared/presentation/api_clinic_table.dart';
import '../../shared/presentation/clinic_ui.dart';

class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({this.paymentsApi, super.key});

  final PaymentsApi? paymentsApi;

  @override
  Widget build(BuildContext context) => ClinicPageFrame(
    title: 'Payments',
    subtitle: 'Review payments recorded against sales.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ApiClinicTable(
          title: 'Recent payments',
          columns: const [
            'Payment ID',
            'Invoice',
            'Amount',
            'Method',
            'Reference',
            'Date',
          ],
          loadRows: (paymentsApi ?? PaymentsApi()).list,
          mapRow: (payment) => [
            apiCell(payment, 'payment_id'),
            apiCell(payment, 'sal_invoice_no'),
            _formatPaymentAmount(payment['pay_amount']),
            apiCell(payment, 'pay_method'),
            apiCell(payment, 'pay_reference'),
            _formatPaymentDate(payment['pay_date']),
          ],
        ),
      ],
    ),
  );
}

String _formatPaymentAmount(Object? value) {
  if (value == null || value.toString().isEmpty) return '—';
  final amount = value is num ? value : num.tryParse(value.toString());
  return amount == null ? 'Rs $value' : 'Rs ${amount.toStringAsFixed(2)}';
}

String _formatPaymentDate(Object? value) {
  if (value == null || value.toString().isEmpty) return '—';
  final parsed = DateTime.tryParse(value.toString());
  if (parsed == null) return value.toString();
  final date = parsed.toLocal();
  return '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')}/${date.year}';
}
