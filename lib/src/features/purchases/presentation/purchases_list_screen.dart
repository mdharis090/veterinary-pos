import 'package:flutter/material.dart';

import '../../../core/routes/app_routes_named.dart';
import '../data/purchases_api.dart';
import '../../shared/presentation/api_clinic_table.dart';
import '../../shared/presentation/clinic_ui.dart';

class PurchasesPage extends StatefulWidget {
  const PurchasesPage({super.key});

  @override
  State<PurchasesPage> createState() => _PurchasesPageState();
}

class _PurchasesPageState extends State<PurchasesPage> {
  int _refreshKey = 0;

  Future<void> _newPurchase() async {
    final saved = await Navigator.of(
      context,
    ).pushNamed<bool>(AppRoutesNamed.newPurchase);
    if (saved == true && mounted) {
      setState(() => _refreshKey++);
    }
  }

  @override
  Widget build(BuildContext context) => ClinicPageFrame(
    title: 'Purchases',
    subtitle: 'Review supplier invoices and received stock.',
    action: ClinicPrimaryButton(
      label: 'New purchase',
      icon: Icons.add,
      onPressed: _newPurchase,
    ),
    child: ApiClinicTable(
      key: ValueKey(_refreshKey),
      title: 'Purchase history',
      columns: const [
        'ID',
        'Invoice',
        'Supplier',
        'Date',
        'Subtotal',
        'Discount',
        'Total',
        'Payment',
      ],
      loadRows: PurchasesApi().list,
      mapRow: (purchase) => [
        apiCell(purchase, 'purchase_id'),
        apiCell(purchase, 'pur_invoice_no'),
        apiCell(purchase, 'sup_name'),
        apiCell(purchase, 'pur_purchase_date'),
        'Rs ${apiCell(purchase, 'pur_subtotal')}',
        'Rs ${apiCell(purchase, 'pur_discount')}',
        'Rs ${apiCell(purchase, 'pur_total_amount')}',
        apiCell(purchase, 'pur_payment_status'),
      ],
    ),
  );
}
