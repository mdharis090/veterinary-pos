import 'package:flutter/material.dart';

const _teal = Color(0xFF0F766E);
const _ink = Color(0xFF0F172A);
const _muted = Color(0xFF64748B);
const _line = Color(0xFFE2E8F0);

class ClinicPage extends StatelessWidget {
  const ClinicPage({required this.page, required this.onNavigate, super.key});
  final String page;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    if (page == 'POS Billing') return _PosPage();
    if (page == 'Consultations') return _ConsultationsPage();
    if (page == 'Inventory') return _InventoryPage();
    if (page == 'Returns') return _ReturnsPage();
    if (page == 'Payments') return _PaymentsPage();
    if (page == 'Reports') return _ReportsPage();
    if (page == 'Settings') return _SettingsPage();
    if (page == 'New purchase') return _NewPurchasePage();
    final data = _tables[page];
    if (data == null) return const SizedBox.shrink();
    return _DataPage(
      title: page,
      columns: data.$1,
      rows: data.$2,
      action: page == 'Sales'
          ? null
          : 'Add ${page == 'Patients'
                ? 'patient'
                : page == 'Owners'
                ? 'owner'
                : page == 'Purchases'
                ? 'purchase'
                : page == 'Prescriptions'
                ? 'prescription'
                : page == 'Suppliers'
                ? 'supplier'
                : page == 'Batches'
                ? 'batch'
                : 'medicine'}',
      chips: page == 'Medicines'
          ? const ['1 low stock', '1 expired']
          : const [],
      footer: page == 'Owners' ? 'Showing 1-5 of 5' : null,
      onAction: page == 'Purchases' ? () => onNavigate('New purchase') : null,
      onRowTap: page == 'Patients'
          ? (_) => onNavigate('Patient profile')
          : null,
    );
  }
}

