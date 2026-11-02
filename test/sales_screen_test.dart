import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:veterinary_pos/src/features/sales/data/sales_api.dart';
import 'package:veterinary_pos/src/features/sales/presentation/sales_screen.dart';

class _FakeSalesApi extends SalesApi {
  _FakeSalesApi(this.sales);

  final List<Map<String, dynamic>> sales;

  @override
  Future<List<Map<String, dynamic>>> list() async => sales;
}

void main() {
  final sales = [
    {
      'sal_invoice_no': 'INV-001',
      'sal_sale_date': '2026-10-30T10:00:00Z',
      'owner_name': 'Amina Khan',
      'animal_name': 'Milo',
      'sal_total': 1200,
      'sal_payment_status': 'Paid',
    },
    {
      'sal_invoice_no': 'INV-002',
      'sal_sale_date': '2026-10-31T12:30:00Z',
      'owner_name': 'Bilal Ahmed',
      'animal_name': 'Luna',
      'sal_total': 800,
      'sal_payment_status': 'Pending',
    },
  ];

  Widget buildPage({ValueChanged<String>? onNavigate}) => MaterialApp(
    home: Scaffold(
      body: SalesPage(salesApi: _FakeSalesApi(sales), onNavigate: onNavigate),
    ),
  );

  testWidgets('search narrows sales and can be cleared', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildPage());
    await tester.pumpAndSettle();
    expect(find.text('INV-001'), findsOneWidget);
    expect(find.text('INV-002'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Amina');
    await tester.pumpAndSettle();

    expect(find.text('INV-001'), findsOneWidget);
    expect(find.text('INV-002'), findsNothing);

    await tester.enterText(find.byType(TextField), 'no match');
    await tester.pumpAndSettle();
    expect(find.text('No matching sales'), findsOneWidget);

    await tester.tap(find.text('Clear filters'));
    await tester.pumpAndSettle();
    expect(find.text('INV-001'), findsOneWidget);
    expect(find.text('INV-002'), findsOneWidget);
  });

  testWidgets('new sale action opens POS billing', (tester) async {
    String? destination;
    await tester.pumpWidget(
      buildPage(onNavigate: (section) => destination = section),
    );

    await tester.tap(find.text('New sale'));

    expect(destination, 'POS Billing');
  });
}
