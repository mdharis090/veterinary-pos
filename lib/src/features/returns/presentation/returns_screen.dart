import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import '../../medicines/data/medicines_api.dart';
import '../../sales/data/sales_api.dart';
import '../../shared/presentation/api_clinic_table.dart';
import '../../shared/presentation/clinic_ui.dart';
import '../data/returns_api.dart';

class ReturnsScreen extends StatefulWidget {
  const ReturnsScreen({
    this.returnsApi,
    this.salesApi,
    this.medicinesApi,
    super.key,
  });

  final ReturnsApi? returnsApi;
  final SalesApi? salesApi;
  final MedicinesApi? medicinesApi;

  @override
  State<ReturnsScreen> createState() => _ReturnsScreenState();
}

class _ReturnsScreenState extends State<ReturnsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _refundController = TextEditingController();
  final _reasonController = TextEditingController();

  late final ReturnsApi _returnsApi;
  late final SalesApi _salesApi;
  late final MedicinesApi _medicinesApi;
  late Future<(List<JsonMap>, List<JsonMap>)> _lookups;

  int? _saleId;
  int? _medicineId;
  String? _submitError;
  bool _saving = false;
  int _refreshKey = 0;

  @override
  void initState() {
    super.initState();
    _returnsApi = widget.returnsApi ?? ReturnsApi();
    _salesApi = widget.salesApi ?? SalesApi();
    _medicinesApi = widget.medicinesApi ?? MedicinesApi();
    _lookups = _loadLookups();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _refundController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  Future<(List<JsonMap>, List<JsonMap>)> _loadLookups() async {
    final results = await Future.wait([_salesApi.list(), _medicinesApi.list()]);
    return (results[0], results[1]);
  }

  void _retryLookups() => setState(() => _lookups = _loadLookups());

  Future<void> _processReturn() async {
    if (!_formKey.currentState!.validate()) return;

    final quantity = int.parse(_quantityController.text.trim());
    final refundAmount = double.parse(_refundController.text.trim());
    setState(() {
      _saving = true;
      _submitError = null;
    });

    try {
      final result = await _returnsApi.create({
        'sale_id': _saleId,
        'medicine_id': _medicineId,
        'ret_qty': quantity,
        'ret_refund_amount': refundAmount,
        'ret_reason': _reasonController.text.trim(),
      });
      if (!mounted) return;
      setState(() {
        _saving = false;
        _saleId = null;
        _medicineId = null;
        _quantityController.clear();
        _refundController.clear();
        _reasonController.clear();
        _refreshKey++;
      });
      final returnId = result['return_id'];
      showClinicNotice(
        context,
        returnId == null
            ? 'Return processed successfully.'
            : 'Return #$returnId processed successfully.',
      );
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _submitError = error.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) => ClinicPageFrame(
    title: 'Returns',
    subtitle: 'Record a medicine return and refund against a sale.',
    child: LayoutBuilder(
      builder: (context, constraints) {
        final list = ApiClinicTable(
          key: ValueKey(_refreshKey),
          title: 'Recent returns',
          columns: const [
            'Return ID',
            'Sale',
            'Medicine',
            'Quantity',
            'Refund',
            'Reason',
            'Date',
          ],
          loadRows: _returnsApi.list,
          mapRow: (saleReturn) => [
            apiCell(saleReturn, 'return_id'),
            _returnSaleLabel(saleReturn),
            _returnMedicineLabel(saleReturn),
            apiCell(saleReturn, 'ret_qty'),
            _formatRefund(saleReturn['ret_refund_amount']),
            apiCell(saleReturn, 'ret_reason'),
            _formatReturnDate(saleReturn['ret_date']),
          ],
        );
        final form = _buildReturnForm();
        if (constraints.maxWidth < 960) {
          return Column(children: [form, const SizedBox(height: 16), list]);
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 6, child: list),
            const SizedBox(width: 16),
            Expanded(flex: 5, child: form),
          ],
        );
      },
    ),
  );

  Widget _buildReturnForm() => FutureBuilder<(List<JsonMap>, List<JsonMap>)>(
    future: _lookups,
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return ClinicPanel(
          title: 'New return',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                snapshot.error.toString(),
                style: const TextStyle(color: Color(0xFFB91C1C)),
              ),
              const SizedBox(height: 12),
              ClinicOutlineButton(
                label: 'Retry',
                icon: Icons.refresh,
                onPressed: _retryLookups,
              ),
            ],
          ),
        );
      }
      if (!snapshot.hasData) {
        return const ClinicPanel(
          title: 'New return',
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(),
            ),
          ),
        );
      }

      final sales = snapshot.data!.$1;
      final medicines = snapshot.data!.$2;
      final availableSales = sales
          .where((sale) => _recordId(sale, 'sale_id') != null)
          .toList(growable: false);
      final availableMedicines = medicines
          .where((medicine) => _recordId(medicine, 'medicine_id') != null)
          .toList(growable: false);
      return ClinicPanel(
        title: 'New return',
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<int>(
                initialValue: _saleId,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Sale / invoice',
                  border: OutlineInputBorder(),
                ),
                hint: const Text('Select a sale'),
                items: [
                  for (final sale in availableSales)
                    DropdownMenuItem(
                      value: _recordId(sale, 'sale_id'),
                      child: Text(
                        _saleOptionLabel(sale),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
                validator: (value) =>
                    value == null ? 'Select the original sale.' : null,
                onChanged: _saving
                    ? null
                    : (value) => setState(() => _saleId = value),
              ),
              if (availableSales.isEmpty) ...[
                const SizedBox(height: 6),
                const Text(
                  'No sales are available to return.',
                  style: TextStyle(color: Color(0xFFB91C1C), fontSize: 12),
                ),
              ],
              const SizedBox(height: 14),
              DropdownButtonFormField<int>(
                initialValue: _medicineId,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Medicine',
                  border: OutlineInputBorder(),
                ),
                hint: const Text('Select a medicine'),
                items: [
                  for (final medicine in availableMedicines)
                    DropdownMenuItem(
                      value: _recordId(medicine, 'medicine_id'),
                      child: Text(
                        _medicineOptionLabel(medicine),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
                validator: (value) => value == null
                    ? 'Select the medicine being returned.'
                    : null,
                onChanged: _saving
                    ? null
                    : (value) => setState(() => _medicineId = value),
              ),
              if (availableMedicines.isEmpty) ...[
                const SizedBox(height: 6),
                const Text(
                  'No medicines are available.',
                  style: TextStyle(color: Color(0xFFB91C1C), fontSize: 12),
                ),
              ],
              const SizedBox(height: 14),
              TextFormField(
                controller: _quantityController,
                enabled: !_saving,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  hintText: 'Enter returned quantity',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final quantity = int.tryParse(value?.trim() ?? '');
                  return quantity == null || quantity < 1
                      ? 'Enter a quantity greater than zero.'
                      : null;
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _refundController,
                enabled: !_saving,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                decoration: const InputDecoration(
                  labelText: 'Refund amount',
                  prefixText: 'Rs ',
                  hintText: '0.00',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final amount = double.tryParse(value?.trim() ?? '');
                  return amount == null || !amount.isFinite || amount < 0
                      ? 'Enter a valid refund amount.'
                      : null;
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _reasonController,
                enabled: !_saving,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Reason',
                  hintText: 'For example, damaged medicine',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Enter a reason for the return.'
                    : null,
              ),
              if (_submitError != null) ...[
                const SizedBox(height: 12),
                Text(
                  _submitError!,
                  style: const TextStyle(color: Color(0xFFB91C1C)),
                ),
              ],
              const SizedBox(height: 16),
              ClinicPrimaryButton(
                label: 'Process return',
                icon: Icons.currency_exchange,
                loading: _saving,
                onPressed: availableSales.isEmpty || availableMedicines.isEmpty
                    ? null
                    : _processReturn,
              ),
            ],
          ),
        ),
      );
    },
  );
}

