import 'package:flutter/material.dart';

import '../data/inventory_api.dart';
import '../../shared/presentation/api_clinic_table.dart';
import '../../shared/presentation/clinic_ui.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});
  @override
  Widget build(BuildContext context) => ClinicPageFrame(
    title: 'Inventory',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ClinicTabs(labels: ['Stock', 'Low stock', 'Expired', 'Logs']),
        const SizedBox(height: 16),
        const ClinicStatsGrid(
          items: [
            ('Medicines', '5', clinicTeal),
            ('Low stock', '1', Color(0xFFF59E0B)),
            ('Out of stock', '1', Color(0xFFEF4444)),
            ('Expired batches', '0', Color(0xFF3B82F6)),
          ],
        ),
        const SizedBox(height: 16),
        ApiClinicTable(
          title: 'Stock overview',
          columns: const [
            'Medicine',
            'Category',
            'Stock',
            'Reorder at',
            'Price',
            'Status',
          ],
          loadRows: InventoryApi().stock,
          mapRow: (medicine) => [
            apiCell(medicine, 'med_name'),
            apiCell(medicine, 'med_category'),
            apiCell(medicine, 'med_stock'),
            apiCell(medicine, 'med_reorder_level'),
            'Rs ${apiCell(medicine, 'med_sale_price')}',
            apiCell(medicine, 'stock_status'),
          ],
        ),
      ],
    ),
  );
}
