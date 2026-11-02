import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:veterinary_pos/src/core/network/api_client.dart';
import 'package:veterinary_pos/src/features/medicines/data/medicines_api.dart';
import 'package:veterinary_pos/src/features/returns/data/returns_api.dart';
import 'package:veterinary_pos/src/features/returns/presentation/returns_screen.dart';
import 'package:veterinary_pos/src/features/sales/data/sales_api.dart';

class _FakeReturnsApi extends ReturnsApi {
  JsonMap? submittedReturn;

  @override
  Future<List<JsonMap>> list() async => [];

  @override
  Future<JsonMap> create(JsonMap saleReturn) async {
    submittedReturn = saleReturn;
    return {'return_id': 12, ...saleReturn};
  }
}

class _FakeSalesApi extends SalesApi {
  @override
  Future<List<JsonMap>> list() async => [
    {'sale_id': 1, 'sal_invoice_no': 'INV-001', 'owner_name': 'Amina Khan'},
  ];
}

class _FakeMedicinesApi extends MedicinesApi {
  @override
  Future<List<JsonMap>> list() async => [
    {'medicine_id': 3, 'med_name': 'Amoxicillin'},
  ];
}

void main() {
  testWidgets('submits the return fields expected by the API', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final returnsApi = _FakeReturnsApi();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ReturnsScreen(
            returnsApi: returnsApi,
            salesApi: _FakeSalesApi(),
            medicinesApi: _FakeMedicinesApi(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final dropdowns = find.byType(DropdownButtonFormField<int>);
    await tester.tap(dropdowns.at(0));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('INV-001').last);
    await tester.pumpAndSettle();

    await tester.tap(dropdowns.at(1));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Amoxicillin').last);
    await tester.pumpAndSettle();

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), '2');
    await tester.enterText(fields.at(1), '200');
    await tester.enterText(fields.at(2), 'Damaged medicine');
    await tester.ensureVisible(find.text('Process return'));
    await tester.tap(find.text('Process return'));
    await tester.pumpAndSettle();

    expect(returnsApi.submittedReturn, {
      'sale_id': 1,
      'medicine_id': 3,
      'ret_qty': 2,
      'ret_refund_amount': 200.0,
      'ret_reason': 'Damaged medicine',
    });
    expect(find.text('Return #12 processed successfully.'), findsOneWidget);
  });
}
