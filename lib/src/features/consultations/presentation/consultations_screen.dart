import 'package:flutter/material.dart';

import '../../shared/presentation/clinic_ui.dart';

class ConsultationsScreen extends StatefulWidget {
  const ConsultationsScreen({super.key});
  @override
  State<ConsultationsScreen> createState() => _ConsultationsScreenState();
}

class _ConsultationsScreenState extends State<ConsultationsScreen> {
  final _symptoms = TextEditingController();
  final _diagnosis = TextEditingController();
  final _notes = TextEditingController();
  final _followUp = TextEditingController(text: '20 Oct 2026');

  @override
  void dispose() {
    _symptoms.dispose();
    _diagnosis.dispose();
    _notes.dispose();
    _followUp.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ClinicPageFrame(
    title: 'Consultations',
    child: LayoutBuilder(
      builder: (context, constraints) {
        final table = ClinicTable(
          title: 'Recent consultations',
          columns: const ['Animal', 'Vet', 'Diagnosis', 'Follow-up'],
          rows: const [
            ['Nyxie', 'Dr. Ahmed', 'Viral infection', '20 Oct 2026'],
            ['Tommy', 'Dr. Ahmed', 'Annual check-up', '18 Oct 2026'],
            ['Kitty', 'Dr. Sana', 'Vaccination', '12 Sep 2027'],
          ],
        );
        final form = ClinicPanel(
          title: 'New consultation',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const ClinicSelectField(
                label: 'Animal',
                value: 'Nyxie · Sara Krugs',
              ),
              const SizedBox(height: 14),
              const ClinicSelectField(
                label: 'Veterinarian',
                value: 'Dr. Ahmed',
              ),
              const SizedBox(height: 14),
              ClinicField(
                label: 'Symptoms',
                hint: 'Describe observed symptoms',
                controller: _symptoms,
                lines: 3,
              ),
              const SizedBox(height: 14),
              ClinicField(
                label: 'Diagnosis',
                hint: 'Enter diagnosis',
                controller: _diagnosis,
              ),
              const SizedBox(height: 14),
              ClinicField(
                label: 'Treatment notes',
                hint: 'Add treatment details',
                controller: _notes,
                lines: 3,
              ),
              const SizedBox(height: 14),
              ClinicField(
                label: 'Follow-up date',
                hint: 'Select a date',
                controller: _followUp,
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 8,
                children: [
                  ClinicPrimaryButton(
                    label: 'Save consultation',
                    onPressed: () =>
                        showClinicNotice(context, 'Consultation saved.'),
                  ),
                  ClinicOutlineButton(
                    label: 'Add prescription',
                    icon: Icons.medication_outlined,
                    onPressed: () =>
                        showClinicNotice(context, 'Prescription form opened.'),
                  ),
                ],
              ),
            ],
          ),
        );
        if (constraints.maxWidth < 980) {
          return Column(children: [form, const SizedBox(height: 16), table]);
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 5, child: table),
            const SizedBox(width: 16),
            Expanded(flex: 6, child: form),
          ],
        );
      },
    ),
  );
}