const Map<String, (List<String>, List<List<String>>)> _tables = {
  'Owners': (
    ['ID', 'Name', 'Phone', 'City', 'Actions'],
    [
      ['OWN-001', 'Sara Krugs', '+92 300 1234567', 'Lahore', 'View · Edit'],
      ['OWN-002', 'Ali Raza', '+92 321 7654321', 'Karachi', 'View · Edit'],
      ['OWN-003', 'Hina Khan', '+92 333 4567890', 'Islamabad', 'View · Edit'],
      ['OWN-004', 'Ahmed Malik', '+92 301 9876543', 'Lahore', 'View · Edit'],
      [
        'OWN-005',
        'Fatima Sheikh',
        '+92 322 3456789',
        'Rawalpindi',
        'View · Edit',
      ],
    ],
  ),
  'Patients': (
    ['ID', 'Name', 'Species / Breed', 'Owner', 'Weight', 'Status', 'Actions'],
    [
      [
        'PAT-001',
        'Nyxie',
        'Dog · German Shepherd',
        'Sara Krugs',
        '78 lbs',
        'Active',
        'View · Edit',
      ],
      [
        'PAT-002',
        'Tommy',
        'Cat · Domestic shorthair',
        'Ali Raza',
        '12 lbs',
        'Active',
        'View · Edit',
      ],
      [
        'PAT-003',
        'Kitty',
        'Cat · Persian',
        'Hina Khan',
        '9 lbs',
        'Active',
        'View · Edit',
      ],
      [
        'PAT-004',
        'Rocky',
        'Dog · Labrador Retriever',
        'Ahmed Malik',
        '64 lbs',
        'Active',
        'View · Edit',
      ],
    ],
  ),
  'Prescriptions': (
    ['Medicine', 'Dosage', 'Duration', 'Diagnosis', 'Notes', 'Actions'],
    [
      [
        'Amoxicillin 500mg',
        '1 tablet, twice daily',
        '5 days',
        'Viral infection',
        'Give with food',
        'View · Edit',
      ],
      [
        'Rabies vaccine',
        '1 dose',
        'Once',
        'Vaccination',
        'Next due Oct 2027',
        'View · Edit',
      ],
      [
        'Deworming tablet',
        '1 tablet',
        'Once',
        'Preventive care',
        'Repeat in 3 months',
        'View · Edit',
      ],
    ],
  ),
  'Medicines': (
    ['ID', 'Name', 'Category', 'Stock', 'Price', 'Status', 'Actions'],
    [
      [
        'MED-001',
        'Amoxicillin 500mg',
        'Antibiotic',
        '15',
        'Rs 10.00',
        'Low stock',
        'View · Edit',
      ],
      [
        'MED-002',
        'Rabies vaccine',
        'Vaccine',
        '8',
        'Rs 250.00',
        'Low stock',
        'View · Edit',
      ],
      [
        'MED-003',
        'Deworming tablet',
        'Preventive',
        '64',
        'Rs 75.00',
        'In stock',
        'View · Edit',
      ],
      [
        'MED-004',
        'Vitamin supplement',
        'Supplement',
        '0',
        'Rs 120.00',
        'Expired',
        'View · Edit',
      ],
      [
        'MED-005',
        'Antiseptic spray',
        'First aid',
        '42',
        'Rs 180.00',
        'In stock',
        'View · Edit',
      ],
    ],
  ),
  'Batches': (
    ['Batch no', 'Medicine', 'Expiry', 'Qty', 'Status', 'Actions'],
    [
      [
        'AMX-24091',
        'Amoxicillin 500mg',
        '12 Dec 2026',
        '15',
        'Valid',
        'View · Edit',
      ],
      [
        'RAB-24118',
        'Rabies vaccine',
        '28 Oct 2026',
        '8',
        'Expiring soon',
        'View · Edit',
      ],
      [
        'DWR-24075',
        'Deworming tablet',
        '18 Mar 2027',
        '64',
        'Valid',
        'View · Edit',
      ],
      [
        'VIT-23011',
        'Vitamin supplement',
        '05 Sep 2026',
        '0',
        'Expired',
        'View · Edit',
      ],
    ],
  ),
  'Suppliers': (
    ['ID', 'Name', 'Company', 'Contact', 'Address', 'Status', 'Actions'],
    [
      [
        'SUP-001',
        'Usman Tariq',
        'PetCare Pharma',
        '+92 300 5566778',
        'Gulberg, Lahore',
        'Active',
        'View · Edit',
      ],
      [
        'SUP-002',
        'Sana Iqbal',
        'VetMed Supplies',
        '+92 321 1122334',
        'Clifton, Karachi',
        'Active',
        'View · Edit',
      ],
      [
        'SUP-003',
        'Bilal Ahmed',
        'Animal Health Co.',
        '+92 333 9988776',
        'F-7, Islamabad',
        'Active',
        'View · Edit',
      ],
    ],
  ),
  'Purchases': (
    [
      'Invoice',
      'Supplier',
      'Company',
      'Subtotal',
      'Discount',
      'Total',
      'Actions',
    ],
    [
      [
        'PUR-2026-041',
        'Usman Tariq',
        'PetCare Pharma',
        'Rs 18,500',
        'Rs 500',
        'Rs 18,000',
        'View · Print',
      ],
      [
        'PUR-2026-040',
        'Sana Iqbal',
        'VetMed Supplies',
        'Rs 12,000',
        'Rs 0',
        'Rs 12,000',
        'View · Print',
      ],
      [
        'PUR-2026-039',
        'Bilal Ahmed',
        'Animal Health Co.',
        'Rs 9,250',
        'Rs 250',
        'Rs 9,000',
        'View · Print',
      ],
    ],
  ),
  'Sales': (
    ['Invoice', 'Owner', 'Animal', 'Date', 'Total', 'Payment', 'Actions'],
    [
      [
        'INV-001',
        'Sara Krugs',
        'Nyxie',
        '05 Oct 2026',
        'Rs 500.00',
        'Cash',
        'View · Print',
      ],
      [
        'INV-002',
        'Ali Raza',
        'Tommy',
        '04 Oct 2026',
        'Rs 1,250.00',
        'Card',
        'View · Print',
      ],
      [
        'INV-003',
        'Hina Khan',
        'Kitty',
        '03 Oct 2026',
        'Rs 750.00',
        'Online',
        'View · Print',
      ],
    ],
  ),
};

