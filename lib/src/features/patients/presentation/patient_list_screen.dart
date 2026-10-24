import 'package:flutter/material.dart';

import '../data/animals_api.dart';
import 'add_animal_dialog.dart';
import '../../shared/presentation/api_clinic_table.dart';
import '../../shared/presentation/clinic_ui.dart';

class PatientsListPage extends StatefulWidget {
  const PatientsListPage({this.onNavigate, super.key});
  final ValueChanged<String>? onNavigate;

  @override
  State<PatientsListPage> createState() => _PatientsListPageState();
}

class _PatientsListPageState extends State<PatientsListPage> {
  int _refreshKey = 0;

  Future<void> _addAnimal() async {
    final created = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AddAnimalDialog(),
    );
    if (created == true && mounted) {
      setState(() => _refreshKey++);
    }
  }

  @override
  Widget build(BuildContext context) => ClinicPageFrame(
    title: 'Patients',
    action: ClinicPrimaryButton(
      label: 'Add animal',
      icon: Icons.add,
      onPressed: _addAnimal,
    ),
    child: ApiClinicTable(
      key: ValueKey(_refreshKey),
      title: 'Patients',
      columns: const [
        'ID',
        'Name',
        'Species / Breed',
        'Owner',
        'Weight',
        'Status',
      ],
      loadRows: AnimalsApi().list,
      mapRow: (animal) => [
        apiCell(animal, 'animal_id'),
        apiCell(animal, 'an_name'),
        [
          apiCell(animal, 'an_species'),
          apiCell(animal, 'an_breed'),
        ].where((value) => value != '—').join(' · '),
        apiCell(animal, 'owner_name'),
        apiCell(animal, 'an_weight'),
        apiCell(animal, 'an_status'),
      ],
      onRowTap: (_) => widget.onNavigate?.call('Patient profile'),
    ),
  );
}
