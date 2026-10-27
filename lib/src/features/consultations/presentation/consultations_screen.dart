import 'package:flutter/material.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import '../../auth/data/auth_api.dart';
import '../../patients/data/animals_api.dart';
import '../../prescriptions/presentation/add_prescription_dialog.dart';
import '../../shared/presentation/api_clinic_table.dart';
import '../../shared/presentation/clinic_ui.dart';
import '../data/consultations_api.dart';

class ConsultationsScreen extends StatefulWidget {
  const ConsultationsScreen({super.key});

  @override
  State<ConsultationsScreen> createState() => _ConsultationsScreenState();
}

class _ConsultationsScreenState extends State<ConsultationsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _symptoms = TextEditingController();
  final _diagnosis = TextEditingController();
  final _notes = TextEditingController();
  final _followUp = TextEditingController();
  late Future<List<JsonMap>> _animals;
  late Future<JsonMap> _vet;
  int? _animalId;
  DateTime _visitDate = DateTime.now();
  bool _saving = false;
  String? _error;
  int _refreshKey = 0;

  @override
  void initState() {
    super.initState();
    _animals = AnimalsApi().list();
    _vet = _loadVet();
  }

  @override
  void dispose() {
    _symptoms.dispose();
    _diagnosis.dispose();
    _notes.dispose();
    _followUp.dispose();
    super.dispose();
  }

  Future<JsonMap> _loadVet() async {
    final response = await AuthApi().currentUser();
    final data = response['data'];
    final user = response['user'];
    final nestedUser = data is Map<String, dynamic> ? data['user'] : null;
    final currentUser = user is Map<String, dynamic>
        ? user
        : nestedUser is Map<String, dynamic>
        ? nestedUser
        : data is Map<String, dynamic>
        ? data
        : response;
    final userId = _asId(currentUser['user_id']);
    if (userId == null) {
      throw const ApiException(
        'The server did not return the signed-in veterinarian ID.',
      );
    }
    return currentUser;
  }

  int? _asId(Object? value) => int.tryParse(value?.toString() ?? '');

  String _displayAnimal(JsonMap animal) {
    final name = animal['an_name'] ?? animal['animal_name'] ?? 'Animal';
    final species = animal['an_species'];
    return species == null || species.toString().isEmpty
        ? name.toString()
        : '${name.toString()} · ${species.toString()}';
  }

  String _displayVet(JsonMap vet) =>
      (vet['username'] ?? vet['user_name'] ?? 'Signed-in veterinarian')
          .toString();

  String? _optionalText(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  String _dateTimeValue(DateTime value) =>
      '${value.year.toString().padLeft(4, '0')}-'
      '${value.month.toString().padLeft(2, '0')}-'
      '${value.day.toString().padLeft(2, '0')} '
      '${value.hour.toString().padLeft(2, '0')}:'
      '${value.minute.toString().padLeft(2, '0')}:00';

  String _dateTimeLabel(DateTime value) =>
      '${value.year.toString().padLeft(4, '0')}-'
      '${value.month.toString().padLeft(2, '0')}-'
      '${value.day.toString().padLeft(2, '0')} '
      '${value.hour.toString().padLeft(2, '0')}:'
      '${value.minute.toString().padLeft(2, '0')}';

  Future<void> _pickVisitDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _visitDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_visitDate),
    );
    if (time == null || !mounted) return;
    setState(
      () => _visitDate = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      ),
    );
  }

  Future<void> _reloadAnimals() async {
    setState(() {
      _error = null;
      _animals = AnimalsApi().list();
    });
    try {
      final animals = await _animals;
      final selectedId = _animalId;
      if (mounted &&
          (selectedId == null ||
              !animals.any(
                (animal) => _asId(animal['animal_id']) == selectedId,
              ))) {
        setState(
          () => _animalId = animals.isEmpty
              ? null
              : _asId(animals.first['animal_id']),
        );
      }
    } on ApiException catch (error) {
      if (mounted) setState(() => _error = error.message);
    }
  }

  Future<void> _saveConsultation() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final vet = await _vet;
      final vetId = _asId(vet['user_id']);
      final animalId = _animalId;
      if (vetId == null) {
        throw const ApiException(
          'The server did not return the signed-in veterinarian ID.',
        );
      }
      if (animalId == null) {
        throw const ApiException('Select an animal before saving.');
      }
      final created = await ConsultationsApi().create({
        'animal_id': animalId,
        'vet_id': vetId,
        'con_visit_date': _dateTimeValue(_visitDate),
        'con_symptoms': _optionalText(_symptoms.text),
        'con_diagnosis': _optionalText(_diagnosis.text),
        'con_treatment_notes': _optionalText(_notes.text),
        'con_follow_up': _optionalText(_followUp.text),
      });
      if (!mounted) return;
      final consultationId = _asId(created['consultation_id']);
      _formKey.currentState?.reset();
      _symptoms.clear();
      _diagnosis.clear();
      _notes.clear();
      _followUp.clear();
      setState(() {
        _refreshKey++;
        _visitDate = DateTime.now();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            consultationId == null
                ? 'Consultation saved. The server did not return its ID, so a prescription cannot be linked yet.'
                : 'Consultation saved.',
          ),
        ),
      );
      if (consultationId != null) {
        final addPrescription = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('Consultation saved'),
            content: const Text(
              'Would you like to add a prescription for this consultation?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Not now'),
              ),
              FilledButton.icon(
                onPressed: () => Navigator.of(context).pop(true),
                icon: const Icon(Icons.medication_outlined),
                label: const Text('Add prescription'),
              ),
            ],
          ),
        );
        if (addPrescription == true && mounted) {
          await showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (_) =>
                AddPrescriptionDialog(consultationId: consultationId),
          );
        }
      }
    } on ApiException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Widget _animalField() => FutureBuilder<List<JsonMap>>(
    future: _animals,
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Could not load animals: ${snapshot.error}',
              style: const TextStyle(color: Color(0xFFB91C1C)),
            ),
            TextButton.icon(
              onPressed: _saving ? null : _reloadAnimals,
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

      final animals = snapshot.data!;
      if (animals.isEmpty) {
        return const Text(
          'Add an animal before creating a consultation.',
          style: TextStyle(color: Color(0xFFB91C1C)),
        );
      }
      final ids = animals
          .map((animal) => _asId(animal['animal_id']))
          .whereType<int>()
          .toSet();
      final selectedId = ids.contains(_animalId) ? _animalId : null;
      return DropdownButtonFormField<int>(
        initialValue: selectedId,
        decoration: const InputDecoration(
          labelText: 'Animal *',
          border: OutlineInputBorder(),
          isDense: true,
        ),
        items: [
          for (final animal in animals)
            if (_asId(animal['animal_id']) case final int id)
              DropdownMenuItem(
                value: id,
                child: Text(
                  _displayAnimal(animal),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
        ],
        validator: (value) => value == null ? 'Select an animal.' : null,
        onChanged: _saving
            ? null
            : (value) => setState(() => _animalId = value),
      );
    },
  );

  Widget _vetField() => FutureBuilder<JsonMap>(
    future: _vet,
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Text(
          'Could not load veterinarian: ${snapshot.error}',
          style: const TextStyle(color: Color(0xFFB91C1C)),
        );
      }
      if (!snapshot.hasData) {
        return const LinearProgressIndicator();
      }
      return InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Veterinarian',
          border: OutlineInputBorder(),
          isDense: true,
        ),
        child: Text(_displayVet(snapshot.data!)),
      );
    },
  );

  Widget _textField(
    String label,
    String hint,
    TextEditingController controller, {
    int lines = 1,
  }) => TextFormField(
    controller: controller,
    enabled: !_saving,
    textCapitalization: TextCapitalization.sentences,
    minLines: lines,
    maxLines: lines,
    decoration: InputDecoration(
      labelText: label,
      hintText: hint,
      border: const OutlineInputBorder(),
      isDense: true,
    ),
  );

  Widget _form() => ClinicPanel(
    title: 'New consultation',
    child: Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _animalField(),
          const SizedBox(height: 14),
          _vetField(),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: _saving ? null : _pickVisitDate,
            icon: const Icon(Icons.event_outlined),
            label: Text('Visit date and time: ${_dateTimeLabel(_visitDate)}'),
          ),
          const SizedBox(height: 14),
          _textField(
            'Symptoms',
            'Describe observed symptoms',
            _symptoms,
            lines: 3,
          ),
          const SizedBox(height: 14),
          _textField('Diagnosis', 'Enter diagnosis', _diagnosis, lines: 2),
          const SizedBox(height: 14),
          _textField(
            'Treatment notes',
            'Add treatment details',
            _notes,
            lines: 3,
          ),
          const SizedBox(height: 14),
          _textField(
            'Follow-up',
            'Follow-up date or instructions',
            _followUp,
            lines: 2,
          ),
          if (_error != null) ...[
            const SizedBox(height: 14),
            Text(_error!, style: const TextStyle(color: Color(0xFFB91C1C))),
          ],
          const SizedBox(height: 16),
          ClinicPrimaryButton(
            label: _saving ? 'Saving...' : 'Save consultation',
            loading: _saving,
            onPressed: _saving ? null : _saveConsultation,
          ),
        ],
      ),
    ),
  );

  Widget _table() => ApiClinicTable(
    key: ValueKey(_refreshKey),
    title: 'Recent consultations',
    columns: const [
      'ID',
      'Visit date',
      'Animal',
      'Veterinarian',
      'Symptoms',
      'Diagnosis',
      'Treatment',
      'Follow-up',
    ],
    loadRows: ConsultationsApi().list,
    mapRow: (consultation) => [
      apiCell(consultation, 'consultation_id'),
      apiCell(consultation, 'con_visit_date'),
      apiCell(consultation, 'animal_name'),
      apiCell(consultation, 'vet_name'),
      apiCell(consultation, 'con_symptoms'),
      apiCell(consultation, 'con_diagnosis'),
      apiCell(consultation, 'con_treatment_notes'),
      apiCell(consultation, 'con_follow_up'),
    ],
  );

  @override
  Widget build(BuildContext context) => ClinicPageFrame(
    title: 'Consultations',
    child: LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 980) {
          return Column(
            children: [_form(), const SizedBox(height: 16), _table()],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 5, child: _table()),
            const SizedBox(width: 16),
            Expanded(flex: 6, child: _form()),
          ],
        );
      },
    ),
  );
}