class LoginScreen extends StatefulWidget {
  const LoginScreen({required this.onSignIn, super.key});
  final VoidCallback onSignIn;
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _hidePassword = true;
  bool _remember = true;
  bool _isLoading = false;
  String? _usernameError;
  String? _passwordError;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    setState(() {
      _usernameError = _usernameController.text.trim().isEmpty
          ? 'Username is required.'
          : null;
      _passwordError = _passwordController.text.isEmpty
          ? 'Password is required.'
          : null;
    });
    if (_usernameError != null || _passwordError != null) return;
    setState(() => _isLoading = true);
    widget.onSignIn();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF134E4A),
    body: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(child: _Logo()),
                const SizedBox(height: 20),
                const Text(
                  'Veterinary POS',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: _ink,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Welcome back. Sign in to continue.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: _muted),
                ),
                const SizedBox(height: 28),
                _Field(
                  label: 'Username',
                  hint: 'Enter your username',
                  controller: _usernameController,
                  errorText: _usernameError,
                  enabled: !_isLoading,
                ),
                const SizedBox(height: 18),
                _Field(
                  label: 'Password',
                  hint: 'Enter your password',
                  obscure: _hidePassword,
                  controller: _passwordController,
                  errorText: _passwordError,
                  enabled: !_isLoading,
                  suffix: IconButton(
                    tooltip: _hidePassword ? 'Show password' : 'Hide password',
                    onPressed: () =>
                        setState(() => _hidePassword = !_hidePassword),
                    icon: Icon(
                      _hidePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                        title: const Text(
                          'Remember me',
                          style: TextStyle(fontSize: 14),
                        ),
                        value: _remember,
                        onChanged: (value) =>
                            setState(() => _remember = value ?? false),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Forgot password?'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _PrimaryButton(
                  label: 'Sign In',
                  onPressed: _submit,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 22),
                const Text(
                  'New here? Contact admin',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: _muted),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class _PosPage extends StatefulWidget {
  @override
  State<_PosPage> createState() => _PosPageState();
}

class _PosPageState extends State<_PosPage> {
  final Map<String, int> _cart = {'Amoxicillin 500mg': 5, 'Rabies vaccine': 2};
  String _method = 'Cash';
  @override
  Widget build(BuildContext context) {
    final desktop = MediaQuery.sizeOf(context).width >= 900;
    final left = Column(
      children: [
        const _CustomerCard(),
        const SizedBox(height: 16),
        _MedicineCard(
          onAdd: (name) => setState(
            () => _cart.update(name, (qty) => qty + 1, ifAbsent: () => 1),
          ),
        ),
      ],
    );
    final right = Column(
      children: [
        _CartCard(
          cart: _cart,
          onRemove: (name) => setState(() {
            if ((_cart[name] ?? 0) < 2) {
              _cart.remove(name);
            } else {
              _cart[name] = _cart[name]! - 1;
            }
          }),
        ),
        const SizedBox(height: 16),
        _Panel(
          title: 'Payment',
          child: Row(
            children: [
              for (final option in ['Cash', 'Card', 'Online'])
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: OutlinedButton(
                      onPressed: () => setState(() => _method = option),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 44),
                        backgroundColor: option == _method
                            ? const Color(0xFFCCFBF1)
                            : Colors.white,
                        foregroundColor: option == _method ? _teal : _muted,
                        side: BorderSide(
                          color: option == _method ? _teal : _line,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(option),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Expanded(child: _OutlineButton(label: 'Save')),
            const SizedBox(width: 8),
            const Expanded(child: _OutlineButton(label: 'Print')),
            const SizedBox(width: 8),
            Expanded(
              flex: 2,
              child: _PrimaryButton(
                label: 'Complete sale',
                onPressed: () => _notify(context, 'Sale completed · INV-001'),
              ),
            ),
          ],
        ),
      ],
    );
    return _PageFrame(
      title: 'POS Billing',
      subtitle: 'Invoice INV-001',
      child: desktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 11, child: SizedBox(height: 560, child: left)),
                const SizedBox(width: 20),
                Expanded(flex: 9, child: right),
              ],
            )
          : Column(
              children: [
                const _CustomerCard(),
                const SizedBox(height: 12),
                _MedicineCard(
                  onAdd: (name) => setState(
                    () =>
                        _cart.update(name, (qty) => qty + 1, ifAbsent: () => 1),
                  ),
                ),
                const SizedBox(height: 12),
                _CartCard(
                  cart: _cart,
                  onRemove: (name) => setState(() {
                    if ((_cart[name] ?? 0) < 2) {
                      _cart.remove(name);
                    } else {
                      _cart[name] = _cart[name]! - 1;
                    }
                  }),
                ),
                const SizedBox(height: 12),
                _Panel(
                  title: 'Payment',
                  child: Row(
                    children: [
                      for (final option in ['Cash', 'Card', 'Online'])
                        Expanded(
                          child: TextButton(
                            onPressed: () => setState(() => _method = option),
                            child: Text(
                              option,
                              style: TextStyle(
                                color: _method == option ? _teal : _muted,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _PrimaryButton(
                  label: 'Save and print',
                  onPressed: () => _notify(context, 'Sale saved for printing'),
                ),
              ],
            ),
    );
  }
}

class _CustomerCard extends StatelessWidget {
  const _CustomerCard();
  @override
  Widget build(BuildContext context) => _Panel(
    title: 'Customer',
    child: Wrap(
      spacing: 12,
      runSpacing: 12,
      children: const [
        _Select(label: 'Owner', value: 'Sara Krugs'),
        _Select(label: 'Animal', value: 'Nyxie'),
      ],
    ),
  );
}

class _MedicineCard extends StatelessWidget {
  const _MedicineCard({required this.onAdd});
  final ValueChanged<String> onAdd;
  @override
  Widget build(BuildContext context) => _Panel(
    title: 'Medicines',
    child: Column(
      children: [
        const _Search(hint: 'Search medicine or scan barcode'),
        const SizedBox(height: 10),
        for (final item in const [
          ('Amoxicillin 500mg', '90 in stock', 'Rs 10.00'),
          ('Rabies vaccine', '38 in stock', 'Rs 250.00'),
          ('Deworming tablet', '64 in stock', 'Rs 75.00'),
        ])
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: Color(0xFFCCFBF1),
                  child: Icon(
                    Icons.medication_outlined,
                    color: _teal,
                    size: 19,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.$1,
                        style: const TextStyle(
                          color: _ink,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        item.$2,
                        style: const TextStyle(color: _muted, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Text(
                  item.$3,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),
                IconButton.filledTonal(
                  onPressed: () => onAdd(item.$1),
                  tooltip: 'Add ${item.$1}',
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
      ],
    ),
  );
}

class _CartCard extends StatelessWidget {
  const _CartCard({required this.cart, required this.onRemove});
  final Map<String, int> cart;
  final ValueChanged<String> onRemove;
  @override
  Widget build(BuildContext context) {
    var subtotal = 0.0;
    for (final item in cart.entries) {
      subtotal += item.value * (item.key.startsWith('Amoxicillin') ? 10 : 250);
    }
    return _Panel(
      title: 'Cart',
      trailing: Text(
        '${cart.values.fold<int>(0, (sum, qty) => sum + qty)} items',
        style: const TextStyle(color: _muted),
      ),
      child: Column(
        children: [
          for (final item in cart.entries)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      item.key,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  IconButton(
                    onPressed: () => onRemove(item.key),
                    icon: const Icon(
                      Icons.remove_circle_outline,
                      color: _muted,
                    ),
                  ),
                  Text(
                    '${item.value}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 100,
                    child: Text(
                      'Rs ${(item.value * (item.key.startsWith('Amoxicillin') ? 10 : 250)).toStringAsFixed(2)}',
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const Divider(color: _line),
          _PriceLine(label: 'Subtotal', amount: subtotal),
          const SizedBox(height: 8),
          const _PriceLine(
            label: 'Discount',
            amount: -50,
            color: Color(0xFF059669),
          ),
          const SizedBox(height: 12),
          _PriceLine(
            label: 'Total',
            amount: subtotal - 50,
            large: true,
            color: _teal,
          ),
        ],
      ),
    );
  }
}

class _ConsultationsPage extends StatelessWidget {
  const _ConsultationsPage();
  @override
  Widget build(BuildContext context) => _PageFrame(
    title: 'Consultations',
    action: const _PrimaryButton(label: 'New consultation', icon: Icons.add),
    child: LayoutBuilder(
      builder: (context, constraints) {
        const history = _Table(
          title: 'Recent consultations',
          columns: ['Animal', 'Vet', 'Diagnosis', 'Follow-up'],
          rows: [
            ['Nyxie', 'Dr. Ahmed', 'Viral infection', '15 Oct 2026'],
            ['Tommy', 'Dr. Ahmed', 'Dental check', '18 Oct 2026'],
            ['Rocky', 'Dr. Sana', 'Skin allergy', '22 Oct 2026'],
          ],
        );
        const form = _ConsultForm();
        return constraints.maxWidth < 900
            ? const Column(children: [form, SizedBox(height: 16), history])
            : const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 11, child: history),
                  SizedBox(width: 18),
                  Expanded(flex: 9, child: form),
                ],
              );
      },
    ),
  );
}

class _ConsultForm extends StatelessWidget {
  const _ConsultForm();
  @override
  Widget build(BuildContext context) => _Panel(
    title: 'New consultation',
    child: Column(
      children: const [
        _Select(label: 'Animal', value: 'Nyxie · Sara Krugs'),
        SizedBox(height: 12),
        _Select(label: 'Vet', value: 'Dr. Ahmed'),
        SizedBox(height: 12),
        _Field(label: 'Symptoms', hint: 'Describe symptoms', lines: 2),
        SizedBox(height: 12),
        _Field(label: 'Diagnosis', hint: 'Enter diagnosis'),
        SizedBox(height: 12),
        _Field(
          label: 'Treatment notes',
          hint: 'Examination and treatment notes',
          lines: 2,
        ),
        SizedBox(height: 12),
        _Field(label: 'Follow-up date', hint: 'Select date'),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _OutlineButton(label: 'Save')),
            SizedBox(width: 8),
            Expanded(child: _PrimaryButton(label: 'Save + Add prescription')),
          ],
        ),
      ],
    ),
  );
}

class _InventoryPage extends StatelessWidget {
  const _InventoryPage();
  @override
  Widget build(BuildContext context) => _PageFrame(
    title: 'Inventory',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Tabs(labels: ['Stock', 'Low stock', 'Expired', 'Logs']),
        const SizedBox(height: 16),
        const _Stats(
          items: [
            ('Medicines', '5', _teal),
            ('Low stock', '1', Color(0xFFF59E0B)),
            ('Out of stock', '1', Color(0xFFEF4444)),
            ('Expired batches', '0', Color(0xFF3B82F6)),
          ],
        ),
        const SizedBox(height: 18),
        const _Table(
          title: 'Stock overview',
          columns: [
            'Medicine',
            'Category',
            'Stock',
            'Reorder at',
            'Price',
            'Status',
            'Actions',
          ],
          rows: [
            [
              'Amoxicillin 500mg',
              'Antibiotic',
              '15',
              '20',
              'Rs 10.00',
              'Low Stock',
              'View · Edit',
            ],
            [
              'Rabies vaccine',
              'Vaccine',
              '38',
              '10',
              'Rs 250.00',
              'OK',
              'View · Edit',
            ],
            [
              'Vitamin supplement',
              'Supplement',
              '0',
              '10',
              'Rs 120.00',
              'Out of Stock',
              'View · Edit',
            ],
          ],
        ),
      ],
    ),
  );
}

class _ReturnsPage extends StatelessWidget {
  const _ReturnsPage();
  @override
  Widget build(BuildContext context) => _PageFrame(
    title: 'Returns',
    child: LayoutBuilder(
      builder: (context, constraints) {
        const history = _Table(
          title: 'Recent returns',
          columns: ['ID', 'Invoice', 'Medicine', 'Qty', 'Refund', 'Reason'],
          rows: [
            [
              'RET-006',
              'INV-182',
              'Deworming tablet',
              '1',
              'Rs 75.00',
              'Wrong item',
            ],
            [
              'RET-005',
              'INV-176',
              'Vitamin supplement',
              '1',
              'Rs 120.00',
              'Damaged pack',
            ],
          ],
        );
        const form = _ReturnForm();
        return constraints.maxWidth < 900
            ? const Column(children: [history, SizedBox(height: 16), form])
            : const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 11, child: history),
                  SizedBox(width: 18),
                  Expanded(flex: 9, child: form),
                ],
              );
      },
    ),
  );
}

class _ReturnForm extends StatelessWidget {
  const _ReturnForm();
  @override
  Widget build(BuildContext context) => _Panel(
    title: 'New return',
    child: Column(
      children: const [
        _Select(label: 'Invoice', value: 'Select invoice'),
        SizedBox(height: 12),
        _Select(label: 'Medicine', value: 'Select medicine'),
        SizedBox(height: 12),
        _Field(label: 'Quantity', hint: '1'),
        SizedBox(height: 12),
        _Field(label: 'Refund amount', hint: 'Rs 0.00'),
        SizedBox(height: 12),
        _Field(label: 'Reason', hint: 'Reason for return'),
        SizedBox(height: 14),
        _PrimaryButton(label: 'Process refund', icon: Icons.currency_exchange),
      ],
    ),
  );
}

class _PaymentsPage extends StatelessWidget {
  const _PaymentsPage();
  @override
  Widget build(BuildContext context) => _PageFrame(
    title: 'Payments',
    child: Column(
      children: [
        const _Stats(
          items: [
            ('Cash · 18 transactions', 'Rs 24,500', _teal),
            ('Card · 12 transactions', 'Rs 18,200', Color(0xFF3B82F6)),
            ('Online · 9 transactions', 'Rs 12,650', Color(0xFFF97360)),
          ],
        ),
        const SizedBox(height: 18),
        const _Table(
          title: 'Recent transactions',
          columns: ['ID', 'Invoice', 'Date', 'Amount', 'Method', 'Actions'],
          rows: [
            ['PAY-044', 'INV-001', '05 Oct 2026', 'Rs 500.00', 'Cash', 'View'],
            [
              'PAY-043',
              'INV-002',
              '04 Oct 2026',
              'Rs 1,250.00',
              'Card',
              'View',
            ],
            [
              'PAY-042',
              'INV-003',
              '03 Oct 2026',
              'Rs 750.00',
              'Online',
              'View',
            ],
          ],
        ),
      ],
    ),
  );
}

class _ReportsPage extends StatelessWidget {
  const _ReportsPage();
  @override
  Widget build(BuildContext context) => _PageFrame(
    title: 'Reports',
    action: const Wrap(
      spacing: 8,
      children: [
        _OutlineButton(
          label: 'Export PDF',
          icon: Icons.picture_as_pdf_outlined,
        ),
        _OutlineButton(label: 'Export Excel', icon: Icons.table_view_outlined),
      ],
    ),
    child: Column(
      children: [
        _Panel(
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.end,
            children: const [
              SizedBox(
                width: 190,
                child: _Field(label: 'From', hint: '01 Oct 2026'),
              ),
              SizedBox(
                width: 190,
                child: _Field(label: 'To', hint: '22 Oct 2026'),
              ),
              _PrimaryButton(label: 'Apply filter'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const _SalesChart(),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            const medicines = _Table(
              title: 'Top medicines',
              columns: ['Medicine', 'Units sold', 'Revenue'],
              rows: [
                ['Amoxicillin 500mg', '50', 'Rs 5,000'],
                ['Rabies vaccine', '30', 'Rs 7,500'],
                ['Deworming tablet', '20', 'Rs 1,500'],
              ],
            );
            const customers = _Table(
              title: 'Top customers',
              columns: ['Customer', 'Visits', 'Sales'],
              rows: [
                ['Sara Krugs', '8', 'Rs 12,450'],
                ['Ali Raza', '6', 'Rs 9,200'],
                ['Hina Khan', '4', 'Rs 6,850'],
              ],
            );
            return constraints.maxWidth < 750
                ? const Column(
                    children: [medicines, SizedBox(height: 16), customers],
                  )
                : const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: medicines),
                      SizedBox(width: 16),
                      Expanded(child: customers),
                    ],
                  );
          },
        ),
      ],
    ),
  );
}

class _NewPurchasePage extends StatelessWidget {
  const _NewPurchasePage();
  @override
  Widget build(BuildContext context) => _PageFrame(
    title: 'New purchase',
    child: Column(
      children: [
        _Panel(
          title: 'Purchase details',
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: const [
              _Select(label: 'Supplier', value: 'Select supplier'),
              _Field(label: 'Invoice no', hint: 'e.g. SUP-INV-1042'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            const items = _Table(
              title: 'Items',
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
                  'AMX-24101',
                  '100',
                  'Rs 8.00',
                  '12 Dec 2027',
                  'Rs 800.00',
                ],
                [
                  'Rabies vaccine',
                  'RAB-24122',
                  '20',
                  'Rs 210.00',
                  '28 Oct 2027',
                  'Rs 4,200.00',
                ],
              ],
            );
            const summary = _PurchaseSummary();
            return constraints.maxWidth < 900
                ? const Column(children: [items, SizedBox(height: 16), summary])
                : const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 7, child: items),
                      SizedBox(width: 16),
                      Expanded(flex: 3, child: summary),
                    ],
                  );
          },
        ),
      ],
    ),
  );
}

