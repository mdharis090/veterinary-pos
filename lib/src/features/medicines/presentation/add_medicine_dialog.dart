import 'package:flutter/material.dart';

import '../../../core/network/api_exception.dart';
import '../data/medicines_api.dart';

class AddMedicineDialog extends StatefulWidget {
  const AddMedicineDialog({super.key});

  @override
  State<AddMedicineDialog> createState() => _AddMedicineDialogState();
}

class _AddMedicineDialogState extends State<AddMedicineDialog> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _category = TextEditingController();
  final _manufacturer = TextEditingController();
  final _unit = TextEditingController();
  final _purchasePrice = TextEditingController(text: '0');
  final _salePrice = TextEditingController(text: '0');
  final _stock = TextEditingController(text: '0');
  final _reorderLevel = TextEditingController(text: '10');
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _category.dispose();
    _manufacturer.dispose();
    _unit.dispose();
    _purchasePrice.dispose();
    _salePrice.dispose();
    _stock.dispose();
    _reorderLevel.dispose();
    super.dispose();
  }

  String? _optionalText(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  String? _validateNumber(String? value, {required bool integer}) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter a value.';
    }
    final parsed = integer
        ? int.tryParse(value.trim())
        : num.tryParse(value.trim());
    return parsed == null || parsed < 0
        ? 'Enter a valid positive number.'
        : null;
  }

  num _number(TextEditingController controller, {required bool integer}) =>
      integer
      ? int.parse(controller.text.trim())
      : num.parse(controller.text.trim());

  Future<void> _save() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await MedicinesApi().create({
        'med_name': _name.text.trim(),
        'med_category': _optionalText(_category.text),
        'med_manufacturer': _optionalText(_manufacturer.text),
        'med_unit': _optionalText(_unit.text),
        'med_purchase_price': _number(_purchasePrice, integer: false),
        'med_sale_price': _number(_salePrice, integer: false),
        'med_stock': _number(_stock, integer: true),
        'med_reorder_level': _number(_reorderLevel, integer: true),
      });
      if (mounted) Navigator.of(context).pop(true);
    } on ApiException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } on FormatException {
      if (mounted) {
        setState(() => _error = 'Check the price and stock values.');
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  InputDecoration _decoration(String label) => InputDecoration(
    labelText: label,
    border: const OutlineInputBorder(),
    isDense: true,
  );

  Widget _textField(
    String label,
    TextEditingController controller, {
    bool required = false,
    bool integer = false,
    bool numeric = false,
  }) => TextFormField(
    controller: controller,
    enabled: !_saving,
    decoration: _decoration(label),
    keyboardType: numeric
        ? TextInputType.numberWithOptions(decimal: !integer)
        : TextInputType.text,
    validator: required || numeric
        ? (value) {
            if (required && (value == null || value.trim().isEmpty)) {
              return '$label is required.';
            }
            if (numeric) return _validateNumber(value, integer: integer);
            return null;
          }
        : null,
  );

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Add one medicine'),
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
                'Enter one medicine record. Name is required; other details '
                'can be updated later.',
                style: TextStyle(color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 16),
              _textField('Medicine name *', _name, required: true),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _textField('Category', _category)),
                  const SizedBox(width: 10),
                  Expanded(child: _textField('Manufacturer', _manufacturer)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _textField('Unit', _unit)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _textField(
                      'Opening stock *',
                      _stock,
                      required: true,
                      numeric: true,
                      integer: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _textField(
                      'Purchase price *',
                      _purchasePrice,
                      required: true,
                      numeric: true,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _textField(
                      'Sale price *',
                      _salePrice,
                      required: true,
                      numeric: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _textField(
                'Reorder level *',
                _reorderLevel,
                required: true,
                numeric: true,
                integer: true,
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
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
        label: Text(_saving ? 'Saving...' : 'Save medicine'),
      ),
    ],
  );
}
