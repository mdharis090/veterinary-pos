import 'package:flutter/material.dart';

import '../../../core/network/api_client.dart';
import '../data/sales_api.dart';
import '../../shared/presentation/api_clinic_table.dart';
import '../../shared/presentation/clinic_ui.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({this.onNavigate, this.salesApi, super.key});

  final ValueChanged<String>? onNavigate;
  final SalesApi? salesApi;

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  static const _allStatuses = '__all_statuses__';

  final _searchController = TextEditingController();
  late final SalesApi _salesApi;
  late Future<List<JsonMap>> _sales;
  String _statusFilter = _allStatuses;

  @override
  void initState() {
    super.initState();
    _salesApi = widget.salesApi ?? SalesApi();
    _sales = _salesApi.list();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _reload() {
    setState(() {
      _sales = _salesApi.list();
    });
  }

  void _clearFilters() {
    _searchController.clear();
    setState(() => _statusFilter = _allStatuses);
  }

  @override
  Widget build(BuildContext context) => ClinicPageFrame(
    title: 'Sales',
    subtitle: 'Find invoices, check payment status, or start a new sale.',
    action: widget.onNavigate == null
        ? null
        : FilledButton.icon(
            onPressed: () => widget.onNavigate!('POS Billing'),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('New sale'),
            style: FilledButton.styleFrom(
              backgroundColor: clinicTeal,
              minimumSize: const Size(0, 44),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFilters(),
        const SizedBox(height: 16),
        FutureBuilder<List<JsonMap>>(
          future: _sales,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return ClinicPanel(
                title: 'Sales',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      snapshot.error.toString(),
                      style: const TextStyle(color: Color(0xFFB91C1C)),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: _reload,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try again'),
                    ),
                  ],
                ),
              );
            }
            if (!snapshot.hasData) {
              return const ClinicPanel(
                title: 'Sales',
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            }

            final records = snapshot.data!;
            final statuses = _statuses(records);
            final selectedStatus = statuses.contains(_statusFilter)
                ? _statusFilter
                : _allStatuses;
            final filteredSales = records
                .where((sale) {
                  final query = _searchController.text.trim().toLowerCase();
                  final matchesSearch =
                      query.isEmpty ||
                      [
                        sale['sal_invoice_no'],
                        sale['owner_name'],
                        sale['animal_name'],
                        sale['sal_payment_method'],
                        sale['sal_payment_status'],
                        sale['sal_sale_date'],
                        sale['sal_created_at'],
                      ].any(
                        (value) =>
                            value.toString().toLowerCase().contains(query),
                      );
                  final status = apiCell(sale, 'sal_payment_status');
                  final matchesStatus =
                      selectedStatus == _allStatuses ||
                      status == selectedStatus;
                  return matchesSearch && matchesStatus;
                })
                .toList(growable: false);

            if (records.isEmpty) {
              return const ClinicPanel(
                title: 'Sales',
                child: _SalesEmptyState(
                  title: 'No sales yet',
                  message: 'Completed sales will appear here.',
                ),
              );
            }
            if (filteredSales.isEmpty) {
              return ClinicPanel(
                title: 'Sales',
                child: _SalesEmptyState(
                  title: 'No matching sales',
                  message: 'Try a different search or payment status.',
                  onClear: _clearFilters,
                ),
              );
            }

            return LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 650;
                return ClinicPanel(
                  title: 'Sales',
                  trailing: Text(
                    '${filteredSales.length} of ${records.length}',
                    style: const TextStyle(color: clinicMuted, fontSize: 13),
                  ),
                  padding: EdgeInsets.zero,
                  child: compact
                      ? _MobileSalesList(sales: filteredSales)
                      : ClinicTable(
                          columns: const [
                            'Invoice',
                            'Sale date',
                            'Owner',
                            'Animal',
                            'Total',
                            'Status',
                          ],
                          rows: filteredSales
                              .map(
                                (sale) => [
                                  apiCell(sale, 'sal_invoice_no'),
                                  _formatSaleDate(sale),
                                  apiCell(sale, 'owner_name'),
                                  apiCell(sale, 'animal_name'),
                                  _formatSaleAmount(sale, 'sal_total'),
                                  apiCell(sale, 'sal_payment_status'),
                                ],
                              )
                              .toList(growable: false),
                          footer:
                              'Showing ${filteredSales.length} of ${records.length} sales',
                        ),
                );
              },
            );
          },
        ),
      ],
    ),
  );

  Widget _buildFilters() => LayoutBuilder(
    builder: (context, constraints) {
      final compact = constraints.maxWidth < 650;
      return ClinicPanel(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(
              width: compact ? constraints.maxWidth : 360,
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Search invoice, owner, or animal',
                  prefixIcon: const Icon(Icons.search, color: clinicMuted),
                  suffixIcon: _searchController.text.isEmpty
                      ? null
                      : IconButton(
                          tooltip: 'Clear search',
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                          icon: const Icon(Icons.close),
                        ),
                  isDense: true,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: clinicLine),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: clinicLine),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: compact ? constraints.maxWidth : 200,
              child: FutureBuilder<List<JsonMap>>(
                future: _sales,
                builder: (context, snapshot) {
                  final statuses = snapshot.hasData
                      ? _statuses(snapshot.data!)
                      : const <String>[];
                  final selected = statuses.contains(_statusFilter)
                      ? _statusFilter
                      : _allStatuses;
                  return DropdownButtonFormField<String>(
                    initialValue: selected,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: 'Payment status',
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: clinicLine),
                      ),
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: _allStatuses,
                        child: Text('All statuses'),
                      ),
                      for (final status in statuses)
                        DropdownMenuItem(value: status, child: Text(status)),
                    ],
                    onChanged: statuses.isEmpty
                        ? null
                        : (value) {
                            if (value != null) {
                              setState(() => _statusFilter = value);
                            }
                          },
                  );
                },
              ),
            ),
            OutlinedButton.icon(
              onPressed: _reload,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Refresh'),
              style: OutlinedButton.styleFrom(
                foregroundColor: clinicInk,
                minimumSize: const Size(0, 48),
                side: const BorderSide(color: clinicLine),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );

  List<String> _statuses(List<JsonMap> sales) {
    final statuses =
        sales
            .map((sale) => apiCell(sale, 'sal_payment_status'))
            .where((status) => status != '—')
            .toSet()
            .toList()
          ..sort();
    return statuses;
  }
}