class _PurchaseSummary extends StatelessWidget {
  const _PurchaseSummary();
  @override
  Widget build(BuildContext context) => _Panel(
    title: 'Summary',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        _PriceLine(label: 'Subtotal', amount: 5000),
        SizedBox(height: 10),
        _PriceLine(label: 'Discount', amount: 0),
        Divider(height: 28, color: _line),
        _PriceLine(label: 'Total', amount: 5000, large: true, color: _teal),
        SizedBox(height: 14),
        Text(
          'Stock and batches update automatically when saved',
          style: TextStyle(color: _muted),
        ),
        SizedBox(height: 16),
        _PrimaryButton(label: 'Save purchase'),
      ],
    ),
  );
}

class _SettingsPage extends StatefulWidget {
  const _SettingsPage();
  @override
  State<_SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<_SettingsPage> {
  String tab = 'Profile';
  static const tabs = [
    'Profile',
    'Users',
    'Roles',
    'Clinic info',
    'Notifications',
    'Backup',
  ];
  @override
  Widget build(BuildContext context) => _PageFrame(
    title: 'Settings',
    child: LayoutBuilder(
      builder: (context, constraints) {
        final tabList = _Panel(
          child: Column(
            children: [
              for (final value in tabs)
                ListTile(
                  minTileHeight: 44,
                  selected: value == tab,
                  selectedTileColor: const Color(0xFFCCFBF1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  title: Text(
                    value,
                    style: TextStyle(color: value == tab ? _teal : _muted),
                  ),
                  onTap: () => setState(() => tab = value),
                ),
            ],
          ),
        );
        final form = _Panel(
          title: tab,
          child: Column(
            children: [
              const _Field(label: 'Full name', hint: 'Dr. Ahmed'),
              const SizedBox(height: 14),
              const _Field(label: 'Username', hint: 'ahmed.vet'),
              const SizedBox(height: 14),
              const _Field(label: 'Email', hint: 'ahmed@vetnalay.pk'),
              const SizedBox(height: 14),
              const _Field(label: 'Phone', hint: '+92 300 1234567'),
              const SizedBox(height: 14),
              const _Select(label: 'Role', value: 'Veterinarian'),
              const SizedBox(height: 18),
              const Align(
                alignment: Alignment.centerRight,
                child: _PrimaryButton(label: 'Save changes'),
              ),
            ],
          ),
        );
        return constraints.maxWidth < 750
            ? Column(children: [tabList, const SizedBox(height: 14), form])
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 210, child: tabList),
                  const SizedBox(width: 18),
                  Expanded(child: form),
                ],
              );
      },
    ),
  );
}

