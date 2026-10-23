import 'package:flutter/material.dart';

import 'ui_tokens.dart';

export 'ui_tokens.dart';

class ClinicPageFrame extends StatelessWidget {
  const ClinicPageFrame({
    required this.title,
    required this.child,
    this.subtitle,
    this.action,
    super.key,
  });
  final String title;
  final String? subtitle;
  final Widget child;
  final Widget? action;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final compact = constraints.maxWidth < 650;
      return SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          compact ? 16 : 32,
          24,
          compact ? 16 : 32,
          32,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: compact ? constraints.maxWidth - 32 : 600,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: clinicInk,
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle!,
                          style: const TextStyle(color: clinicMuted),
                        ),
                      ],
                    ],
                  ),
                ),
                ?action,
              ],
            ),
            const SizedBox(height: 20),
            child,
          ],
        ),
      );
    },
  );
}

class ClinicPanel extends StatelessWidget {
  const ClinicPanel({
    required this.child,
    this.title,
    this.trailing,
    this.padding = const EdgeInsets.all(20),
    super.key,
  });
  final String? title;
  final Widget child;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: padding,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: clinicLine),
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
        if (title != null) ...[
          Row(
            children: [
              Expanded(
                child: Text(
                  title!,
                  style: const TextStyle(
                    color: clinicInk,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ?trailing,
            ],
          ),
          const SizedBox(height: 16),
        ],
        child,
      ],
    ),
  );
}

class ClinicField extends StatelessWidget {
  const ClinicField({
    required this.label,
    required this.hint,
    this.controller,
    this.obscure = false,
    this.suffix,
    this.lines = 1,
    this.errorText,
    this.enabled = true,
    super.key,
  });
  final String label;
  final String hint;
  final TextEditingController? controller;
  final bool obscure;
  final Widget? suffix;
  final int lines;
  final String? errorText;
  final bool enabled;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(color: clinicInk, fontWeight: FontWeight.w500),
      ),
      const SizedBox(height: 6),
      SizedBox(
        height: lines == 1 && errorText == null ? 44 : null,
        child: TextField(
          controller: controller,
          obscureText: obscure,
          maxLines: lines,
          enabled: enabled,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: suffix,
            errorText: errorText,
            errorStyle: const TextStyle(color: Color(0xFFB91C1C), fontSize: 12),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: clinicTeal, width: 2),
            ),
          ),
        ),
      ),
    ],
  );
}

class ClinicSearchField extends StatelessWidget {
  const ClinicSearchField({required this.hint, this.controller, super.key});
  final String hint;
  final TextEditingController? controller;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 44,
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search, color: clinicMuted),
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: clinicTeal, width: 2),
        ),
      ),
    ),
  );
}

class ClinicSelectField extends StatelessWidget {
  const ClinicSelectField({
    required this.label,
    required this.value,
    super.key,
  });
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(color: clinicInk, fontWeight: FontWeight.w500),
      ),
      const SizedBox(height: 6),
      Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFCBD5E1)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(child: Text(value, overflow: TextOverflow.ellipsis)),
            const Icon(Icons.keyboard_arrow_down, color: clinicMuted),
          ],
        ),
      ),
    ],
  );
}

class ClinicPrimaryButton extends StatelessWidget {
  const ClinicPrimaryButton({
    required this.label,
    this.icon,
    this.onPressed,
    this.loading = false,
    super.key,
  });
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool loading;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 44,
    child: FilledButton.icon(
      onPressed: loading ? null : onPressed,
      icon: loading
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Icon(icon ?? Icons.check, size: 18),
      label: Text(loading ? 'Saving...' : label),
      style: FilledButton.styleFrom(
        backgroundColor: clinicTeal,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
  );
}

class ClinicOutlineButton extends StatelessWidget {
  const ClinicOutlineButton({
    required this.label,
    this.icon,
    this.onPressed,
    super.key,
  });
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 44,
    child: OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon ?? Icons.more_horiz, size: 18),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: clinicInk,
        side: const BorderSide(color: clinicLine),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
  );
}

