import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:veterinary_pos/main.dart';

void main() {
  testWidgets('dashboard renders summary and panels', (tester) async {
    await tester.pumpWidget(const VeterinaryPosApp());

    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Owners'), findsOneWidget);
    expect(find.text('Animals'), findsOneWidget);
    expect(find.text('Medicines'), findsNWidgets(2));
    expect(find.text('Revenue'), findsOneWidget);
    expect(find.text('Sales trend (7 days)'), findsOneWidget);
    expect(find.text('Top medicines'), findsOneWidget);
    expect(find.text('Low stock alerts'), findsOneWidget);
    expect(find.text('Upcoming visits'), findsOneWidget);
  });

  testWidgets('mobile layout opens navigation drawer', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const VeterinaryPosApp());

    expect(find.text('Dashboard'), findsOneWidget);
    await tester.tap(find.byTooltip('Open navigation'));
    await tester.pumpAndSettle();
    expect(find.text('Patients'), findsOneWidget);
  });
}