class _DataPage extends StatelessWidget {
  const _DataPage({
    required this.title,
    required this.columns,
    required this.rows,
    this.action,
    this.chips = const [],
    this.footer,
    this.onAction,
    this.onRowTap,
  });
  final String title;
  final List<String> columns;
  final List<List<String>> rows;
  final String? action;
  final List<String> chips;
  final String? footer;
  final VoidCallback? onAction;
  final ValueChanged<List<String>>? onRowTap;
  @override
  Widget build(BuildContext context) => _PageFrame(
    title: title,
    action: action == null
        ? null
        : _PrimaryButton(label: action!, icon: Icons.add, onPressed: onAction),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.sizeOf(context).width < 650 ? 250 : 300,
              child: _Search(hint: 'Search $title...'),
            ),
            const _OutlineButton(
              label: 'All status',
              icon: Icons.filter_list_outlined,
            ),
            for (final chip in chips) _Chip(label: chip),
          ],
        ),
        const SizedBox(height: 16),
        _Table(
          columns: columns,
          rows: rows,
          footer: footer,
          onRowTap: onRowTap,
          loading: false,
        ),
      ],
    ),
  );
}

class _PageFrame extends StatelessWidget {
  const _PageFrame({
    required this.title,
    required this.child,
    this.subtitle,
    this.action,
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
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: _ink,
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(subtitle!, style: const TextStyle(color: _muted)),
                      ],
                    ],
                  ),
                ),
                ?action,
              ],
            ),
            const SizedBox(height: 22),
            child,
          ],
        ),
      );
    },
  );
}