class ClinicDataPage extends StatelessWidget {
  const ClinicDataPage({
    required this.title,
    required this.columns,
    required this.rows,
    this.action,
    this.chips = const [],
    this.footer,
    this.onAction,
    this.onRowTap,
    this.searchHint,
    super.key,
  });
  final String title;
  final List<String> columns;
  final List<List<String>> rows;
  final String? action;
  final List<String> chips;
  final String? footer;
  final VoidCallback? onAction;
  final ValueChanged<List<String>>? onRowTap;
  final String? searchHint;
  @override
  Widget build(BuildContext context) => ClinicPageFrame(
    title: title,
    action: action == null
        ? null
        : ClinicPrimaryButton(
            label: action!,
            icon: Icons.add,
            onPressed: onAction,
          ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.sizeOf(context).width < 650 ? 260 : 320,
              child: ClinicSearchField(hint: searchHint ?? 'Search $title...'),
            ),
            ClinicOutlineButton(
              label: 'All status',
              icon: Icons.filter_list_outlined,
              onPressed: () {},
            ),
            for (final chip in chips) _CountChip(label: chip),
          ],
        ),
        const SizedBox(height: 16),
        ClinicTable(
          columns: columns,
          rows: rows,
          footer: footer,
          onRowTap: onRowTap,
        ),
      ],
    ),
  );
}

class ClinicTable extends StatelessWidget {
  const ClinicTable({
    required this.columns,
    required this.rows,
    this.title,
    this.footer,
    this.onRowTap,
    this.loading = false,
    super.key,
  });
  final String? title;
  final List<String> columns;
  final List<List<String>> rows;
  final String? footer;
  final ValueChanged<List<String>>? onRowTap;
  final bool loading;
  @override
  Widget build(BuildContext context) => ClinicPanel(
    title: title,
    padding: EdgeInsets.zero,
    child: loading
        ? const _TableSkeleton()
        : rows.isEmpty
        ? const _TableEmptyState()
        : Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: const WidgetStatePropertyAll(
                    Color(0xFFF1F5F9),
                  ),
                  headingRowHeight: 44,
                  dataRowMinHeight: 48,
                  dataRowMaxHeight: 56,
                  horizontalMargin: 20,
                  columnSpacing: 24,
                  columns: [
                    for (final column in columns)
                      DataColumn(
                        label: Text(
                          column.toUpperCase(),
                          style: const TextStyle(
                            color: clinicMuted,
                            fontSize: 12,
                            letterSpacing: .5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                  rows: [
                    for (final row in rows)
                      DataRow(
                        onSelectChanged: onRowTap == null
                            ? null
                            : (_) => onRowTap!(row),
                        cells: [
                          for (var index = 0; index < columns.length; index++)
                            DataCell(
                              _TableCell(
                                value: row[index],
                                column: columns[index],
                              ),
                            ),
                        ],
                      ),
                  ],
                ),
              ),
              if (footer != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      footer!,
                      style: const TextStyle(color: clinicMuted),
                    ),
                  ),
                ),
            ],
          ),
  );
}

class ClinicStatsGrid extends StatelessWidget {
  const ClinicStatsGrid({required this.items, super.key});
  final List<(String, String, Color)> items;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final count = constraints.maxWidth < 580
          ? 2
          : items.length == 3
          ? 3
          : 4;
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: count,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: constraints.maxWidth < 580 ? 1.8 : 2.3,
        ),
        itemBuilder: (context, index) => ClinicPanel(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: items[index].$3,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      items[index].$1,
                      style: const TextStyle(color: clinicMuted),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                items[index].$2,
                style: const TextStyle(
                  color: clinicInk,
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class ClinicTabs extends StatelessWidget {
  const ClinicTabs({required this.labels, this.selectedIndex = 0, super.key});
  final List<String> labels;
  final int selectedIndex;
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        for (var index = 0; index < labels.length; index++)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, 44),
                backgroundColor: index == selectedIndex
                    ? const Color(0xFFCCFBF1)
                    : Colors.white,
                foregroundColor: index == selectedIndex
                    ? clinicTeal
                    : clinicMuted,
                side: BorderSide(
                  color: index == selectedIndex ? clinicTeal : clinicLine,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(labels[index]),
            ),
          ),
      ],
    ),
  );
}

class ClinicSalesChart extends StatelessWidget {
  const ClinicSalesChart({this.title = 'Sales overview', super.key});
  final String title;
  static const _values = [40.0, 60.0, 49.0, 77.0, 65.0, 91.0, 58.0];
  @override
  Widget build(BuildContext context) => ClinicPanel(
    title: title,
    child: SizedBox(
      height: 250,
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var index = 0; index < _values.length; index++)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: FractionallySizedBox(
                        heightFactor: _values[index] / 100,
                        alignment: Alignment.bottomCenter,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: index == _values.length - 1
                                ? clinicTeal
                                : const Color(0xFF99F6E4),
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(6),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('Mon'),
              Text('Tue'),
              Text('Wed'),
              Text('Thu'),
              Text('Fri'),
              Text('Sat'),
              Text('Sun'),
            ],
          ),
        ],
      ),
    ),
  );
}

