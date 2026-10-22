import 'package:flutter/material.dart';

class DashboardTableEntry {
  const DashboardTableEntry(this.label, this.value, {this.badge = false});

  final String label;
  final String value;
  final bool badge;
}

class DashboardTablePanel extends StatelessWidget {
  const DashboardTablePanel({
    required this.title,
    required this.entries,
    super.key,
  });

  final String title;
  final List<DashboardTableEntry> entries;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8ED)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x080E3550),
            blurRadius: 7,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF17283F),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          for (var index = 0; index < entries.length; index++) ...[
            _EntryRow(entry: entries[index]),
            if (index < entries.length - 1)
              const Divider(height: 1, color: Color(0xFFF0F2F4)),
          ],
        ],
      ),
    );
  }
}

class _EntryRow extends StatelessWidget {
  const _EntryRow({required this.entry});

  final DashboardTableEntry entry;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Row(
        children: [
          Expanded(
            child: Text(
              entry.label,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Color(0xFF41516A), fontSize: 14),
            ),
          ),
          if (entry.badge)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0C7),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                entry.value,
                style: const TextStyle(
                  color: Color(0xFF8B5C0A),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          else
            Text(
              entry.value,
              style: const TextStyle(color: Color(0xFF56667E), fontSize: 14),
            ),
        ],
      ),
    );
  }
}
