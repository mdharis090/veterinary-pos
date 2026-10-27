import 'package:flutter/material.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import '../../medicines/data/medicines_api.dart';
import '../../shared/presentation/clinic_ui.dart';
import '../../suppliers/data/suppliers_api.dart';
import '../data/purchases_api.dart';

class _PurchaseItemDraft {
  final quantity = TextEditingController(text: '1');
  final price = TextEditingController(text: '0');
  final batchNumber = TextEditingController();
  int? medicineId;
  DateTime? expiryDate;

  num get lineTotal =>
      (num.tryParse(quantity.text.trim()) ?? 0) *
      (num.tryParse(price.text.trim()) ?? 0);

  void dispose() {
    quantity.dispose();
    price.dispose();
    batchNumber.dispose();
  }
}

class NewPurchaseScreen extends StatefulWidget {
  const NewPurchaseScreen({super.key});

  @override
  State<NewPurchaseScreen> createState() => _NewPurchaseScreenState();
}

class _NewPurchaseScreenState extends State<NewPurchaseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _invoiceNumber = TextEditingController();
  final _discount = TextEditingController(text: '0');
  final _notes = TextEditingController();
  late Future<List<JsonMap>> _suppliers;
  late Future<List<JsonMap>> _medicines;
  final List<_PurchaseItemDraft> _items = [];
  int? _supplierId;
  DateTime _purchaseDate = DateTime.now();
  String _paymentStatus = 'Paid';
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _suppliers = SuppliersApi().list();
    _medicines = MedicinesApi().list();
    _items.add(_PurchaseItemDraft());
  }

  @override
  void dispose() {
    _invoiceNumber.dispose();
    _discount.dispose();
    _notes.dispose();
    for (final item in _items) {
      item.dispose();
    }
    super.dispose();
  }

  int? _asId(Object? value) => int.tryParse(value?.toString() ?? '');

  num get _subtotal => _items.fold<num>(0, (sum, item) => sum + item.lineTotal);

  num get _discountAmount => num.tryParse(_discount.text.trim()) ?? 0;

  num get _total => _subtotal - _discountAmount;

  void _addItem() => setState(() => _items.add(_PurchaseItemDraft()));

  void _removeItem(int index) {
    if (_items.length == 1) {
      setState(() => _error = 'A purchase must include at least one item.');
      return;
    }
    final removed = _items.removeAt(index);
    removed.dispose();
    setState(() => _error = null);
  }

  String _dateValue(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  String _dateTimeValue(DateTime date) =>
      '${_dateValue(date)} '
      '${date.hour.toString().padLeft(2, '0')}:'
      '${date.minute.toString().padLeft(2, '0')}:00';

  Future<void> _pickPurchaseDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _purchaseDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_purchaseDate),
    );
    if (time == null || !mounted) return;
    setState(
      () => _purchaseDate = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      ),
    );
  }

  Future<void> _pickExpiryDate(_PurchaseItemDraft item) async {
    final date = await showDatePicker(
      context: context,
      initialDate: item.expiryDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (date != null && mounted) {
      setState(() {
        item.expiryDate = date;
        _error = null;
      });
    }
  }

  Future<void> _reloadSuppliers() async {
    setState(() {
      _error = null;
      _suppliers = SuppliersApi().list();
    });
  }

  Future<void> _reloadMedicines() async {
    setState(() {
      _error = null;
      _medicines = MedicinesApi().list();
    });
  }

  String? _validateQuantity(String? value) {
    final parsed = int.tryParse(value?.trim() ?? '');
    if (parsed == null || parsed <= 0) {
      return 'Enter a whole quantity greater than 0.';
    }
    return null;
  }

  String? _validatePrice(String? value) {
    final parsed = num.tryParse(value?.trim() ?? '');
    if (parsed == null || parsed < 0) {
      return 'Enter a valid price of 0 or more.';
    }
    return null;
  }

  String? _validateDiscount(String? value) {
    final parsed = num.tryParse(value?.trim() ?? '');
    if (parsed == null || parsed < 0) {
      return 'Enter a valid discount of 0 or more.';
    }
    if (parsed > _subtotal) return 'Discount cannot exceed the subtotal.';
    return null;
  }

  String? _validateRequired(String? value, String label) =>
      value == null || value.trim().isEmpty ? '$label is required.' : null;

  Future<void> _savePurchase() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    final supplierId = _supplierId;
    if (supplierId == null) {
      setState(() => _error = 'Select a supplier before saving the purchase.');
      return;
    }
    for (var index = 0; index < _items.length; index++) {
      final item = _items[index];
      if (item.medicineId == null) {
        setState(() => _error = 'Select a medicine for item ${index + 1}.');
        return;
      }
      if (item.expiryDate == null) {
        setState(() => _error = 'Select an expiry date for item ${index + 1}.');
        return;
      }
    }
    if (_total < 0) {
      setState(() => _error = 'Discount cannot exceed the purchase subtotal.');
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await PurchasesApi().create({
        'supplier_id': supplierId,
        'pur_invoice_no': _optionalText(_invoiceNumber.text),
        'pur_purchase_date': _dateTimeValue(_purchaseDate),
        'pur_subtotal': _subtotal,
        'pur_discount': _discountAmount,
        'pur_total_amount': _total,
        'pur_payment_status': _paymentStatus,
        'pur_notes': _optionalText(_notes.text),
        'items': [
          for (final item in _items)
            {
              'medicine_id': item.medicineId,
              'pi_batch_no': item.batchNumber.text.trim(),
              'pi_qty': int.parse(item.quantity.text.trim()),
              'pi_price': num.parse(item.price.text.trim()),
              'pi_expiry_date': _dateValue(item.expiryDate!),
              'pi_line_total': item.lineTotal,
            },
        ],
      });
      if (mounted) Navigator.of(context).pop(true);
    } on ApiException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } on FormatException {
      if (mounted) {
        setState(() => _error = 'Check the quantity and price values.');
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  String? _optionalText(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  InputDecoration _decoration(String label) => InputDecoration(
    labelText: label,
    border: const OutlineInputBorder(),
    isDense: true,
  );

  Widget _retryMessage(String message, Future<void> Function() retry) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(message, style: const TextStyle(color: Color(0xFFB91C1C))),
      TextButton.icon(
        onPressed: _saving ? null : retry,
        icon: const Icon(Icons.refresh),
        label: const Text('Retry'),
      ),
    ],
  );

  Widget _supplierField() => FutureBuilder<List<JsonMap>>(
    future: _suppliers,
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return _retryMessage(
          'Could not load suppliers: ${snapshot.error}',
          _reloadSuppliers,
        );
      }
      if (!snapshot.hasData) {
        return const Center(child: CircularProgressIndicator());
      }
      final suppliers = snapshot.data!;
      final validIds = suppliers
          .map((supplier) => _asId(supplier['supplier_id']))
          .whereType<int>()
          .toSet();
      if (suppliers.isEmpty) {
        return const Text(
          'Add a supplier before creating a purchase.',
          style: TextStyle(color: Color(0xFFB91C1C)),
        );
      }
      if (validIds.isEmpty) {
        return const Text(
          'The supplier list did not include valid supplier IDs.',
          style: TextStyle(color: Color(0xFFB91C1C)),
        );
      }
      return DropdownButtonFormField<int>(
        initialValue: validIds.contains(_supplierId) ? _supplierId : null,
        decoration: _decoration('Supplier *'),
        items: [
          for (final supplier in suppliers)
            if (_asId(supplier['supplier_id']) case final int id)
              DropdownMenuItem(
                value: id,
                child: Text(
                  '${supplier['sup_name'] ?? 'Supplier'}'
                  '${supplier['sup_company'] == null ? '' : ' · ${supplier['sup_company']}'}',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
        ],
        validator: (value) => value == null ? 'Select a supplier.' : null,
        onChanged: _saving
            ? null
            : (value) => setState(() => _supplierId = value),
      );
    },
  );

  Widget _medicineField(_PurchaseItemDraft item, List<JsonMap> medicines) {
    final validIds = medicines
        .map((medicine) => _asId(medicine['medicine_id']))
        .whereType<int>()
        .toSet();
    return DropdownButtonFormField<int>(
      initialValue: validIds.contains(item.medicineId) ? item.medicineId : null,
      decoration: _decoration('Medicine *'),
      items: [
        for (final medicine in medicines)
          if (_asId(medicine['medicine_id']) case final int id)
            DropdownMenuItem(
              value: id,
              child: Text(
                '${medicine['med_name'] ?? 'Medicine'} (#$id)',
                overflow: TextOverflow.ellipsis,
              ),
            ),
      ],
      validator: (value) => value == null ? 'Select a medicine.' : null,
      onChanged: _saving
          ? null
          : (value) => setState(() {
              item.medicineId = value;
              _error = null;
            }),
    );
  }

  Widget _itemsPanel() => FutureBuilder<List<JsonMap>>(
    future: _medicines,
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return ClinicPanel(
          title: 'Purchase items',
          child: _retryMessage(
            'Could not load medicines: ${snapshot.error}',
            _reloadMedicines,
          ),
        );
      }
      if (!snapshot.hasData) {
        return const ClinicPanel(
          title: 'Purchase items',
          child: Center(child: CircularProgressIndicator()),
        );
      }
      final medicines = snapshot.data!;
      if (medicines.isEmpty) {
        return const ClinicPanel(
          title: 'Purchase items',
          child: Text(
            'Add a medicine before creating a purchase.',
            style: TextStyle(color: Color(0xFFB91C1C)),
          ),
        );
      }
      return ClinicPanel(
        title: 'Purchase items',
        trailing: ClinicOutlineButton(
          label: 'Add item',
          icon: Icons.add,
          onPressed: _saving ? null : _addItem,
        ),
        child: Column(
          children: [
            for (var index = 0; index < _items.length; index++) ...[
              if (index > 0) const Divider(height: 28),
              _itemCard(index, _items[index], medicines),
            ],
          ],
        ),
      );
    },
  );

  Widget _itemCard(
    int index,
    _PurchaseItemDraft item,
    List<JsonMap> medicines,
  ) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Row(
        children: [
          Expanded(
            child: Text(
              'Item ${index + 1}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          if (_items.length > 1)
            IconButton(
              tooltip: 'Remove item',
              onPressed: _saving ? null : () => _removeItem(index),
              icon: const Icon(Icons.delete_outline),
            ),
        ],
      ),
      const SizedBox(height: 10),
      _medicineField(item, medicines),
      const SizedBox(height: 12),
      TextFormField(
        controller: item.batchNumber,
        enabled: !_saving,
        textCapitalization: TextCapitalization.characters,
        decoration: _decoration('Batch number *'),
        validator: (value) => _validateRequired(value, 'Batch number'),
      ),
      const SizedBox(height: 12),
      LayoutBuilder(
        builder: (context, constraints) {
          final fields = [
            TextFormField(
              controller: item.quantity,
              enabled: !_saving,
              keyboardType: TextInputType.number,
              decoration: _decoration('Quantity *'),
              validator: _validateQuantity,
              onChanged: (_) => setState(() {}),
            ),
            TextFormField(
              controller: item.price,
              enabled: !_saving,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: _decoration('Unit purchase price *'),
              validator: _validatePrice,
              onChanged: (_) => setState(() {}),
            ),
          ];
          if (constraints.maxWidth < 460) {
            return Column(
              children: [fields[0], const SizedBox(height: 12), fields[1]],
            );
          }
          return Row(
            children: [
              Expanded(child: fields[0]),
              const SizedBox(width: 12),
              Expanded(child: fields[1]),
            ],
          );
        },
      ),
      const SizedBox(height: 12),
      OutlinedButton.icon(
        onPressed: _saving ? null : () => _pickExpiryDate(item),
        icon: const Icon(Icons.event_outlined),
        label: Text(
          item.expiryDate == null
              ? 'Select expiry date *'
              : 'Expiry: ${_dateValue(item.expiryDate!)}',
        ),
      ),
      Align(
        alignment: Alignment.centerRight,
        child: Text(
          'Line total: Rs ${item.lineTotal.toStringAsFixed(2)}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    ],
  );

  Widget _purchaseDetails() => ClinicPanel(
    title: 'Purchase details',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _supplierField(),
        const SizedBox(height: 14),
        TextFormField(
          controller: _invoiceNumber,
          enabled: !_saving,
          textCapitalization: TextCapitalization.characters,
          decoration: _decoration('Supplier invoice number'),
        ),
        const SizedBox(height: 14),
        OutlinedButton.icon(
          onPressed: _saving ? null : _pickPurchaseDate,
          icon: const Icon(Icons.calendar_today_outlined),
          label: Text('Purchase date: ${_dateTimeValue(_purchaseDate)}'),
        ),
        const SizedBox(height: 14),
        DropdownButtonFormField<String>(
          initialValue: _paymentStatus,
          decoration: _decoration('Payment status'),
          items: const [
            DropdownMenuItem(value: 'Paid', child: Text('Paid')),
            DropdownMenuItem(value: 'Pending', child: Text('Pending')),
            DropdownMenuItem(value: 'Partial', child: Text('Partial')),
          ],
          onChanged: _saving
              ? null
              : (value) {
                  if (value != null) setState(() => _paymentStatus = value);
                },
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: _notes,
          enabled: !_saving,
          minLines: 2,
          maxLines: 4,
          decoration: _decoration('Notes'),
        ),
      ],
    ),
  );

  Widget _summary() => ClinicPanel(
    title: 'Order summary',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _amountLine('Subtotal', _subtotal),
        const SizedBox(height: 12),
        TextFormField(
          controller: _discount,
          enabled: !_saving,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: _decoration('Discount'),
          validator: _validateDiscount,
          onChanged: (_) => setState(() {}),
        ),
        const Divider(height: 28),
        _amountLine('Total', _total, emphasized: true),
        if (_error != null) ...[
          const SizedBox(height: 14),
          Text(_error!, style: const TextStyle(color: Color(0xFFB91C1C))),
        ],
        const SizedBox(height: 16),
        ClinicPrimaryButton(
          label: _saving ? 'Saving purchase...' : 'Save purchase',
          loading: _saving,
          onPressed: _saving ? null : _savePurchase,
        ),
      ],
    ),
  );

  Widget _amountLine(String label, num amount, {bool emphasized = false}) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: emphasized ? FontWeight.w700 : FontWeight.w400,
              fontSize: emphasized ? 18 : 14,
            ),
          ),
          Text(
            'Rs ${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: emphasized ? 18 : 14,
              color: emphasized ? clinicTeal : null,
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) => ClinicPageFrame(
    title: 'New purchase',
    subtitle: 'Record a supplier invoice and the medicines received.',
    child: Form(
      key: _formKey,
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 920) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _purchaseDetails(),
                const SizedBox(height: 16),
                _itemsPanel(),
                const SizedBox(height: 16),
                _summary(),
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _purchaseDetails(),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 7, child: _itemsPanel()),
                  const SizedBox(width: 16),
                  Expanded(flex: 4, child: _summary()),
                ],
              ),
            ],
          );
        },
      ),
    ),
  );
}
