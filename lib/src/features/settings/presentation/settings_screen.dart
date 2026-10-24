import 'package:flutter/material.dart';

import '../../shared/presentation/clinic_ui.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const _sections = [
    'Profile',
    'Users',
    'Roles',
    'Clinic info',
    'Notifications',
    'Backup',
  ];
  String _selected = 'Profile';
  @override
  Widget build(BuildContext context) => ClinicPageFrame(
    title: 'Settings',
    child: LayoutBuilder(
      builder: (context, constraints) {
        final menu = ClinicPanel(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              for (final section in _sections)
                Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  child: ListTile(
                    selected: section == _selected,
                    selectedTileColor: const Color(0xFFCCFBF1),
                    selectedColor: clinicTeal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    title: Text(section),
                    onTap: () => setState(() => _selected = section),
                  ),
                ),
            ],
          ),
        );
        final profile = ClinicPanel(
          title: _selected,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const ClinicField(label: 'Full name', hint: 'Dr. Ahmed'),
              const SizedBox(height: 14),
              const ClinicField(label: 'Username', hint: 'ahmed.vet'),
              const SizedBox(height: 14),
              const ClinicField(label: 'Email', hint: 'ahmed@vetnalay.pk'),
              const SizedBox(height: 14),
              const ClinicField(label: 'Phone', hint: '+92 300 1234567'),
              const SizedBox(height: 14),
              const ClinicSelectField(label: 'Role', value: 'Veterinarian'),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: ClinicPrimaryButton(
                  label: 'Save changes',
                  onPressed: () => showClinicNotice(context, 'Settings saved.'),
                ),
              ),
            ],
          ),
        );
        if (constraints.maxWidth < 780) {
          return Column(children: [menu, const SizedBox(height: 16), profile]);
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 220, child: menu),
            const SizedBox(width: 16),
            Expanded(child: profile),
          ],
        );
      },
    ),
  );
}
