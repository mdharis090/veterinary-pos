import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:veterinary_pos/main.dart';
import 'package:veterinary_pos/src/core/routes/app_routes_named.dart';

void main() {
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

    await tester.pumpWidget(
      const VeterinaryPosApp(initialRoute: AppRoutesNamed.dashboard),
    );
    await tester.tap(find.byTooltip('Open navigation'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('POS Billing'));
    await tester.pumpAndSettle();

    expect(find.text('Invoice INV-001'), findsOneWidget);
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

    await tester.pumpWidget(
      const VeterinaryPosApp(initialRoute: AppRoutesNamed.dashboard),
    );
    await tester.tap(find.text('POS Billing'));
    await tester.pumpAndSettle();

    expect(find.text('Invoice INV-001'), findsOneWidget);
    expect(find.text('Complete sale'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
