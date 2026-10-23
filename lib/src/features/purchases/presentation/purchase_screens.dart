import 'package:flutter/material.dart';

import '../../shared/presentation/clinic_ui.dart';

class NewPurchaseScreen extends StatelessWidget {
  const NewPurchaseScreen({super.key});
  @override
  Widget build(BuildContext context) => ClinicPageFrame(
    title: 'New purchase',
    child: LayoutBuilder(
      builder: (context, constraints) {
        final invoice = ClinicPanel(
          title: 'Purchase details',
          child: const Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              SizedBox(
                width: 250,
                child: ClinicSelectField(
                  label: 'Supplier',
                  value: 'Imran Qureshi · PetCare Distributors',
                ),
              ),
              SizedBox(
                width: 210,
                child: ClinicField(label: 'Invoice no', hint: 'PUR-085'),
              ),
            ],
          ),
        );
        final items = ClinicPanel(
          title: 'Items',
          trailing: ClinicOutlineButton(
            label: 'Add item',
            icon: Icons.add,
            onPressed: () => showClinicNotice(context, 'Purchase item added.'),
          ),
          child: const ClinicTable(
            columns: [
              'Medicine',
              'Batch no',
              'Qty',
              'Price',
              'Expiry',
              'Line total',
            ],
            rows: [
              [
                'Amoxicillin 500mg',
                'AMX-2651',
                '50',
                'Rs 10.00',
                '20 Dec 2027',
                'Rs 500.00',
              ],
              [
                'Rabies vaccine',
                'RAB-2620',
                '20',
                'Rs 250.00',
                '14 Mar 2028',
                'Rs 5,000.00',
              ],
            ],
          ),
        );
        final summary = ClinicPanel(
          title: 'Order summary',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const ClinicPriceLine(label: 'Subtotal', amount: 5500),
              const SizedBox(height: 10),
              const ClinicPriceLine(label: 'Discount', amount: 250),
              const Divider(height: 24),
              const ClinicPriceLine(
                label: 'Total',
                amount: 5250,
                large: true,
                color: clinicTeal,
              ),
              const SizedBox(height: 14),
              const Text(
                'Stock and batches update automatically when saved.',
                style: TextStyle(color: clinicMuted),
              ),
              const SizedBox(height: 16),
              ClinicPrimaryButton(
                label: 'Save purchase',
                onPressed: () => showClinicNotice(
                  context,
                  'Purchase saved and stock updated.',
                ),
              ),
            ],
          ),
        );
        if (constraints.maxWidth < 920) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              invoice,
              const SizedBox(height: 16),
              items,
              const SizedBox(height: 16),
              summary,
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            invoice,
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 7, child: items),
                const SizedBox(width: 16),
                Expanded(flex: 4, child: summary),
              ],
            ),
          ],
        );
      },
    ),
  );
}
