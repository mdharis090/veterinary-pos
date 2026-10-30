import 'package:flutter/material.dart';

import '../data/purchases_api.dart';
import '../../shared/presentation/api_clinic_table.dart';
import '../../shared/presentation/clinic_ui.dart';
import 'purchase_screens.dart';

class PurchasesPage extends StatefulWidget {
  const PurchasesPage({super.key});

  @override
  State<PurchasesPage> createState() => _PurchasesPageState();
}

class _PurchasesPageState extends State<PurchasesPage> {
  int _refreshKey = 0;
  bool _showNewPurchase = false;

  void _newPurchase() => setState(() => _showNewPurchase = true);

  void _closeNewPurchase({bool saved = false}) {
    setState(() {
      _showNewPurchase = false;
      if (saved) _refreshKey++;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showNewPurchase) {
      return NewPurchaseScreen(
        onBack: () => _closeNewPurchase(),
        onSaved: () => _closeNewPurchase(saved: true),
      );
    }

    return ClinicPageFrame(
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
          _purchaseDate(purchase),
          'Rs ${apiCell(purchase, 'pur_subtotal')}',
          'Rs ${apiCell(purchase, 'pur_discount')}',
          'Rs ${apiCell(purchase, 'pur_total_amount')}',
          apiCell(purchase, 'pur_payment_status'),
        ],
      ),
    );
  }

  String _purchaseDate(Map<String, dynamic> purchase) {
    final date = purchase['pur_purchase_date'] ?? purchase['pur_created_at'];
    if (date == null || date.toString().isEmpty) return '—';
    return date.toString();
  }
}
