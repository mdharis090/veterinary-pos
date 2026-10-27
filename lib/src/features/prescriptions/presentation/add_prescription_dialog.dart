import 'package:flutter/material.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import '../../consultations/data/consultations_api.dart';
import '../../medicines/data/medicines_api.dart';
import '../data/prescriptions_api.dart';

class AddPrescriptionDialog extends StatefulWidget {
  const AddPrescriptionDialog({this.consultationId, super.key});

  final int? consultationId;

  @override
  State<AddPrescriptionDialog> createState() => _AddPrescriptionDialogState();
}

class _AddPrescriptionDialogState extends State<AddPrescriptionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _dosage = TextEditingController();
  final _duration = TextEditingController();
  final _notes = TextEditingController();
  late Future<List<JsonMap>> _consultations;
  late Future<List<JsonMap>> _medicines;
  int? _consultationId;
  int? _medicineId;
  int _savedCount = 0;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _consultationId = widget.consultationId;
    _consultations = widget.consultationId == null
        ? ConsultationsApi().list()
        : Future.value(<JsonMap>[]);
    _medicines = MedicinesApi().list();
  }

  @override
  void dispose() {
    _dosage.dispose();
    _duration.dispose();
    _notes.dispose();
    super.dispose();
  }

  int? _asId(Object? value) => int.tryParse(value?.toString() ?? '');

  String _consultationLabel(JsonMap consultation) {
    final id = consultation['consultation_id'];
    final animal =
        consultation['animal_name'] ?? consultation['an_name'] ?? 'Animal';
    final date = consultation['con_visit_date'];
    return [
      'Consultation #$id',
      animal,
      if (date != null) date.toString(),
    ].join(' · ');
  }

  Future<void> _reloadConsultations() async {
    setState(() {
      _error = null;
      _consultations = ConsultationsApi().list();
    });
  }

  Future<void> _reloadMedicines() async {
    setState(() {
      _error = null;
      _medicines = MedicinesApi().list();
    });
  }

  Future<void> _save() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    final consultationId = _consultationId;
    final medicineId = _medicineId;
    if (consultationId == null || medicineId == null) {
      setState(() => _error = 'Select a consultation and medicine.');
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await PrescriptionsApi().create({
        'consultation_id': consultationId,
        'medicine_id': medicineId,
        'pre_dosage': _dosage.text.trim(),
        'pre_duration': _duration.text.trim(),
        'pre_notes': _optionalText(_notes.text),
      });
      if (!mounted) return;
      setState(() {
        _savedCount++;
        _dosage.clear();
        _duration.clear();
        _notes.clear();
      });
    } on ApiException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  String? _optionalText(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  String? _required(String? value, String label) =>
      value == null || value.trim().isEmpty ? '$label is required.' : null;

  Widget _consultationField() {
    final fixedId = widget.consultationId;
    if (fixedId != null) {
      return InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Consultation',
          border: OutlineInputBorder(),
          isDense: true,
        ),
        child: Text('Consultation #$fixedId'),
      );
    }

    return FutureBuilder<List<JsonMap>>(
      future: _consultations,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _loadError(
            'Could not load consultations: ${snapshot.error}',
            _reloadConsultations,
          );
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final consultations = snapshot.data!;
        final validIds = consultations
            .map((row) => _asId(row['consultation_id']))
            .whereType<int>()
            .toSet();
        if (consultations.isEmpty) {
          return const Text(
            'Create a consultation before adding a prescription.',
            style: TextStyle(color: Color(0xFFB91C1C)),
          );
        }
        if (validIds.isEmpty) {
          return const Text(
            'The consultation list did not include valid IDs.',
            style: TextStyle(color: Color(0xFFB91C1C)),
          );
        }

        return DropdownButtonFormField<int>(
          initialValue: validIds.contains(_consultationId)
              ? _consultationId
              : null,
          decoration: const InputDecoration(
            labelText: 'Consultation *',
            border: OutlineInputBorder(),
            isDense: true,
          ),
          items: [
            for (final consultation in consultations)
              if (_asId(consultation['consultation_id']) case final int id)
                DropdownMenuItem(
                  value: id,
                  child: Text(
                    _consultationLabel(consultation),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
          ],
          validator: (value) => value == null ? 'Select a consultation.' : null,
          onChanged: _saving
              ? null
              : (value) => setState(() => _consultationId = value),
        );
      },
    );
  }

  Widget _medicineField() => FutureBuilder<List<JsonMap>>(
    future: _medicines,
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return _loadError(
          'Could not load medicines: ${snapshot.error}',
          _reloadMedicines,
        );
      }
      if (!snapshot.hasData) {
        return const Center(child: CircularProgressIndicator());
      }

      final medicines = snapshot.data!;
      final validIds = medicines
          .map((row) => _asId(row['medicine_id']))
          .whereType<int>()
          .toSet();
      if (medicines.isEmpty) {
        return const Text(
          'Add a medicine before creating a prescription.',
          style: TextStyle(color: Color(0xFFB91C1C)),
        );
      }
      if (validIds.isEmpty) {
        return const Text(
          'The medicine list did not include valid IDs.',
          style: TextStyle(color: Color(0xFFB91C1C)),
        );
      }

      return DropdownButtonFormField<int>(
        initialValue: validIds.contains(_medicineId) ? _medicineId : null,
        decoration: const InputDecoration(
          labelText: 'Medicine *',
          border: OutlineInputBorder(),
          isDense: true,
        ),
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

  Widget _loadError(String message, Future<void> Function() retry) => Column(
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

  Widget _textField(
    String label,
    TextEditingController controller, {
    int lines = 1,
    bool required = false,
  }) => TextFormField(
    controller: controller,
    enabled: !_saving,
    textCapitalization: TextCapitalization.sentences,
    minLines: lines,
    maxLines: lines,
    decoration: InputDecoration(
      labelText: required ? '$label *' : label,
      border: const OutlineInputBorder(),
      isDense: true,
    ),
    validator: required ? (value) => _required(value, label) : null,
  );

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Add prescription'),
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
                'Link a medicine and dosage to a consultation.',
                style: TextStyle(color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 18),
              _consultationField(),
              const SizedBox(height: 14),
              _medicineField(),
              const SizedBox(height: 14),
              _textField('Dosage', _dosage, required: true),
              const SizedBox(height: 14),
              _textField('Duration', _duration, required: true),
              const SizedBox(height: 14),
              _textField('Notes', _notes, lines: 2),
              if (_savedCount > 0) ...[
                const SizedBox(height: 12),
                Text(
                  '$_savedCount prescription${_savedCount == 1 ? '' : 's'} saved. '
                  'Add another or finish.',
                  style: const TextStyle(color: Color(0xFF047857)),
                ),
              ],
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
        onPressed: _saving
            ? null
            : () => Navigator.of(context).pop(_savedCount > 0),
        child: const Text('Done'),
      ),
      FilledButton.icon(
        onPressed: _saving ? null : _save,
        icon: _saving
            ? const SizedBox.square(
                dimension: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.save_outlined),
        label: Text(_saving ? 'Saving...' : 'Save prescription'),
      ),
    ],
  );
}