class ClinicPriceLine extends StatelessWidget {
  const ClinicPriceLine({
    required this.label,
    required this.amount,
    this.large = false,
    this.color,
    super.key,
  });
  final String label;
  final double amount;
  final bool large;
  final Color? color;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(
          label,
          style: TextStyle(
            color: large ? clinicInk : clinicMuted,
            fontSize: large ? 18 : 14,
            fontWeight: large ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ),
      Text(
        '${amount < 0 ? '- ' : ''}Rs ${amount.abs().toStringAsFixed(2)}',
        style: TextStyle(
          color: color ?? clinicInk,
          fontSize: large ? 22 : 14,
          fontWeight: FontWeight.w700,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
    ],
  );
}

class ClinicLogo extends StatelessWidget {
  const ClinicLogo({this.size = 48, super.key});
  final double size;
  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: clinicTeal,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      'V',
      style: TextStyle(
        color: Colors.white,
        fontSize: size * .55,
        fontWeight: FontWeight.w800,
      ),
    ),
  );
}

void showClinicNotice(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

class _TableCell extends StatelessWidget {
  const _TableCell({required this.value, required this.column});
  final String value;
  final String column;
  @override
  Widget build(BuildContext context) {
    if (column.toLowerCase() == 'status' ||
        column == 'Payment' ||
        column == 'Method') {
      return _StatusBadge(label: value);
    }
    if (column == 'Actions') {
      return Wrap(
        children: [
          IconButton(
            tooltip: 'View',
            onPressed: () {},
            icon: const Icon(
              Icons.visibility_outlined,
              size: 18,
              color: clinicTeal,
            ),
          ),
          IconButton(
            tooltip: 'Edit',
            onPressed: () {},
            icon: const Icon(Icons.edit_outlined, size: 18, color: clinicMuted),
          ),
        ],
      );
    }
    return Text(
      value,
      style: TextStyle(
        color: value.startsWith('Rs ') ? clinicInk : clinicMuted,
        fontWeight: value.startsWith('Rs ') ? FontWeight.w600 : FontWeight.w400,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label});
  final String label;
  @override
  Widget build(BuildContext context) {
    final state = label.toLowerCase();
    final danger = state.contains('expired') || state.contains('out of stock');
    final warning = state.contains('low') || state.contains('soon');
    final success =
        state == 'active' ||
        state == 'valid' ||
        state == 'ok' ||
        state == 'in stock' ||
        state == 'cash';
    final foreground = danger
        ? const Color(0xFF991B1B)
        : warning
        ? const Color(0xFF92400E)
        : success
        ? const Color(0xFF065F46)
        : const Color(0xFF1D4ED8);
    final background = danger
        ? const Color(0xFFFEE2E2)
        : warning
        ? const Color(0xFFFEF3C7)
        : success
        ? const Color(0xFFD1FAE5)
        : const Color(0xFFDBEAFE);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: foreground,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _CountChip extends StatelessWidget {
  const _CountChip({required this.label});
  final String label;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: const Color(0xFFFEF3C7),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      label,
      style: const TextStyle(
        color: Color(0xFF92400E),
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

class _TableSkeleton extends StatelessWidget {
  const _TableSkeleton();
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(20),
    child: Column(
      children: [
        for (var row = 0; row < 4; row++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                for (var column = 0; column < 4; column++)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Container(
                        height: 16,
                        decoration: BoxDecoration(
                          color: clinicLine,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
      ],
    ),
  );
}

class _TableEmptyState extends StatelessWidget {
  const _TableEmptyState();
  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.symmetric(vertical: 48, horizontal: 20),
    child: Center(
      child: Column(
        children: [
          Icon(Icons.inbox_outlined, color: clinicMuted, size: 28),
          SizedBox(height: 10),
          Text(
            'No records found',
            style: TextStyle(color: clinicInk, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 4),
          Text(
            'Try changing your search or filters.',
            style: TextStyle(color: clinicMuted),
          ),
        ],
      ),
    ),
  );
}
