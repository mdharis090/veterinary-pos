import 'package:flutter/material.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import '../data/animals_api.dart';
import '../../owners/data/owners_api.dart';
import '../../shared/presentation/api_clinic_table.dart';

class AddAnimalDialog extends StatefulWidget {
  const AddAnimalDialog({super.key});

  @override
  State<AddAnimalDialog> createState() => _AddAnimalDialogState();
}

class _AddAnimalDialogState extends State<AddAnimalDialog> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _species = TextEditingController();
  final _breed = TextEditingController();
  final _age = TextEditingController();
  final _weight = TextEditingController();
  final _chipNumber = TextEditingController();
  late Future<List<JsonMap>> _owners;
  int? _ownerId;
  String? _gender;
  String _status = 'Active';
  DateTime? _birthDate;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _owners = OwnersApi().list();
  }

  @override
  void dispose() {
    _name.dispose();
    _species.dispose();
    _breed.dispose();
    _age.dispose();
    _weight.dispose();
    _chipNumber.dispose();
    super.dispose();
  }

  Future<void> _reloadOwners() async {
    setState(() {
      _error = null;
      _owners = OwnersApi().list();
    });
    try {
      final owners = await _owners;
      if (mounted && _ownerId == null && owners.isNotEmpty) {
        setState(() => _ownerId = _asId(owners.first['owner_id']));
      }
    } on ApiException catch (error) {
      if (mounted) setState(() => _error = error.message);
    }
  }

  int? _asId(Object? id) => id is int ? id : null;

  Future<void> _addOwner() async {
    final owner = await showDialog<JsonMap>(
      context: context,
      builder: (_) => const _AddOwnerDialog(),
    );
    if (owner == null || !mounted) return;
    final id = _asId(owner['owner_id']);
    if (id == null) {
      setState(() => _error = 'The server did not return the new owner ID.');
      return;
    }
    setState(() {
      _ownerId = id;
      _owners = OwnersApi().list();
      _error = null;
    });
  }

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? now,
      firstDate: DateTime(now.year - 40),
      lastDate: now,
    );
    if (date != null) setState(() => _birthDate = date);
  }

  Future<void> _saveAnimal() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;
    final ownerId = _ownerId;
    if (ownerId == null) {
      setState(() => _error = 'Select an owner before saving the animal.');
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final weightText = _weight.text.trim();
      await AnimalsApi().create({
        'owner_id': ownerId,
        'an_name': _name.text.trim(),
        'an_species': _nullIfEmpty(_species.text),
        'an_breed': _nullIfEmpty(_breed.text),
        'an_gender': _gender,
        'an_age': _nullIfEmpty(_age.text),
        if (weightText.isNotEmpty) 'an_weight': num.parse(weightText),
        'an_birthdate': _birthDate == null
            ? null
            : '${_birthDate!.year.toString().padLeft(4, '0')}-'
                  '${_birthDate!.month.toString().padLeft(2, '0')}-'
                  '${_birthDate!.day.toString().padLeft(2, '0')}',
        'an_chip_no': _nullIfEmpty(_chipNumber.text),
        'an_status': _status,
      });
      if (mounted) Navigator.of(context).pop(true);
    } on ApiException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } on FormatException {
      if (mounted) setState(() => _error = 'Enter a valid weight.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  String? _nullIfEmpty(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  InputDecoration _decoration(String label) => InputDecoration(
    labelText: label,
    border: const OutlineInputBorder(),
    isDense: true,
  );

  Widget _textField({
    required String label,
    required TextEditingController controller,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) => TextFormField(
    controller: controller,
    decoration: _decoration(label),
    keyboardType: keyboardType,
    validator: validator,
  );

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Add one animal'),
    content: SizedBox(
      width: 480,
      child: FutureBuilder<List<JsonMap>>(
        future: _owners,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.error.toString(),
                  style: const TextStyle(color: Color(0xFFB91C1C)),
                ),
                TextButton.icon(
                  onPressed: _reloadOwners,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry loading owners'),
                ),
              ],
            );
          }
          if (!snapshot.hasData) {
            return const SizedBox(
              height: 100,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final owners = snapshot.data!;
          if (owners.isNotEmpty &&
              !owners.any((owner) => _asId(owner['owner_id']) == _ownerId)) {
            _ownerId = _asId(owners.first['owner_id']);
          }

          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Step 1 · Choose the animal owner',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          key: ValueKey(_ownerId),
                          initialValue: _ownerId,
                          decoration: _decoration('Owner *'),
                          items: owners
                              .map(
                                (owner) => DropdownMenuItem<int>(
                                  value: _asId(owner['owner_id']),
                                  child: Text(
                                    '${apiCell(owner, 'ow_name')} · '
                                    '${apiCell(owner, 'ow_phone')}',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                              .toList(growable: false),
                          onChanged: _saving
                              ? null
                              : (value) => setState(() => _ownerId = value),
                          validator: (value) =>
                              value == null ? 'Select an owner.' : null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        tooltip: 'Add a new owner',
                        onPressed: _saving ? null : _addOwner,
                        icon: const Icon(Icons.person_add_alt_1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Step 2 · Enter one animal',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  _textField(
                    label: 'Animal name *',
                    controller: _name,
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Animal name is required.'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _textField(
                          label: 'Species',
                          controller: _species,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _textField(label: 'Breed', controller: _breed),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: _gender,
                          decoration: _decoration('Gender'),
                          items: const [
                            DropdownMenuItem(
                              value: 'Male',
                              child: Text('Male'),
                            ),
                            DropdownMenuItem(
                              value: 'Female',
                              child: Text('Female'),
                            ),
                          ],
                          onChanged: _saving
                              ? null
                              : (value) => setState(() => _gender = value),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _textField(
                          label: 'Age',
                          controller: _age,
                          keyboardType: TextInputType.text,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _textField(
                          label: 'Weight',
                          controller: _weight,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return null;
                            }
                            final weight = num.tryParse(value.trim());
                            return weight == null || weight <= 0
                                ? 'Enter a valid weight.'
                                : null;
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: _status,
                          decoration: _decoration('Status'),
                          items: const [
                            DropdownMenuItem(
                              value: 'Active',
                              child: Text('Active'),
                            ),
                            DropdownMenuItem(
                              value: 'Inactive',
                              child: Text('Inactive'),
                            ),
                          ],
                          onChanged: _saving
                              ? null
                              : (value) {
                                  if (value != null) {
                                    setState(() => _status = value);
                                  }
                                },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _textField(
                    label: 'Microchip number',
                    controller: _chipNumber,
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: _saving ? null : _pickBirthDate,
                    icon: const Icon(Icons.calendar_today_outlined),
                    label: Text(
                      _birthDate == null
                          ? 'Select birth date (optional)'
                          : '${_birthDate!.year}-'
                                '${_birthDate!.month.toString().padLeft(2, '0')}-'
                                '${_birthDate!.day.toString().padLeft(2, '0')}',
                    ),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      _error!,
                      style: const TextStyle(color: Color(0xFFB91C1C)),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    ),
    actions: [
      TextButton(
        onPressed: _saving ? null : () => Navigator.of(context).pop(false),
        child: const Text('Cancel'),
      ),
      FilledButton.icon(
        onPressed: _saving ? null : _saveAnimal,
        icon: _saving
            ? const SizedBox.square(
                dimension: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.save_outlined),
        label: Text(_saving ? 'Saving...' : 'Save animal'),
      ),
    ],
  );
}

class _AddOwnerDialog extends StatefulWidget {
  const _AddOwnerDialog();

  @override
  State<_AddOwnerDialog> createState() => _AddOwnerDialogState();
}

class _AddOwnerDialogState extends State<_AddOwnerDialog> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _address = TextEditingController();
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _address.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final owner = await OwnersApi().create({
        'ow_name': _name.text.trim(),
        'ow_phone': _phone.text.trim(),
        'ow_address': _address.text.trim().isEmpty
            ? null
            : _address.text.trim(),
      });
      if (mounted) Navigator.of(context).pop(owner);
    } on ApiException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Add owner'),
    content: SizedBox(
      width: 400,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(
                labelText: 'Owner name *',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Owner name is required.'
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone *',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Phone number is required.'
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _address,
              decoration: const InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!, style: const TextStyle(color: Color(0xFFB91C1C))),
            ],
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: _saving ? null : () => Navigator.of(context).pop(),
        child: const Text('Cancel'),
      ),
      FilledButton(
        onPressed: _saving ? null : _save,
        child: Text(_saving ? 'Saving...' : 'Save owner'),
      ),
    ],
  );
}
