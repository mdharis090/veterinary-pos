import 'package:flutter/material.dart';

import '../../../core/network/api_client.dart';
import '../data/sales_api.dart';
import '../../shared/presentation/api_clinic_table.dart';
import '../../shared/presentation/clinic_ui.dart';

class SalesPage extends StatelessWidget {
  const SalesPage({super.key});

  @override
  Widget build(BuildContext context) => ClinicPageFrame(
    title: 'Sales',
    subtitle: 'POS invoices and payment details',
    child: ApiClinicTable(
      title: 'Sales',
      columns: const [
        'Invoice',
        'Sale date',
        'Owner',
        'Animal',
        'Subtotal',
        'Discount',
        'Total',
        'Method',
        'Status',
      ],
      loadRows: SalesApi().list,
      mapRow: (sale) => [
        apiCell(sale, 'sal_invoice_no'),
        _formatSaleDate(sale),
        apiCell(sale, 'owner_name'),
        apiCell(sale, 'animal_name'),
        _formatSaleAmount(sale, 'sal_subtotal'),
        _formatSaleAmount(sale, 'sal_discount'),
        _formatSaleAmount(sale, 'sal_total'),
        apiCell(sale, 'sal_payment_method'),
        apiCell(sale, 'sal_payment_status'),
      ],
    ),
  );
}

String _formatSaleDate(JsonMap sale) {
  final value = sale['sal_sale_date'] ?? sale['sal_created_at'];
  if (value == null || value.toString().isEmpty) return '—';

  final parsed = DateTime.tryParse(value.toString());
  if (parsed == null) return value.toString();

  final date = parsed.toLocal();
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  final hour = date.hour.toString().padLeft(2, '0');
  final minute = date.minute.toString().padLeft(2, '0');
  return '${date.day} ${months[date.month - 1]} ${date.year}, $hour:$minute';
}

String _formatSaleAmount(JsonMap sale, String key) {
  final value = sale[key];
  if (value == null || value.toString().isEmpty) return '—';

  final num? amount;
  if (value is num) {
    amount = value;
  } else {
    amount = num.tryParse(value.toString());
  }
  if (amount == null) return 'Rs $value';
  return 'Rs ${amount.toStringAsFixed(2)}';
}
