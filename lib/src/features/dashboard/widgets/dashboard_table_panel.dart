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
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: const Color(0xFFE2E8F0)),
      boxShadow: const [
        BoxShadow(
          color: Color(0x080F172A),
          blurRadius: 2,
          offset: Offset(0, 1),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        for (var index = 0; index < entries.length; index++) ...[
          SizedBox(
            height: 44,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    entries[index].label,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Color(0xFF475569)),
                  ),
                ),
                if (entries[index].badge)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      entries[index].value,
                      style: const TextStyle(
                        color: Color(0xFF92400E),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                else
                  Text(
                    entries[index].value,
                    style: const TextStyle(color: Color(0xFF64748B)),
                  ),
              ],
            ),
          ),
          if (index < entries.length - 1)
            const Divider(height: 1, color: Color(0xFFF1F5F9)),
        ],
      ],
    ),
  );
}
