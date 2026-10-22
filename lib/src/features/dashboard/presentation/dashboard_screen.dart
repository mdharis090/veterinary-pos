import 'package:flutter/material.dart';

import 'clinic_pages.dart';
import '../../patients/presentation/patient_detail_screen.dart';
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
  bool _signedOut = false;
  bool _drawerOpen = false;

  void _selectItem(String item) {
    setState(() => _selectedItem = item);
  }

  void _signIn() {
    setState(() {
      _signedOut = false;
      _selectedItem = 'Dashboard';
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 760;
        final isMobile = constraints.maxWidth < 650;

        if (_signedOut) {
          return LoginScreen(onSignIn: _signIn);
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF4F7F6),
          drawer: isWide
              ? null
              : Drawer(
                  child: SafeArea(
                    child: DashboardSidebar(
                      items: _navItems,
                      icons: _navIcons,
                      selectedItem: _selectedItem,
                      onSignOut: () {
                        Navigator.of(context).pop();
                        setState(() => _signedOut = true);
                      },
                      onSelected: (item) {
                        Navigator.of(context).pop();
                        _selectItem(item);
                      },
                    ),
                  ),
                ),
          onDrawerChanged: (isOpen) => setState(() => _drawerOpen = isOpen),
          body: SafeArea(
            child: Row(
              children: [
                if (isWide)
                  SizedBox(
                    width: 232,
                    child: DashboardSidebar(
                      items: _navItems,
                      icons: _navIcons,
                      selectedItem: _selectedItem,
                      onSignOut: () => setState(() => _signedOut = true),
                      onSelected: _selectItem,
                    ),
                  ),
                Expanded(
                  child: Column(
                    children: [
                      _DashboardTopBar(
                        isWide: isWide,
                        isMobile: isMobile,
                        title: _selectedItem == 'Dashboard'
                            ? 'Vetnalay'
                            : _selectedItem,
                      ),
                      Expanded(
                        child:
                            _selectedItem == 'Patients' ||
                                _selectedItem == 'Patient profile'
                            ? PatientDetailScreen(
                                onNavigate: (page) => _selectItem(page),
                              )
                            : _selectedItem == 'Dashboard'
                            ? _DashboardContent(onNavigate: _selectItem)
                            : ClinicPage(
                                page: _selectedItem == 'Patients list'
                                    ? 'Patients'
                                    : _selectedItem,
                                onNavigate: _selectItem,
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: isMobile && !_drawerOpen
              ? Builder(
                  builder: (context) => _MobileNavigation(
                    selected: _selectedItem,
                    onSelected: (item) {
                      if (item == 'More') {
                        Scaffold.of(context).openDrawer();
                      } else {
                        _selectItem(item);
                      }
                    },
                  ),
                )
              : null,
        );
      },
    );
  }
}

class _DashboardTopBar extends StatelessWidget {
  const _DashboardTopBar({
    required this.isWide,
    required this.isMobile,
    required this.title,
  });

  final bool isWide;
  final bool isMobile;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isMobile ? 58 : 64,
      padding: EdgeInsets.symmetric(horizontal: isWide ? 20 : 12),
      decoration: BoxDecoration(
        color: isMobile ? const Color(0xFF134E4A) : Colors.white,
        border: const Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Row(
        children: [
          if (isMobile) ...[
            Builder(
              builder: (context) => IconButton(
                onPressed: () => Scaffold.of(context).openDrawer(),
                icon: const Icon(Icons.menu_rounded),
                tooltip: 'Open navigation',
                visualDensity: VisualDensity.compact,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ),
            IconButton(
              onPressed: () {},
              tooltip: 'Notifications',
              icon: const Icon(Icons.notifications_none, color: Colors.white),
            ),
            const CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFFCCFBF1),
              child: Text(
                'DA',
                style: TextStyle(
                  color: Color(0xFF134E4A),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ] else ...[
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: SizedBox(
                    height: 44,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search patients, owners, invoices...',
                        hintStyle: const TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 14,
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          size: 20,
                          color: Color(0xFF64748B),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF8FAFC),
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color(0xFFCBD5E1),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color(0xFFCBD5E1),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color(0xFF0F766E),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () {},
              tooltip: 'Notifications',
              icon: const Icon(
                Icons.notifications_none,
                color: Color(0xFF64748B),
              ),
            ),
            const CircleAvatar(
              radius: 18,
              backgroundColor: Color(0xFFCCFBF1),
              child: Text(
                'DA',
                style: TextStyle(
                  color: Color(0xFF0F766E),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dr. Ahmed',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F172A),
                  ),
                ),
                Text(
                  'Veterinarian',
                  style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _MobileNavigation extends StatelessWidget {
  const _MobileNavigation({required this.selected, required this.onSelected});
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) => NavigationBar(
    height: 68,
    selectedIndex: switch (selected) {
      'Patients' || 'Patient profile' || 'Patients list' => 1,
      'POS Billing' => 2,
      'Reports' => 3,
      _ => 0,
    },
    onDestinationSelected: (index) => onSelected(
      ['Dashboard', 'Patients', 'POS Billing', 'Reports', 'More'][index],
    ),
    destinations: const [
      NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
      NavigationDestination(icon: Icon(Icons.pets_outlined), label: 'Patients'),
      NavigationDestination(
        icon: Icon(Icons.point_of_sale_outlined),
        label: 'POS',
      ),
      NavigationDestination(
        icon: Icon(Icons.bar_chart_outlined),
        label: 'Reports',
      ),
      NavigationDestination(icon: Icon(Icons.menu), label: 'More'),
    ],
  );
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({required this.onNavigate});

  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 900;
        final padding = isCompact ? 16.0 : 32.0;

        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(padding, 18, padding, 24),
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
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(
                    _formattedToday(),
                    style: const TextStyle(
                      color: Color(0xFF738198),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              if (!isCompact)
                FilledButton.icon(
                  onPressed: () => onNavigate('POS Billing'),
                  icon: const Icon(Icons.point_of_sale_outlined, size: 18),
                  label: const Text('New sale'),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF0F766E),
                    minimumSize: const Size(0, 44),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
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
              if (isCompact) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () => onNavigate('POS Billing'),
                        icon: const Icon(
                          Icons.point_of_sale_outlined,
                          size: 18,
                        ),
                        label: const Text('New sale'),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF0F766E),
                          minimumSize: const Size(0, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => onNavigate('Patients list'),
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Add animal'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF0F766E),
                          minimumSize: const Size(0, 48),
                          side: const BorderSide(color: Color(0xFF0F766E)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 16),
              if (isCompact) ...[
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
                          DashboardTableEntry(
                            'Amoxicillin',
                            '15 left',
                            badge: true,
                          ),
                          DashboardTableEntry(
                            'Rabies Vax',
                            '8 left',
                            badge: true,
                          ),
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