class _Panel extends StatelessWidget {
  const _Panel({
    required this.child,
    this.title,
    this.trailing,
    this.padding = const EdgeInsets.all(20),
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
      border: Border.all(color: _line),
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
                    color: _ink,
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

class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    required this.hint,
    this.obscure = false,
    this.suffix,
    this.lines = 1,
    this.errorText,
    this.enabled = true,
    this.controller,
  });
  final String label;
  final String hint;
  final bool obscure;
  final Widget? suffix;
  final int lines;
  final String? errorText;
  final bool enabled;
  final TextEditingController? controller;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(color: _ink, fontWeight: FontWeight.w500),
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
            hintStyle: const TextStyle(color: _muted),
            suffixIcon: suffix,
            errorText: errorText,
            errorStyle: const TextStyle(color: Color(0xFFB91C1C), fontSize: 12),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: _teal, width: 2),
            ),
          ),
        ),
      ),
    ],
  );
}

class _Search extends StatelessWidget {
  const _Search({required this.hint});
  final String hint;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 44,
    child: TextField(
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search, color: _muted),
        hintText: hint,
        hintStyle: const TextStyle(color: _muted),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _teal, width: 2),
        ),
      ),
    ),
  );
}

class _Select extends StatelessWidget {
  const _Select({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: MediaQuery.sizeOf(context).width >= 900 ? 220 : 260,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: _ink, fontWeight: FontWeight.w500),
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
              const Icon(Icons.keyboard_arrow_down, color: _muted),
            ],
          ),
        ),
      ],
    ),
  );
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    this.icon,
    this.onPressed,
    this.isLoading = false,
  });
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 44,
    child: FilledButton.icon(
      onPressed: isLoading ? null : onPressed ?? () {},
      icon: isLoading
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : icon == null
          ? const SizedBox.shrink()
          : Icon(icon, size: 18),
      label: Text(
        isLoading ? 'Saving...' : label,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      style: FilledButton.styleFrom(
        backgroundColor: _teal,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
  );
}

class _OutlineButton extends StatelessWidget {
  const _OutlineButton({required this.label, this.icon});
  final String label;
  final IconData? icon;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 44,
    child: OutlinedButton.icon(
      onPressed: () {},
      icon: icon == null ? const SizedBox.shrink() : Icon(icon, size: 18),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      style: OutlinedButton.styleFrom(
        foregroundColor: _ink,
        side: const BorderSide(color: _line),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
  );
}

class _PriceLine extends StatelessWidget {
  const _PriceLine({
    required this.label,
    required this.amount,
    this.large = false,
    this.color,
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
            color: large ? _ink : _muted,
            fontSize: large ? 18 : 14,
            fontWeight: large ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ),
      Text(
        '${amount < 0 ? '- ' : ''}Rs ${amount.abs().toStringAsFixed(2)}',
        style: TextStyle(
          color: color ?? _ink,
          fontSize: large ? 22 : 14,
          fontWeight: FontWeight.w700,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
    ],
  );
}

class _Table extends StatelessWidget {
  const _Table({
    required this.columns,
    required this.rows,
    this.title,
    this.footer,
    this.onRowTap,
    this.loading = false,
  });
  final String? title;
  final List<String> columns;
  final List<List<String>> rows;
  final String? footer;
  final ValueChanged<List<String>>? onRowTap;
  final bool loading;
  @override
  Widget build(BuildContext context) => _Panel(
    title: title,
    padding: EdgeInsets.zero,
    child: Column(
      children: [
        if (loading)
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                for (var row = 0; row < 4; row++)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        for (var column = 0; column < columns.length; column++)
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Container(
                                height: 16,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE2E8F0),
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
          )
        else if (rows.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 20),
            child: Column(
              children: const [
                Icon(Icons.inbox_outlined, color: _muted, size: 28),
                SizedBox(height: 10),
                Text(
                  'No records found',
                  style: TextStyle(color: _ink, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 4),
                Text(
                  'Try changing your search or filters.',
                  style: TextStyle(color: _muted),
                ),
              ],
            ),
          )
        else
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: const WidgetStatePropertyAll(Color(0xFFF1F5F9)),
              headingRowHeight: 44,
              dataRowMinHeight: 48,
              dataRowMaxHeight: 56,
              horizontalMargin: 20,
              columnSpacing: 28,
              columns: [
                for (final column in columns)
                  DataColumn(
                    label: Text(
                      column.toUpperCase(),
                      style: const TextStyle(
                        color: _muted,
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
                      for (var i = 0; i < columns.length; i++)
                        DataCell(_TableCell(value: row[i], column: columns[i])),
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
              child: Text(footer!, style: const TextStyle(color: _muted)),
            ),
          ),
      ],
    ),
  );
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
      return _Status(label: value);
    }
    if (column == 'Actions') {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: 'View',
            onPressed: () {},
            icon: const Icon(Icons.visibility_outlined, size: 18, color: _teal),
          ),
          IconButton(
            tooltip: 'Edit',
            onPressed: () {},
            icon: const Icon(Icons.edit_outlined, size: 18, color: _muted),
          ),
        ],
      );
    }
    return Text(
      value,
      style: TextStyle(
        color: value.startsWith('Rs ') ? _ink : _muted,
        fontWeight: value.startsWith('Rs ') ? FontWeight.w600 : FontWeight.w400,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
    );
  }
}

