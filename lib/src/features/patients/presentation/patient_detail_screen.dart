import 'package:flutter/material.dart';

class PatientDetailScreen extends StatelessWidget {
  const PatientDetailScreen({this.onNavigate, super.key});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 650;
        final horizontalPadding = isNarrow ? 14.0 : 20.0;

        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            18,
            horizontalPadding,
            26,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Home / Patients / Nyxie',
                style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 12),
              _PatientHeader(isNarrow: isNarrow, onNavigate: onNavigate),
              const SizedBox(height: 20),
              const Row(
                children: [
                  _TabItem(label: 'Overview', selected: true),
                  _TabItem(label: 'History'),
                  _TabItem(label: 'Appointments'),
                  _TabItem(label: 'Documents'),
                ],
              ),
              const SizedBox(height: 14),
              if (isNarrow) ...[
                const _PatientInfoPanel(),
                const SizedBox(height: 12),
                _QuickActionsPanel(onNavigate: onNavigate),
              ] else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(child: _PatientInfoPanel()),
                    SizedBox(width: 18),
                    Expanded(child: _QuickActionsPanel(onNavigate: onNavigate)),
                  ],
                ),
              const SizedBox(height: 18),
              const _RecentActivityPanel(),
            ],
          ),
        );
      },
    );
  }
}

class _PatientHeader extends StatelessWidget {
  const _PatientHeader({required this.isNarrow, this.onNavigate});

  final bool isNarrow;
  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isNarrow ? 12 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE3E8EE)),
      ),
      child: Row(
        children: [
          Container(
            width: isNarrow ? 64 : 96,
            height: isNarrow ? 64 : 96,
            decoration: BoxDecoration(
              color: const Color(0xFFCCF8F0),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                'N',
                style: TextStyle(
                  fontSize: isNarrow ? 26 : 32,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0E7B71),
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 6,
                  children: const [
                    Text(
                      'Nyxie',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1D2D3D),
                      ),
                    ),
                    Text(
                      '(Krugs, Sara)',
                      style: TextStyle(fontSize: 14, color: Color(0xFF4F5E72)),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                const Text(
                  'German Shepherd Dog (Canine) · Female · 1y 6m · 78 lbs',
                  style: TextStyle(fontSize: 14, color: Color(0xFF66768A)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFDAF5ED),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Text(
              'Active',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0E7B71),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({required this.label, this.selected = false});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              color: selected
                  ? const Color(0xFF0E7B71)
                  : const Color(0xFF72829A),
            ),
          ),
        ),
      ),
    );
  }
}

class _PatientInfoPanel extends StatelessWidget {
  const _PatientInfoPanel();

  @override
  Widget build(BuildContext context) {
    return _Panel(
      title: 'Patient info',
      child: Column(
        children: const [
          _InfoRow(label: 'Color', value: 'Black'),
          _InfoRow(label: 'Birthdate', value: '11/06/2024'),
          _InfoRow(label: 'Chip', value: 'CHIP-1384'),
          _InfoRow(label: 'Provider', value: 'Dr. Ahmed'),
        ],
      ),
    );
  }
}

class _QuickActionsPanel extends StatelessWidget {
  const _QuickActionsPanel({this.onNavigate});

  final ValueChanged<String>? onNavigate;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      title: 'Quick actions',
      child: Column(
        children: [
          _ActionButton(
            label: 'New consultation',
            filled: true,
            onPressed: () => onNavigate?.call('Consultations'),
          ),
          _ActionButton(
            label: 'Add prescription',
            onPressed: () => onNavigate?.call('Prescriptions'),
          ),
          _ActionButton(
            label: 'Create bill',
            onPressed: () => onNavigate?.call('POS Billing'),
          ),
          _ActionButton(
            label: 'Book appointment',
            onPressed: () => onNavigate?.call('Consultations'),
          ),
          _ActionButton(
            label: 'All patients',
            onPressed: () => onNavigate?.call('Patients list'),
          ),
        ],
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE3E8EE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1C2E40),
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Color(0xFF63778B), fontSize: 14),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF233447),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    this.filled = false,
    this.onPressed,
  });

  final String label;
  final bool filled;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: SizedBox(
        width: double.infinity,
        height: 44,
        child: filled
            ? ElevatedButton(
                onPressed: onPressed ?? () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0C7F74),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            : OutlinedButton(
                onPressed: onPressed ?? () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF173149),
                  side: const BorderSide(color: Color(0xFFE3E8EE)),
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(label, style: const TextStyle(fontSize: 14)),
              ),
      ),
    );
  }
}

class _RecentActivityPanel extends StatelessWidget {
  const _RecentActivityPanel();
  @override
  Widget build(BuildContext context) {
    return _Panel(
      title: 'Recent activity',
      child: const Column(
        children: [
          _ActivityRow(
            title:
                '05 Oct 2026 · Viral infection · Rx Amoxicillin 500mg, 5 days',
            author: 'Dr. Ahmed',
          ),
          Divider(color: Color(0xFFE5EBF0), height: 20),
          _ActivityRow(
            title: '12 Sep 2026 · Vaccination · Rabies',
            author: 'Dr. Ahmed',
          ),
        ],
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({required this.title, required this.author});

  final String title;
  final String author;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 14, color: Color(0xFF2F4157)),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          author,
          style: const TextStyle(fontSize: 14, color: Color(0xFF6C7E92)),
        ),
      ],
    );
  }
}
