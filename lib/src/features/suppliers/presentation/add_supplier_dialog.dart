import 'package:flutter/material.dart';

import '../../../core/network/api_exception.dart';
import '../data/suppliers_api.dart';

class AddSupplierDialog extends StatefulWidget {
  const AddSupplierDialog({super.key});

  @override
  State<AddSupplierDialog> createState() => _AddSupplierDialogState();
}

class _AddSupplierDialogState extends State<AddSupplierDialog> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _contact = TextEditingController();
  final _company = TextEditingController();
  final _address = TextEditingController();
  String _status = 'Active';
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _contact.dispose();
    _company.dispose();
    _address.dispose();
    super.dispose();
  }

  String? _optionalText(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  Future<void> _save() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await SuppliersApi().create({
        'sup_name': _name.text.trim(),
        'sup_contact': _optionalText(_contact.text),
        'sup_address': _optionalText(_address.text),
        'sup_company': _optionalText(_company.text),
        'sup_status': _status,
      });
      if (mounted) Navigator.of(context).pop(true);
    } on ApiException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  InputDecoration _decoration(
    String label, {
    String? hint,
    Widget? prefixIcon,
  }) => InputDecoration(
    labelText: label,
    hintText: hint,
    prefixIcon: prefixIcon,
    border: const OutlineInputBorder(),
    isDense: true,
  );

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Add supplier'),
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
                'Enter supplier contact and company information.',
                style: TextStyle(color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 18),
              TextFormField(
                controller: _name,
                enabled: !_saving,
                textCapitalization: TextCapitalization.words,
                decoration: _decoration(
                  'Supplier name *',
                  hint: 'e.g. Ali Khan',
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Supplier name is required.'
                    : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _company,
                enabled: !_saving,
                textCapitalization: TextCapitalization.words,
                decoration: _decoration(
                  'Company',
                  hint: 'e.g. City Vet Distributors',
                ),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _contact,
                enabled: !_saving,
                keyboardType: TextInputType.phone,
                decoration: _decoration(
                  'Contact number',
                  hint: 'e.g. 0300-1234567',
                  prefixIcon: const Icon(Icons.phone_outlined),
                ),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _address,
                enabled: !_saving,
                textCapitalization: TextCapitalization.sentences,
                minLines: 2,
                maxLines: 3,
                decoration: _decoration(
                  'Address',
                  hint: 'Street, area, city',
                  prefixIcon: const Icon(Icons.location_on_outlined),
                ),
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                initialValue: _status,
                decoration: _decoration('Status'),
                items: const [
                  DropdownMenuItem(value: 'Active', child: Text('Active')),
                  DropdownMenuItem(value: 'Inactive', child: Text('Inactive')),
                ],
                onChanged: _saving
                    ? null
                    : (value) {
                        if (value != null) setState(() => _status = value);
                      },
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
        label: Text(_saving ? 'Saving...' : 'Save supplier'),
      ),
    ],
  );
}
