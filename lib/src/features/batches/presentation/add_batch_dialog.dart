import 'package:flutter/material.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import '../../medicines/data/medicines_api.dart';
import '../data/batches_api.dart';

class AddBatchDialog extends StatefulWidget {
  const AddBatchDialog({super.key});

  @override
  State<AddBatchDialog> createState() => _AddBatchDialogState();
}

class _AddBatchDialogState extends State<AddBatchDialog> {
  final _formKey = GlobalKey<FormState>();
  final _batchNumber = TextEditingController();
  final _quantity = TextEditingController(text: '0');
  late Future<List<JsonMap>> _medicines;
  int? _medicineId;
  DateTime? _expiryDate;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _medicines = MedicinesApi().list();
  }

  @override
  void dispose() {
    _batchNumber.dispose();
    _quantity.dispose();
    super.dispose();
  }

  int? _asId(Object? value) => int.tryParse(value?.toString() ?? '');

  Future<void> _reloadMedicines() async {
    setState(() {
      _error = null;
      _medicines = MedicinesApi().list();
    });
    try {
      final medicines = await _medicines;
      if (mounted &&
          _medicineId == null &&
          medicines.isNotEmpty &&
          _asId(medicines.first['medicine_id']) != null) {
        setState(() => _medicineId = _asId(medicines.first['medicine_id']));
      }
    } on ApiException catch (error) {
      if (mounted) setState(() => _error = error.message);
    }
  }

  Future<void> _pickExpiryDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _expiryDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (date != null) setState(() => _expiryDate = date);
  }

  String? _validateQuantity(String? value) {
    final quantity = int.tryParse(value?.trim() ?? '');
    if (quantity == null || quantity < 0) {
      return 'Enter a whole number of 0 or more.';
    }
    return null;
  }

  Future<void> _save() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    final medicineId = _medicineId;
    if (medicineId == null) {
      setState(() => _error = 'Select a medicine before saving the batch.');
      return;
    }
    final expiryDate = _expiryDate;
    if (expiryDate == null) {
      setState(() => _error = 'Select the batch expiry date.');
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await BatchesApi().create({
        'medicine_id': medicineId,
        'bat_batch_no': _batchNumber.text.trim(),
        'bat_expiry_date':
            '${expiryDate.year.toString().padLeft(4, '0')}-'
            '${expiryDate.month.toString().padLeft(2, '0')}-'
            '${expiryDate.day.toString().padLeft(2, '0')}',
        'bat_quantity': int.parse(_quantity.text.trim()),
      });
      if (mounted) Navigator.of(context).pop(true);
    } on ApiException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } on FormatException {
      if (mounted) setState(() => _error = 'Check the batch quantity.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  InputDecoration _decoration(String label, {Widget? prefixIcon}) =>
      InputDecoration(
        labelText: label,
        prefixIcon: prefixIcon,
        border: const OutlineInputBorder(),
        isDense: true,
      );

  Widget _medicineField() => FutureBuilder<List<JsonMap>>(
    future: _medicines,
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Could not load medicines: ${snapshot.error}',
              style: const TextStyle(color: Color(0xFFB91C1C)),
            ),
            TextButton.icon(
              onPressed: _saving ? null : _reloadMedicines,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        );
      }
      if (!snapshot.hasData) {
        return const Padding(
          padding: EdgeInsets.all(12),
          child: Center(child: CircularProgressIndicator()),
        );
      }

      final medicines = snapshot.data!;
      final validIds = medicines
          .map((medicine) => _asId(medicine['medicine_id']))
          .whereType<int>()
          .toSet();
      final selectedId = validIds.contains(_medicineId) ? _medicineId : null;
      if (medicines.isEmpty) {
        return const Text(
          'Add a medicine before creating a batch.',
          style: TextStyle(color: Color(0xFFB91C1C)),
        );
      }
      if (validIds.isEmpty) {
        return const Text(
          'The medicine list did not include valid medicine IDs.',
          style: TextStyle(color: Color(0xFFB91C1C)),
        );
      }

      return DropdownButtonFormField<int>(
        initialValue: selectedId,
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
            : (value) => setState(() => _medicineId = value),
      );
    },
  );

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Add batch'),
    content: SizedBox(
      width: 480,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Enter the batch details for a medicine.',
                style: TextStyle(color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 18),
              _medicineField(),
              const SizedBox(height: 14),
              TextFormField(
                controller: _batchNumber,
                enabled: !_saving,
                textCapitalization: TextCapitalization.characters,
                decoration: _decoration('Batch number *'),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Batch number is required.'
                    : null,
              ),
              const SizedBox(height: 14),
              OutlinedButton.icon(
                onPressed: _saving ? null : _pickExpiryDate,
                icon: const Icon(Icons.calendar_today_outlined),
                label: Text(
                  _expiryDate == null
                      ? 'Select expiry date *'
                      : 'Expiry: ${_expiryDate!.year.toString().padLeft(4, '0')}-'
                            '${_expiryDate!.month.toString().padLeft(2, '0')}-'
                            '${_expiryDate!.day.toString().padLeft(2, '0')}',
                ),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _quantity,
                enabled: !_saving,
                keyboardType: TextInputType.number,
                decoration: _decoration('Quantity *'),
                validator: _validateQuantity,
              ),
              if (_error != null) ...[
                const SizedBox(height: 14),
                Text(_error!, style: const TextStyle(color: Color(0xFFB91C1C))),
              ],
            ],
          ),
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: _saving ? null : () => Navigator.of(context).pop(false),
        child: const Text('Cancel'),
      ),
      FilledButton.icon(
        onPressed: _saving ? null : _save,
        icon: _saving
            ? const SizedBox.square(
                dimension: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.save_outlined),
        label: Text(_saving ? 'Saving...' : 'Save batch'),
      ),
    ],
  );
}
