import 'package:flutter/material.dart';

import '../../../core/network/api_client.dart';
import '../../dashboard/widgets/dashboard_summary_card.dart';
import '../../shared/presentation/api_clinic_table.dart';
import '../../shared/presentation/clinic_ui.dart';
import '../data/reports_api.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({this.reportsApi, super.key});

  final ReportsApi? reportsApi;

  @override
  Widget build(BuildContext context) {
    final api = reportsApi ?? ReportsApi();
    return ClinicPageFrame(
      title: 'Reports',
      subtitle: 'Live clinic, sales, inventory, purchase, and payment reports.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _DashboardSummary(loadSummary: api.dashboard),
          const SizedBox(height: 16),
          _DailySalesReport(loadRows: api.dailySales),
          const SizedBox(height: 16),
          ApiClinicTable(
            title: 'Monthly sales',
            columns: const ['Year', 'Month', 'Invoices', 'Total sales'],
            loadRows: api.monthlySales,
            mapRow: (row) => [
              apiCell(row, 'year'),
              apiCell(row, 'month'),
              apiCell(row, 'total_invoices'),
              'Rs ${apiCell(row, 'total_sales')}',
            ],
          ),
          const SizedBox(height: 16),
          ApiClinicTable(
            title: 'Top selling medicines',
            columns: const ['Medicine', 'Category', 'Units sold', 'Revenue'],
            loadRows: api.topMedicines,
            mapRow: (row) => [
              apiCell(row, 'med_name'),
              apiCell(row, 'med_category'),
              apiCell(row, 'total_qty_sold'),
              'Rs ${apiCell(row, 'total_revenue')}',
            ],
          ),
          const SizedBox(height: 16),
          ApiClinicTable(
            title: 'Sales by owner',
            columns: const ['Owner', 'Phone', 'Invoices', 'Total spent'],
            loadRows: api.ownerSales,
            mapRow: (row) => [
              apiCell(row, 'ow_name'),
              apiCell(row, 'ow_phone'),
              apiCell(row, 'total_invoices'),
              'Rs ${apiCell(row, 'total_spent')}',
            ],
          ),
          const SizedBox(height: 16),
          ApiClinicTable(
            title: 'Purchases by supplier',
            columns: const ['Supplier', 'Purchases', 'Items', 'Total amount'],
            loadRows: api.purchases,
            mapRow: (row) => [
              apiCell(row, 'sup_name'),
              apiCell(row, 'total_purchases'),
              apiCell(row, 'total_items'),
              'Rs ${apiCell(row, 'total_amount')}',
            ],
          ),
          const SizedBox(height: 16),
          ApiClinicTable(
            title: 'Payments',
            columns: const ['Method', 'Transactions', 'Total amount'],
            loadRows: api.payments,
            mapRow: (row) => [
              apiCell(row, 'pay_method'),
              apiCell(row, 'total_transactions'),
              'Rs ${apiCell(row, 'total_amount')}',
            ],
          ),
        ],
      ),
    );
  }
}

class _DashboardSummary extends StatefulWidget {
  const _DashboardSummary({required this.loadSummary});

  final Future<JsonMap> Function() loadSummary;

  @override
  State<_DashboardSummary> createState() => _DashboardSummaryState();
}

class _DashboardSummaryState extends State<_DashboardSummary> {
  late Future<JsonMap> _summary;

  @override
  void initState() {
    super.initState();
    _summary = widget.loadSummary();
  }

