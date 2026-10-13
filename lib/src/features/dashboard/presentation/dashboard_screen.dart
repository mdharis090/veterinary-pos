import 'package:flutter/material.dart';

import '../widgets/dashboard_sidebar.dart';
import '../widgets/dashboard_summary_card.dart';
import '../widgets/dashboard_table_panel.dart';
import '../widgets/sales_trend_panel.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  static const _navItems = [
    'Dashboard',
    'Patients',
    'Owners',
    'Consultations',
    'Prescriptions',
    'Medicines',
    'Inventory',
    'Batches',
    'Suppliers',
    'Purchases',
    'POS Billing',
    'Sales',
    'Returns',
    'Payments',
    'Reports',
    'Settings',
  ];

  static const _navIcons = [
    Icons.grid_view_rounded,
    Icons.pets_outlined,
    Icons.people_outline,
    Icons.chat_bubble_outline,
    Icons.description_outlined,
    Icons.medication_outlined,
    Icons.inventory_2_outlined,
    Icons.layers_outlined,
    Icons.local_shipping_outlined,
    Icons.shopping_bag_outlined,
    Icons.credit_card_outlined,
    Icons.receipt_long_outlined,
    Icons.keyboard_return,
    Icons.payments_outlined,
    Icons.bar_chart_outlined,
    Icons.settings_outlined,
  ];

  String _selectedItem = 'Dashboard';

  void _selectItem(String item) {
    setState(() => _selectedItem = item);
    if (item != 'Dashboard') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$item is coming soon'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 760;

        return Scaffold(
          drawer: isWide
              ? null
              : Drawer(
                  child: SafeArea(
                    child: DashboardSidebar(
                      items: _navItems,
                      icons: _navIcons,
                      selectedItem: _selectedItem,
                      onSelected: (item) {
                        Navigator.of(context).pop();
                        _selectItem(item);
                      },
                    ),
                  ),
                ),
          body: SafeArea(
            child: Row(
              children: [
                if (isWide)
                  SizedBox(
                    width: constraints.maxWidth >= 1100 ? 205 : 150,
                    child: DashboardSidebar(
                      items: _navItems,
                      icons: _navIcons,
                      selectedItem: _selectedItem,
                      onSelected: _selectItem,
                    ),
                  ),
                Expanded(
                  child: Column(
                    children: [
                      _DashboardTopBar(isWide: isWide),
                      Expanded(
                        child: _DashboardContent(
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DashboardTopBar extends StatelessWidget {
  const _DashboardTopBar({required this.isWide});

  final bool isWide;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      padding: EdgeInsets.symmetric(horizontal: isWide ? 20 : 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE8EDF0))),
      ),
      child: Row(
        children: [
          if (!isWide) ...[
            Builder(
              builder: (context) => IconButton(
                onPressed: () => Scaffold.of(context).openDrawer(),
                icon: const Icon(Icons.menu_rounded),
                tooltip: 'Open navigation',
                visualDensity: VisualDensity.compact,
              ),
            ),
            const SizedBox(width: 4),
          ],
          if (isWide)
            SizedBox(
              width: 250,
              height: 34,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search patients, owners, invoices...',
                  hintStyle: const TextStyle(fontSize: 11),
                  prefixIcon: const Icon(Icons.search, size: 17),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.zero,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                    borderSide: const BorderSide(color: Color(0xFFDCE3E8)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                    borderSide: const BorderSide(color: Color(0xFFDCE3E8)),
                  ),
                ),
              ),
            )
          else
            const Expanded(
              child: Text(
                'Vetnaly',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
              ),
            ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            tooltip: 'Notifications',
            icon: const Icon(Icons.notifications_none, size: 20),
            visualDensity: VisualDensity.compact,
          ),
          const SizedBox(width: 8),
          const CircleAvatar(
            radius: 12,
            backgroundColor: Color(0xFF128078),
            child: Text(
              'DA',
              style: TextStyle(color: Colors.white, fontSize: 9),
            ),
          ),
          if (isWide) ...[
            const SizedBox(width: 9),
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dr. Ahmed',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
                ),
                Text(
                  'Veterinarian',
                  style: TextStyle(fontSize: 9, color: Color(0xFF78879A)),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 600;
        final isNarrow = constraints.maxWidth < 600;
        final horizontalPadding = isCompact ? 14.0 : 20.0;

        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(horizontalPadding, 18, horizontalPadding, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Dashboard',
                      style: TextStyle(
                        color: Color(0xFF17283F),
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(
                    _formattedToday(),
                    style: const TextStyle(
                      color: Color(0xFF738198),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              GridView.count(
                crossAxisCount: isCompact ? 2 : 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: isCompact ? 1.9 : 1.85,
                children: const [
                  DashboardSummaryCard(
                    title: 'Owners',
                    value: '5',
                    accent: Color(0xFF21A69A),
                  ),
                  DashboardSummaryCard(
                    title: 'Animals',
                    value: '5',
                    accent: Color(0xFFFF6E63),
                  ),
                  DashboardSummaryCard(
                    title: 'Medicines',
                    value: '5',
                    accent: Color(0xFFF4A623),
                  ),
                  DashboardSummaryCard(
                    title: 'Revenue',
                    value: '1,350',
                    accent: Color(0xFF4285F4),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (isNarrow) ...[
                const SalesTrendPanel(),
                const SizedBox(height: 12),
                const DashboardTablePanel(
                  title: 'Top medicines',
                  entries: [
                    DashboardTableEntry('Amoxicillin', '50'),
                    DashboardTableEntry('Rabies Vax', '30'),
                    DashboardTableEntry('Deworming', '20'),
                  ],
                ),
                const SizedBox(height: 12),
                const DashboardTablePanel(
                  title: 'Low stock alerts',
                  entries: [
                    DashboardTableEntry('Amoxicillin', '15 left', badge: true),
                    DashboardTableEntry('Rabies Vax', '8 left', badge: true),
                  ],
                ),
                const SizedBox(height: 12),
                const DashboardTablePanel(
                  title: 'Upcoming visits',
                  entries: [
                    DashboardTableEntry('Nyxie', '15 Oct'),
                    DashboardTableEntry('Tommy', '18 Oct'),
                  ],
                ),
              ] else ...[
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: SalesTrendPanel()),
                    SizedBox(width: 12),
                    Expanded(
                      child: DashboardTablePanel(
                        title: 'Top medicines',
                        entries: [
                          DashboardTableEntry('Amoxicillin', '50'),
                          DashboardTableEntry('Rabies Vax', '30'),
                          DashboardTableEntry('Deworming', '20'),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: DashboardTablePanel(
                        title: 'Low stock alerts',
                        entries: [
                          DashboardTableEntry('Amoxicillin', '15 left', badge: true),
                          DashboardTableEntry('Rabies Vax', '8 left', badge: true),
                        ],
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: DashboardTablePanel(
                        title: 'Upcoming visits',
                        entries: [
                          DashboardTableEntry('Nyxie', '15 Oct'),
                          DashboardTableEntry('Tommy', '18 Oct'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

String _formattedToday() {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  final today = DateTime.now();
  return '${today.day} ${months[today.month - 1]} ${today.year}';
}
