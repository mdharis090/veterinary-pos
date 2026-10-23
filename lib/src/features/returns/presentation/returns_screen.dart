import 'package:flutter/material.dart';

import '../../shared/presentation/clinic_ui.dart';

class ReturnsScreen extends StatelessWidget {
  const ReturnsScreen({super.key});
  @override
  Widget build(BuildContext context) => ClinicPageFrame(
    title: 'Returns',
    child: LayoutBuilder(
      builder: (context, constraints) {
        final list = const ClinicTable(
          title: 'Recent returns',
          columns: ['ID', 'Invoice', 'Medicine', 'Qty', 'Refund', 'Reason'],
          rows: [
            [
              'RET-009',
              'INV-072',
              'Vitamin supplement',
              '1',
              'Rs 180.00',
              'Damaged pack',
            ],
            [
              'RET-008',
              'INV-068',
              'Deworming tablet',
              '2',
              'Rs 150.00',
              'Wrong item',
            ],
          ],
        );
        final form = ClinicPanel(
          title: 'New return',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const ClinicField(
                label: 'Invoice',
                hint: 'Search invoice number',
              ),
              const SizedBox(height: 14),
              const ClinicSelectField(
                label: 'Medicine',
                value: 'Select an item',
              ),
              const SizedBox(height: 14),
              const ClinicField(label: 'Quantity', hint: 'Enter quantity'),
              const SizedBox(height: 14),
              const ClinicField(label: 'Refund amount', hint: 'Rs 0.00'),
              const SizedBox(height: 14),
              const ClinicField(
                label: 'Reason',
                hint: 'Select or describe reason',
                lines: 2,
              ),
              const SizedBox(height: 16),
              ClinicPrimaryButton(
                label: 'Process refund',
                icon: Icons.currency_exchange,
                onPressed: () => showClinicNotice(context, 'Refund processed.'),
              ),
            ],
          ),
        );
        if (constraints.maxWidth < 960) {
          return Column(children: [form, const SizedBox(height: 16), list]);
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 6, child: list),
            const SizedBox(width: 16),
            Expanded(flex: 5, child: form),
          ],
        );
      },
    ),
  );
}
