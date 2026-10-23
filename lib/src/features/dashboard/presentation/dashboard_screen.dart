import 'package:flutter/material.dart';
import 'package:veterinary_pos/src/features/auth/presentation/login_screen.dart';

import '../../../core/routes/app_route_screens.dart';
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
  static const _navigation = <(String, IconData)>[
    ('Dashboard', Icons.grid_view_rounded),
    ('Patients', Icons.pets_outlined),
    ('Owners', Icons.people_outline),
    ('Consultations', Icons.chat_bubble_outline),
    ('Prescriptions', Icons.description_outlined),
    ('Medicines', Icons.medication_outlined),
    ('Inventory', Icons.inventory_2_outlined),
    ('Batches', Icons.layers_outlined),
    ('Suppliers', Icons.local_shipping_outlined),
    ('Purchases', Icons.shopping_bag_outlined),
    ('POS Billing', Icons.point_of_sale_outlined),
    ('Sales', Icons.receipt_long_outlined),
    ('Returns', Icons.keyboard_return),
    ('Payments', Icons.payments_outlined),
    ('Reports', Icons.bar_chart_outlined),
    ('Settings', Icons.settings_outlined),
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

  Widget _buildScreen() => _selectedItem == 'Dashboard'
      ? _DashboardContent(onNavigate: _selectItem)
      : AppRouteScreens.forDashboardSection(
          _selectedItem,
          onNavigate: _selectItem,
        );

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 760;
        final mobile = constraints.maxWidth < 650;
        if (_signedOut) {
          return LoginScreen(onSignIn: _signIn);
        }

        final navItems = _navigation.map((item) => item.$1).toList();
        final navIcons = _navigation.map((item) => item.$2).toList();

        return Scaffold(
          backgroundColor: const Color(0xFFF4F7F6),
          drawer: wide
              ? null
              : Drawer(
                  child: SafeArea(
                    child: DashboardSidebar(
                      items: navItems,
                      icons: navIcons,
                      selectedItem: _selectedItem,
                      onSelected: (item) {
                        Navigator.of(context).pop();
                        _selectItem(item);
                      },
                      onSignOut: () {
                        Navigator.of(context).pop();
                        setState(() => _signedOut = true);
                      },
                    ),
                  ),
                ),
          onDrawerChanged: (isOpen) => setState(() => _drawerOpen = isOpen),
          body: SafeArea(
            child: Row(
              children: [
                if (wide)
                  SizedBox(
                    width: 232,
                    child: DashboardSidebar(
                      items: navItems,
                      icons: navIcons,
                      selectedItem: _selectedItem,
                      onSelected: _selectItem,
                      onSignOut: () => setState(() => _signedOut = true),
                    ),
                  ),
                Expanded(
                  child: Column(
                    children: [
                      _TopBar(
                        mobile: mobile,
                        title: _selectedItem == 'Dashboard'
                            ? 'Vetnalay'
                            : _selectedItem,
                      ),
                      Expanded(child: _buildScreen()),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: mobile && !_drawerOpen
              ? Builder(
                  builder: (scaffoldContext) => _MobileNavigation(
                    selected: _selectedItem,
                    onSelected: (item) {
                      if (item == 'More') {
                        Scaffold.of(scaffoldContext).openDrawer();
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

class _TopBar extends StatelessWidget {
  const _TopBar({required this.mobile, required this.title});

  final bool mobile;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: EdgeInsets.symmetric(horizontal: mobile ? 10 : 24),
      decoration: BoxDecoration(
        color: mobile ? const Color(0xFF134E4A) : Colors.white,
        border: const Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Row(
        children: [
          if (mobile) ...[
            Builder(
              builder: (context) => IconButton(
                onPressed: () => Scaffold.of(context).openDrawer(),
                icon: const Icon(Icons.menu_rounded),
                tooltip: 'Open navigation',
                color: Colors.white,
              ),
            ),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
            const _UserAvatar(light: true),
          ] else ...[
            const Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(width: 420, height: 44, child: _GlobalSearch()),
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
            const _UserAvatar(),
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

class _GlobalSearch extends StatelessWidget {
  const _GlobalSearch();

  @override
  Widget build(BuildContext context) => TextField(
    decoration: InputDecoration(
      hintText: 'Search patients, owners, invoices...',
      hintStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
      prefixIcon: const Icon(Icons.search, size: 20, color: Color(0xFF64748B)),
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding: EdgeInsets.zero,
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
        borderSide: const BorderSide(color: Color(0xFF0F766E), width: 2),
      ),
    ),
  );
}

class _UserAvatar extends StatelessWidget {
  const _UserAvatar({this.light = false});

  final bool light;

  @override
  Widget build(BuildContext context) => CircleAvatar(
    radius: 18,
    backgroundColor: const Color(0xFFCCFBF1),
    child: Text(
      'DA',
      style: TextStyle(
        color: light ? const Color(0xFF134E4A) : const Color(0xFF0F766E),
        fontSize: 12,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
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
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final compact = constraints.maxWidth < 900;
      final mobile = constraints.maxWidth < 650;
      final padding = mobile ? 16.0 : 32.0;

      return SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(padding, 24, padding, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Dashboard',
                    style: TextStyle(
                      color: Color(0xFF0F172A),
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  _formattedToday(),
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 14,
                  ),
                ),
                if (!compact) ...[
                  const SizedBox(width: 16),
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
                ],
              ],
            ),
            const SizedBox(height: 18),
            GridView.count(
              crossAxisCount: compact ? 2 : 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: mobile ? 1.55 : 2.15,
              children: const [
                DashboardSummaryCard(
                  title: 'Owners',
                  value: '5',
                  accent: Color(0xFF0F766E),
                ),
                DashboardSummaryCard(
                  title: 'Animals',
                  value: '5',
                  accent: Color(0xFFF97360),
                ),
                DashboardSummaryCard(
                  title: 'Medicines',
                  value: '5',
                  accent: Color(0xFFF59E0B),
                ),
                DashboardSummaryCard(
                  title: 'Revenue',
                  value: '1,350',
                  accent: Color(0xFF3B82F6),
                ),
              ],
            ),
            if (mobile) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => onNavigate('POS Billing'),
                      icon: const Icon(Icons.point_of_sale_outlined, size: 18),
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
                      onPressed: () => onNavigate('Patients'),
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
            if (compact) ...[
              const SalesTrendPanel(),
              const SizedBox(height: 16),
              const DashboardTablePanel(
                title: 'Top medicines',
                entries: [
                  DashboardTableEntry('Amoxicillin', '50'),
                  DashboardTableEntry('Rabies Vax', '30'),
                  DashboardTableEntry('Deworming', '20'),
                ],
              ),
              const SizedBox(height: 16),
              const DashboardTablePanel(
                title: 'Low stock alerts',
                entries: [
                  DashboardTableEntry('Amoxicillin', '15 left', badge: true),
                  DashboardTableEntry('Rabies Vax', '8 left', badge: true),
                ],
              ),
              const SizedBox(height: 16),
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
                  SizedBox(width: 16),
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
              const SizedBox(height: 16),
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
                  SizedBox(width: 16),
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