class _MobileSalesList extends StatelessWidget {
  const _MobileSalesList({required this.sales});

  final List<JsonMap> sales;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      for (var index = 0; index < sales.length; index++) ...[
        if (index > 0) const Divider(height: 1, color: clinicLine),
        _MobileSaleCard(sale: sales[index]),
      ],
    ],
  );
}

class _MobileSaleCard extends StatelessWidget {
  const _MobileSaleCard({required this.sale});

  final JsonMap sale;

  @override
  Widget build(BuildContext context) {
    final status = apiCell(sale, 'sal_payment_status');
    final owner = apiCell(sale, 'owner_name');
    final animal = apiCell(sale, 'animal_name');
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  apiCell(sale, 'sal_invoice_no'),
                  style: const TextStyle(
                    color: clinicInk,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                _formatSaleAmount(sale, 'sal_total'),
                style: const TextStyle(
                  color: clinicInk,
                  fontWeight: FontWeight.w700,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '$owner  ·  $animal',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: clinicMuted),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  _formatSaleDate(sale),
                  style: const TextStyle(color: clinicMuted, fontSize: 12),
                ),
              ),
              _PaymentStatusBadge(label: status),
            ],
          ),
        ],
      ),
    );
  }
}

class _PaymentStatusBadge extends StatelessWidget {
  const _PaymentStatusBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final normalized = label.toLowerCase();
    final isPaid =
        normalized == 'paid' ||
        normalized == 'complete' ||
        normalized == 'completed';
    final color = isPaid ? const Color(0xFF065F46) : const Color(0xFF92400E);
    final background = isPaid
        ? const Color(0xFFD1FAE5)
        : const Color(0xFFFEF3C7);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _SalesEmptyState extends StatelessWidget {
  const _SalesEmptyState({
    required this.title,
    required this.message,
    this.onClear,
  });

  final String title;
  final String message;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 12),
    child: Center(
      child: Column(
        children: [
          const Icon(Icons.receipt_long_outlined, color: clinicMuted, size: 32),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              color: clinicInk,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: clinicMuted),
          ),
          if (onClear != null) ...[
            const SizedBox(height: 12),
            TextButton(onPressed: onClear, child: const Text('Clear filters')),
          ],
        ],
      ),
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
  final value = sale[key] ?? (key == 'sal_total' ? sale['total'] : null);
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
