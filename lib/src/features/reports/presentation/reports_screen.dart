import 'package:flutter/material.dart';

import '../../shared/presentation/clinic_ui.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});
  @override
  Widget build(BuildContext context) => ClinicPageFrame(
    title: 'Reports',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClinicPanel(
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.end,
            children: [
              const SizedBox(
                width: 190,
                child: ClinicField(label: 'From', hint: '01 Oct 2026'),
              ),
              const SizedBox(
                width: 190,
                child: ClinicField(label: 'To', hint: '07 Oct 2026'),
              ),
              ClinicPrimaryButton(
                label: 'Apply filter',
                onPressed: () =>
                    showClinicNotice(context, 'Report filter applied.'),
              ),
              ClinicOutlineButton(
                label: 'Export PDF',
                icon: Icons.picture_as_pdf_outlined,
                onPressed: () =>
                    showClinicNotice(context, 'PDF export is ready.'),
              ),
              ClinicOutlineButton(
                label: 'Export Excel',
                icon: Icons.table_view_outlined,
                onPressed: () =>
                    showClinicNotice(context, 'Excel export is ready.'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const ClinicSalesChart(),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final medicines = ClinicTable(
              title: 'Top medicines',
              columns: const ['Medicine', 'Units sold'],
              rows: const [
                ['Amoxicillin 500mg', '50'],
                ['Rabies vaccine', '30'],
                ['Deworming tablet', '20'],
              ],
            );
            final customers = ClinicTable(
              title: 'Top customers',
              columns: const ['Owner', 'Visits', 'Sales'],
              rows: const [
                ['Sara Krugs', '8', 'Rs 4,250'],
                ['Ali Raza', '6', 'Rs 3,100'],
                ['Hina Khan', '5', 'Rs 2,850'],
              ],
            );
            if (constraints.maxWidth < 760) {
              return Column(
                children: [medicines, const SizedBox(height: 16), customers],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: medicines),
                const SizedBox(width: 16),
                Expanded(child: customers),
              ],
            );
          },
        ),
      ],
    ),
  );
}