  void _reload() {
    setState(() {
      _summary = widget.loadSummary();
    });
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<JsonMap>(
    future: _summary,
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return ClinicPanel(
          title: 'Clinic summary',
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
                label: const Text('Retry'),
              ),
            ],
          ),
        );
      }

      final data = snapshot.data;
      final values = [
        ('Owners', data?['total_owners'], const Color(0xFF0F766E)),
        ('Animals', data?['total_animals'], const Color(0xFFF97360)),
        ('Medicines', data?['total_medicines'], const Color(0xFFF59E0B)),
        ('Sales', data?['total_sales'], const Color(0xFF3B82F6)),
        ('Revenue', data?['total_revenue'], const Color(0xFF8B5CF6)),
        ('Low stock', data?['low_stock_count'], const Color(0xFFEF4444)),
        ('Expired batches', data?['expired_count'], const Color(0xFF64748B)),
      ];

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (data == null) const LinearProgressIndicator(minHeight: 2),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth < 500
                  ? 2
                  : constraints.maxWidth < 850
                  ? 3
                  : 4;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: values.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 2.2,
                ),
                itemBuilder: (context, index) {
                  final (title, value, accent) = values[index];
                  return DashboardSummaryCard(
                    title: title,
                    value: value == null ? '—' : _formatNumber(value),
                    accent: accent,
                  );
                },
              );
            },
          ),
          if (snapshot.hasError)
            TextButton.icon(
              onPressed: _reload,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry summary'),
            ),
        ],
      );
    },
  );
}

class _DailySalesReport extends StatefulWidget {
  const _DailySalesReport({required this.loadRows});

  final Future<List<JsonMap>> Function() loadRows;

  @override
  State<_DailySalesReport> createState() => _DailySalesReportState();
}

class _DailySalesReportState extends State<_DailySalesReport> {
  late Future<List<JsonMap>> _rows;

  @override
  void initState() {
    super.initState();
    _rows = widget.loadRows();
  }

  void _reload() {
    setState(() {
      _rows = widget.loadRows();
    });
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<List<JsonMap>>(
    future: _rows,
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return ClinicPanel(
          title: 'Daily sales',
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
                label: const Text('Retry'),
              ),
            ],
          ),
        );
      }
      if (!snapshot.hasData) {
        return const ClinicPanel(
          title: 'Daily sales',
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(),
            ),
          ),
        );
      }

      final rows = snapshot.data!;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _DailySalesChart(rows: rows),
          const SizedBox(height: 16),
          ClinicTable(
            title: 'Daily sales',
            columns: const [
              'Sale date',
              'Invoices',
              'Subtotal',
              'Discount',
              'Total sales',
            ],
            rows: rows
                .map(
                  (row) => [
                    _formatDate(row['sale_date']),
                    apiCell(row, 'total_invoices'),
                    'Rs ${apiCell(row, 'subtotal')}',
                    'Rs ${apiCell(row, 'total_discount')}',
                    'Rs ${apiCell(row, 'total_sales')}',
                  ],
                )
                .toList(growable: false),
          ),
        ],
      );
    },
  );
}

class _DailySalesChart extends StatelessWidget {
  const _DailySalesChart({required this.rows});

  final List<JsonMap> rows;

  @override
  Widget build(BuildContext context) {
    final recent = rows.take(7).toList().reversed.toList();
    final amounts = recent
        .map((row) => _asNumber(row['total_sales']))
        .toList(growable: false);
    final maximum = amounts.fold<double>(
      0,
      (max, value) => value > max ? value : max,
    );

    return ClinicPanel(
      title: 'Daily sales trend',
      child: SizedBox(
        height: 210,
        child: amounts.isEmpty
            ? const Center(child: Text('No daily sales data available.'))
            : Column(
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        for (var index = 0; index < recent.length; index++)
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                              ),
                              child: Tooltip(
                                message:
                                    '${_formatDate(recent[index]['sale_date'])}: '
                                    'Rs ${_formatNumber(amounts[index])}',
                                child: FractionallySizedBox(
                                  heightFactor: maximum == 0
                                      ? 0
                                      : amounts[index] / maximum,
                                  alignment: Alignment.bottomCenter,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF0F766E),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: const SizedBox.expand(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      for (final row in recent)
                        Expanded(
                          child: Text(
                            _formatDate(row['sale_date']),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}

String _formatDate(Object? value) {
  if (value == null) return '—';
  final parsed = DateTime.tryParse(value.toString());
  if (parsed == null) return value.toString();
  final month = parsed.month.toString().padLeft(2, '0');
  final day = parsed.day.toString().padLeft(2, '0');
  return '${parsed.year}-$month-$day';
}

String _formatNumber(Object value) {
  final number = _asNumber(value);
  if (number == number.roundToDouble()) return number.toStringAsFixed(0);
  return number.toStringAsFixed(2);
}

double _asNumber(Object? value) {
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0;
}