int? _recordId(JsonMap record, String key) {
  final value = record[key];
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '');
}

String _saleOptionLabel(JsonMap sale) {
  final id = _recordId(sale, 'sale_id');
  final invoice = apiCell(sale, 'sal_invoice_no');
  final customer = apiCell(sale, 'owner_name');
  final displayName = invoice == '—' ? 'Sale #$id' : invoice;
  return customer == '—' ? displayName : '$displayName · $customer';
}

String _medicineOptionLabel(JsonMap medicine) {
  final id = _recordId(medicine, 'medicine_id');
  final name = apiCell(medicine, 'med_name');
  return name == '—' ? 'Medicine #$id' : name;
}

String _returnSaleLabel(JsonMap saleReturn) {
  final invoice = apiCell(saleReturn, 'sal_invoice_no');
  if (invoice != '—') return invoice;
  return apiCell(saleReturn, 'sale_id');
}

String _returnMedicineLabel(JsonMap saleReturn) {
  final name = apiCell(saleReturn, 'med_name');
  if (name != '—') return name;
  return apiCell(saleReturn, 'medicine_id');
}

String _formatRefund(Object? value) {
  if (value == null || value.toString().isEmpty) return '—';
  final amount = value is num ? value : num.tryParse(value.toString());
  return amount == null ? 'Rs $value' : 'Rs ${amount.toStringAsFixed(2)}';
}

String _formatReturnDate(Object? value) {
  if (value == null || value.toString().isEmpty) return '—';
  final parsed = DateTime.tryParse(value.toString());
  if (parsed == null) return value.toString();
  final date = parsed.toLocal();
  return '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')}/${date.year}';
}