class _Status extends StatelessWidget {
  const _Status({required this.label});
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

class _Chip extends StatelessWidget {
  const _Chip({required this.label});
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

class _Stats extends StatelessWidget {
  const _Stats({required this.items});
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
          childAspectRatio: 2.3,
        ),
        itemBuilder: (context, i) => _Panel(
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
                      color: items[i].$3,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      items[i].$1,
                      style: const TextStyle(color: _muted),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                items[i].$2,
                style: const TextStyle(
                  color: _ink,
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

class _Tabs extends StatelessWidget {
  const _Tabs({required this.labels});
  final List<String> labels;
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
                backgroundColor: index == 0
                    ? const Color(0xFFCCFBF1)
                    : Colors.white,
                foregroundColor: index == 0 ? _teal : _muted,
                side: BorderSide(color: index == 0 ? _teal : _line),
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

class _SalesChart extends StatelessWidget {
  const _SalesChart();
  static const values = [40.0, 60.0, 49.0, 77.0, 65.0, 91.0, 58.0];
  @override
  Widget build(BuildContext context) => _Panel(
    title: 'Sales overview',
    child: SizedBox(
      height: 290,
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var index = 0; index < values.length; index++)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: FractionallySizedBox(
                        heightFactor: values[index] / 100,
                        alignment: Alignment.bottomCenter,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: index == values.length - 1
                                ? _teal
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
              Text('Mon', style: TextStyle(color: _muted)),
              Text('Tue', style: TextStyle(color: _muted)),
              Text('Wed', style: TextStyle(color: _muted)),
              Text('Thu', style: TextStyle(color: _muted)),
              Text('Fri', style: TextStyle(color: _muted)),
              Text('Sat', style: TextStyle(color: _muted)),
              Text('Sun', style: TextStyle(color: _muted)),
            ],
          ),
        ],
      ),
    ),
  );
}

class _Logo extends StatelessWidget {
  const _Logo();
  @override
  Widget build(BuildContext context) => Container(
    width: 48,
    height: 48,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: _teal,
      borderRadius: BorderRadius.circular(12),
    ),
    child: const Text(
      'V',
      style: TextStyle(
        color: Colors.white,
        fontSize: 28,
        fontWeight: FontWeight.w800,
      ),
    ),
  );
}

void _notify(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
