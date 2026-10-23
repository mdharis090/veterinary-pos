import 'package:flutter/material.dart';

import '../../shared/presentation/clinic_ui.dart';

class PosBillingScreen extends StatefulWidget {
  const PosBillingScreen({super.key});

  @override
  State<PosBillingScreen> createState() => _PosBillingScreenState();
}

class _PosBillingScreenState extends State<PosBillingScreen> {
  final Map<String, int> _cart = {'Amoxicillin 500mg': 5, 'Rabies vaccine': 2};
  String _paymentMethod = 'Cash';
  double get _subtotal => _cart.entries.fold(
    0,
    (total, item) =>
        total + item.value * (item.key.startsWith('Amoxicillin') ? 10 : 250),
  );
  double get _total => _subtotal - 50;

  void _add(String medicine) => setState(
    () => _cart.update(medicine, (qty) => qty + 1, ifAbsent: () => 1),
  );

  void _decrement(String medicine) => setState(() {
    final quantity = _cart[medicine] ?? 0;
    if (quantity <= 1) {
      _cart.remove(medicine);
    } else {
      _cart[medicine] = quantity - 1;
    }
  });

  @override
  Widget build(BuildContext context) => ClinicPageFrame(
    title: 'POS Billing',
    subtitle: 'Invoice INV-001',
    child: LayoutBuilder(
      builder: (context, constraints) {
        final desktop = constraints.maxWidth >= 900;
        final products = Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ClinicPanel(
              title: 'Customer',
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  SizedBox(
                    width: 220,
                    child: ClinicSelectField(
                      label: 'Owner',
                      value: 'Sara Krugs',
                    ),
                  ),
                  SizedBox(
                    width: 220,
                    child: ClinicSelectField(label: 'Animal', value: 'Nyxie'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            ClinicPanel(
              title: 'Medicines',
              child: Column(
                children: [
                  const ClinicSearchField(
                    hint: 'Search medicine or scan barcode',
                  ),
                  const SizedBox(height: 10),
                  for (final item in const [
                    ('Amoxicillin 500mg', '90 in stock', 'Rs 10.00'),
                    ('Rabies vaccine', '38 in stock', 'Rs 250.00'),
                    ('Deworming tablet', '64 in stock', 'Rs 75.00'),
                  ])
                    _MedicineRow(item: item, onAdd: () => _add(item.$1)),
                ],
              ),
            ),
          ],
        );
        final checkout = Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClinicPanel(
              title: 'Cart',
              trailing: Text(
                '${_cart.values.fold<int>(0, (total, value) => total + value)} items',
              ),
              child: Column(
                children: [
                  for (final item in _cart.entries)
                    _CartRow(
                      name: item.key,
                      quantity: item.value,
                      amount:
                          item.value *
                          (item.key.startsWith('Amoxicillin') ? 10 : 250),
                      onRemove: () => _decrement(item.key),
                    ),
                  const Divider(),
                  ClinicPriceLine(label: 'Subtotal', amount: _subtotal),
                  const SizedBox(height: 8),
                  const ClinicPriceLine(
                    label: 'Discount',
                    amount: -50,
                    color: Color(0xFF059669),
                  ),
                  const SizedBox(height: 12),
                  ClinicPriceLine(
                    label: 'Total',
                    amount: _total,
                    large: true,
                    color: clinicTeal,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            ClinicPanel(
              title: 'Payment',
              child: Row(
                children: [
                  for (final method in const ['Cash', 'Card', 'Online'])
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: OutlinedButton(
                          onPressed: () =>
                              setState(() => _paymentMethod = method),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(0, 44),
                            foregroundColor: _paymentMethod == method
                                ? clinicTeal
                                : clinicMuted,
                            backgroundColor: _paymentMethod == method
                                ? const Color(0xFFCCFBF1)
                                : Colors.white,
                            side: BorderSide(
                              color: _paymentMethod == method
                                  ? clinicTeal
                                  : clinicLine,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(method),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ClinicOutlineButton(
                    label: 'Save',
                    icon: Icons.save_outlined,
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ClinicOutlineButton(
                    label: 'Print',
                    icon: Icons.print_outlined,
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: ClinicPrimaryButton(
                    label: 'Complete sale',
                    onPressed: () =>
                        showClinicNotice(context, 'Sale completed · INV-001'),
                  ),
                ),
              ],
            ),
          ],
        );

        if (desktop) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 11, child: products),
              const SizedBox(width: 18),
              Expanded(flex: 9, child: checkout),
            ],
          );
        }
        return Column(
          children: [products, const SizedBox(height: 14), checkout],
        );
      },
    ),
  );
}

class _MedicineRow extends StatelessWidget {
  const _MedicineRow({required this.item, required this.onAdd});
  final (String, String, String) item;
  final VoidCallback onAdd;
  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minHeight: 56),
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: clinicLine)),
    ),
    child: Row(
      children: [
        const CircleAvatar(
          radius: 18,
          backgroundColor: Color(0xFFCCFBF1),
          child: Icon(Icons.medication_outlined, color: clinicTeal, size: 19),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.$1,
                style: const TextStyle(
                  color: clinicInk,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                item.$2,
                style: const TextStyle(color: clinicMuted, fontSize: 12),
              ),
            ],
          ),
        ),
        Text(item.$3, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(width: 8),
        IconButton.filledTonal(
          onPressed: onAdd,
          tooltip: 'Add ${item.$1}',
          icon: const Icon(Icons.add),
        ),
      ],
    ),
  );
}

class _CartRow extends StatelessWidget {
  const _CartRow({
    required this.name,
    required this.quantity,
    required this.amount,
    required this.onRemove,
  });
  final String name;
  final int quantity;
  final double amount;
  final VoidCallback onRemove;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Expanded(child: Text(name)),
        IconButton(
          onPressed: onRemove,
          tooltip: 'Remove one',
          icon: const Icon(Icons.remove_circle_outline),
        ),
        Text('$quantity'),
        const SizedBox(width: 8),
        SizedBox(
          width: 90,
          child: Text(
            'Rs ${amount.toStringAsFixed(2)}',
            textAlign: TextAlign.end,
          ),
        ),
      ],
    ),
  );
}
