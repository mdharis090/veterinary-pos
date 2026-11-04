import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:veterinary_pos/main.dart';
import 'package:veterinary_pos/src/core/network/api_client.dart';
import 'package:veterinary_pos/src/core/routes/app_routes_named.dart';
import 'package:veterinary_pos/src/features/billing/presentation/pos_billing_screen.dart';
import 'package:veterinary_pos/src/features/auth/presentation/login_screen.dart';
import 'package:veterinary_pos/src/features/medicines/data/medicines_api.dart';
import 'package:veterinary_pos/src/features/owners/data/owners_api.dart';
import 'package:veterinary_pos/src/features/patients/data/animals_api.dart';
import 'package:veterinary_pos/src/features/reports/data/reports_api.dart';
import 'package:veterinary_pos/src/features/reports/presentation/reports_screen.dart';
import 'package:veterinary_pos/src/features/sales/data/sales_api.dart';

class _FakeOwnersApi extends OwnersApi {
  @override
  Future<List<JsonMap>> list() async => [
    {'owner_id': 1, 'ow_name': 'Sara Krugs'},
  ];
}

class _FakeAnimalsApi extends AnimalsApi {
  @override
  Future<List<JsonMap>> listByOwner(int ownerId) async => [
    {'animal_id': 2, 'an_name': 'Nyxie'},
  ];
}

class _FakeMedicinesApi extends MedicinesApi {
  @override
  Future<List<JsonMap>> list() async => [
    {
      'medicine_id': 3,
      'med_name': 'Amoxicillin 500mg',
      'med_stock': 10,
      'med_sale_price': 10,
    },
  ];
}

class _FakeSalesApi extends SalesApi {
  JsonMap? createdSale;

  @override
  Future<JsonMap> create(JsonMap sale) async {
    createdSale = sale;
    return {'sale_id': 12};
  }
}

class _FakeReportsApi extends ReportsApi {
  @override
  Future<JsonMap> dashboard() async => {
    'total_owners': 3,
    'total_animals': 4,
    'total_medicines': 5,
    'total_sales': 6,
    'total_revenue': 900,
    'low_stock_count': 1,
    'expired_count': 2,
  };

  @override
  Future<List<JsonMap>> dailySales() async => [
    {
      'sale_date': '2026-11-04',
      'total_invoices': 2,
      'subtotal': 120,
      'total_discount': 10,
      'total_sales': 110,
    },
  ];

  @override
  Future<List<JsonMap>> monthlySales() async => [
    {'year': 2026, 'month': 11, 'total_invoices': 2, 'total_sales': 110},
  ];

  @override
  Future<List<JsonMap>> topMedicines() async => [
    {
      'med_name': 'Amoxicillin',
      'med_category': 'Antibiotic',
      'total_qty_sold': 3,
      'total_revenue': 90,
    },
  ];

  @override
  Future<List<JsonMap>> ownerSales() async => [
    {
      'ow_name': 'Sara',
      'ow_phone': '03001234567',
      'total_invoices': 2,
      'total_spent': 110,
    },
  ];

  @override
  Future<List<JsonMap>> purchases() async => [
    {
      'sup_name': 'Vet Supplier',
      'total_purchases': 1,
      'total_items': 10,
      'total_amount': 500,
    },
  ];

  @override
  Future<List<JsonMap>> payments() async => [
    {'pay_method': 'Cash', 'total_transactions': 2, 'total_amount': 110},
  ];
}

void main() {
  testWidgets('login screen renders without ListTile material assertions', (
    tester,
  ) async {
    await tester.pumpWidget(MaterialApp(home: LoginScreen(onSignIn: () {})));

    expect(find.text('Remember me'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('reports screen displays API-backed report sections', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: ReportsScreen(reportsApi: _FakeReportsApi())),
    );
    await tester.pumpAndSettle();

    expect(find.text('Clinic summary'), findsOneWidget);
    expect(find.text('Daily sales trend'), findsOneWidget);
    expect(find.text('Monthly sales'), findsOneWidget);
    expect(find.text('Top selling medicines'), findsOneWidget);
    expect(find.text('Sales by owner'), findsOneWidget);
    expect(find.text('Purchases by supplier'), findsOneWidget);
    expect(find.text('Payments'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('dashboard renders summary and panels', (tester) async {
    await tester.pumpWidget(
      const VeterinaryPosApp(initialRoute: AppRoutesNamed.dashboard),
    );

    expect(find.text('Dashboard'), findsNWidgets(2));
    expect(find.text('Owners'), findsNWidgets(2));
    expect(find.text('Animals'), findsOneWidget);
    expect(find.text('Medicines'), findsNWidgets(2));
    expect(find.text('Revenue'), findsOneWidget);
    expect(find.text('Sales trend (7 days)'), findsOneWidget);
    expect(find.text('Top medicines'), findsOneWidget);
    expect(find.text('Low stock alerts'), findsOneWidget);
    expect(find.text('Upcoming visits'), findsOneWidget);
  });

  testWidgets('registered named routes open feature screens', (tester) async {
    await tester.pumpWidget(
      const VeterinaryPosApp(initialRoute: AppRoutesNamed.dashboard),
    );

    final navigator = tester.state<NavigatorState>(
      find.byType(Navigator).first,
    );
    navigator.pushNamed(AppRoutesNamed.owners);
    await tester.pumpAndSettle();

    expect(find.text('Owners'), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });

  testWidgets('Patients list reports when the API is unavailable', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const VeterinaryPosApp(initialRoute: AppRoutesNamed.dashboard),
    );

    expect(find.text('Dashboard'), findsOneWidget);
    await tester.tap(find.byTooltip('Open navigation'));
    await tester.pumpAndSettle();
    expect(find.text('Patients'), findsOneWidget);
    await tester.tap(find.text('Patients').last);
    await tester.pumpAndSettle();
    expect(find.text('Patients'), findsAtLeastNWidgets(1));
    expect(tester.takeException(), isNull);
  });

  testWidgets('POS billing is usable at the mobile breakpoint', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_buildPosBilling());
    await tester.pumpAndSettle();

    expect(find.text('Customer'), findsOneWidget);
    expect(find.text('Cart'), findsOneWidget);
    expect(find.text('Total'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('POS billing renders without overflow on desktop', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 840);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_buildPosBilling());
    await tester.pumpAndSettle();

    expect(find.text('Complete sale'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('POS adds medicines and submits a sale', (tester) async {
    final salesApi = _FakeSalesApi();
    await tester.pumpWidget(_buildPosBilling(salesApi: salesApi));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Add Amoxicillin 500mg'));
    await tester.pump();
    await tester.ensureVisible(find.text('Complete sale'));
    await tester.tap(find.text('Complete sale'));
    await tester.pumpAndSettle();

    expect(salesApi.createdSale, {
      'owner_id': 1,
      'animal_id': 2,
      'sal_payment_method': 'Cash',
      'sal_discount': 0,
      'items': [
        {'medicine_id': 3, 'si_qty': 1, 'si_price': 10},
      ],
    });
    expect(find.text('Sale #12 completed.'), findsOneWidget);
  });
}

Widget _buildPosBilling({SalesApi? salesApi}) => MaterialApp(
  home: Scaffold(
    body: PosBillingScreen(
      ownersApi: _FakeOwnersApi(),
      animalsApi: _FakeAnimalsApi(),
      medicinesApi: _FakeMedicinesApi(),
      salesApi: salesApi ?? _FakeSalesApi(),
    ),
  ),
);
