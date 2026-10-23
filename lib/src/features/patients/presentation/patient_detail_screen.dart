import 'package:flutter/material.dart';

import '../../shared/presentation/clinic_ui.dart';

class PatientDetailScreen extends StatelessWidget {
  const PatientDetailScreen({this.onNavigate, super.key});
  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) => ClinicPageFrame(
    title: 'Patient profile',
    subtitle: 'Home / Patients / Nyxie',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClinicPanel(
          padding: const EdgeInsets.all(18),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 600;
              return Row(
                children: [
                  Container(
                    width: compact ? 64 : 96,
                    height: compact ? 64 : 96,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCCFBF1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'N',
                      style: TextStyle(
                        color: clinicTeal,
                        fontSize: compact ? 28 : 38,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nyxie (Krugs, Sara)',
                          style: TextStyle(
                            color: clinicInk,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'German Shepherd Dog (Canine) · Female · 1y 6m · 78 lbs',
                          style: TextStyle(color: clinicMuted),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD1FAE5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Active',
                      style: TextStyle(
                        color: Color(0xFF065F46),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        const ClinicTabs(
          labels: ['Overview', 'History', 'Appointments', 'Documents'],
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final info = ClinicPanel(
              title: 'Patient info',
              child: const Column(
                children: [
                  _InfoRow(label: 'Color', value: 'Black'),
                  _InfoRow(label: 'Birthdate', value: '11/06/2024'),
                  _InfoRow(label: 'Chip', value: 'CHIP-1384'),
                  _InfoRow(label: 'Provider', value: 'Dr. Ahmed'),
                ],
              ),
            );
            final actions = ClinicPanel(
              title: 'Quick actions',
              child: Column(
                children: [
                  _QuickAction(
                    label: 'New consultation',
                    primary: true,
                    onTap: () => onNavigate?.call('Consultations'),
                  ),
                  _QuickAction(
                    label: 'Add prescription',
                    onTap: () => onNavigate?.call('Prescriptions'),
                  ),
                  _QuickAction(
                    label: 'Create bill',
                    onTap: () => onNavigate?.call('POS Billing'),
                  ),
                  _QuickAction(
                    label: 'Book appointment',
                    onTap: () => showClinicNotice(
                      context,
                      'Appointment booking opened.',
                    ),
                  ),
                ],
              ),
            );
            if (constraints.maxWidth < 760) {
              return Column(
                children: [info, const SizedBox(height: 14), actions],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: info),
                const SizedBox(width: 16),
                Expanded(child: actions),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        const ClinicPanel(
          title: 'Recent activity',
          child: Column(
            children: [
              _ActivityRow(
                date: '05 Oct 2026',
                title: 'Viral infection',
                detail: 'Rx Amoxicillin 500mg · 5 days',
              ),
              Divider(height: 24),
              _ActivityRow(
                date: '12 Sep 2026',
                title: 'Vaccination',
                detail: 'Rabies vaccine',
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        Expanded(
          child: Text(label, style: const TextStyle(color: clinicMuted)),
        ),
        Text(
          value,
          style: const TextStyle(color: clinicInk, fontWeight: FontWeight.w600),
        ),
      ],
    ),
  );
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.label,
    required this.onTap,
    this.primary = false,
  });
  final String label;
  final VoidCallback onTap;
  final bool primary;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: SizedBox(
      width: double.infinity,
      height: 44,
      child: primary
          ? FilledButton.icon(
              onPressed: onTap,
              icon: const Icon(Icons.add, size: 18),
              label: Text(label),
              style: FilledButton.styleFrom(
                backgroundColor: clinicTeal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            )
          : OutlinedButton.icon(
              onPressed: onTap,
              icon: const Icon(Icons.arrow_forward, size: 17),
              label: Text(label),
              style: OutlinedButton.styleFrom(
                foregroundColor: clinicInk,
                side: const BorderSide(color: clinicLine),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
    ),
  );
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({
    required this.date,
    required this.title,
    required this.detail,
  });
  final String date;
  final String title;
  final String detail;
  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Icon(Icons.circle, color: clinicTeal, size: 10),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: clinicInk,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(detail, style: const TextStyle(color: clinicMuted)),
          ],
        ),
      ),
      Text(date, style: const TextStyle(color: clinicMuted)),
    ],
  );
}
