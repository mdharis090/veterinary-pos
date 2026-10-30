import 'package:flutter/material.dart';

import '../../../core/network/api_client.dart';
import '../data/inventory_api.dart';
import '../../shared/presentation/api_clinic_table.dart';
import '../../shared/presentation/clinic_ui.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  static const _tabs = ['Stock', 'Low stock', 'Expired', 'Logs'];
  static const _stockColumns = [
    'Medicine',
    'Category',
    'Stock',
    'Reorder at',
    'Price',
    'Status',
  ];
  static const _expiredColumns = [
    'Batch',
    'Medicine',
    'Expiry date',
    'Quantity',
    'Status',
  ];
  static const _logColumns = [
    'Date',
    'Medicine',
    'Action',
    'Quantity',
    'Details',
  ];
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) =>
      ClinicPageFrame(title: 'Inventory', child: _buildContent());

  Widget _buildContent() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      _buildTabs(),
      const SizedBox(height: 16),
      _buildStats(),
      const SizedBox(height: 16),
      _buildSelectedTable(),
    ],
  );

  Widget _buildTabs() => ClinicTabs(
    labels: _tabs,
    selectedIndex: _selectedTab,
    onSelected: (index) => setState(() => _selectedTab = index),
  );

  Widget _buildStats() => const ClinicStatsGrid(
    items: [
      ('Medicines', '5', clinicTeal),
      ('Low stock', '1', Color(0xFFF59E0B)),
      ('Out of stock', '1', Color(0xFFEF4444)),
      ('Expired batches', '0', Color(0xFF3B82F6)),
    ],
  );

  Widget _buildSelectedTable() {
    final api = InventoryApi();
    switch (_selectedTab) {
      case 1:
        return ApiClinicTable(
          key: const ValueKey('low-stock'),
          title: 'Low stock',
          columns: _stockColumns,
          loadRows: api.lowStock,
          mapRow: _mapStockRow,
        );
      case 2:
        return ApiClinicTable(
          key: const ValueKey('expired'),
          title: 'Expired stock',
          columns: _expiredColumns,
          loadRows: api.expired,
          mapRow: _mapExpiredRow,
        );
      case 3:
        return ApiClinicTable(
          key: const ValueKey('logs'),
          title: 'Inventory logs',
          columns: _logColumns,
          loadRows: api.logs,
          mapRow: _mapLogRow,
        );
      default:
        return ApiClinicTable(
          key: const ValueKey('stock'),
          title: 'Stock overview',
          columns: _stockColumns,
          loadRows: api.stock,
          mapRow: _mapStockRow,
        );
    }
  }

  List<String> _mapStockRow(JsonMap medicine) => [
    apiCell(medicine, 'med_name'),
    apiCell(medicine, 'med_category'),
    apiCell(medicine, 'med_stock'),
    apiCell(medicine, 'med_reorder_level'),
    'Rs ${apiCell(medicine, 'med_sale_price')}',
    _stockStatus(medicine),
  ];

  List<String> _mapExpiredRow(JsonMap batch) => [
    _cellFrom(batch, const ['bat_batch_no', 'batch_no', 'batch_id']),
    _cellFrom(batch, const ['med_name', 'medicine_name']),
    _cellFrom(batch, const ['bat_expiry_date', 'expiry_date']),
    _cellFrom(batch, const ['bat_quantity', 'quantity', 'stock']),
    _cellFrom(batch, const ['status', 'stock_status'], fallback: 'Expired'),
  ];

  List<String> _mapLogRow(JsonMap log) => [
    _cellFrom(log, const ['created_at', 'log_date', 'date']),
    _cellFrom(log, const ['med_name', 'medicine_name']),
    _cellFrom(log, const ['action', 'transaction_type', 'log_type', 'type']),
    _cellFrom(log, const ['quantity', 'change_quantity', 'stock_change']),
    _cellFrom(log, const ['details', 'notes', 'description']),
  ];

  String _stockStatus(JsonMap medicine) {
    final status = medicine['stock_status'];
    if (status != null && status.toString().isNotEmpty) {
      return status.toString();
    }
    final stock = num.tryParse(medicine['med_stock']?.toString() ?? '');
    final reorder = num.tryParse(
      medicine['med_reorder_level']?.toString() ?? '',
    );
    if (stock == null || reorder == null) return '—';
    if (stock <= 0) return 'Out of stock';
    if (stock <= reorder) return 'Low stock';
    return 'In stock';
  }

  String _cellFrom(JsonMap record, List<String> keys, {String fallback = '—'}) {
    for (final key in keys) {
      final value = record[key];
      if (value != null && value.toString().isNotEmpty) {
        return value.toString();
      }
    }
    return fallback;
  }
}
