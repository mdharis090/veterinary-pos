import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:veterinary_pos/src/core/network/api_client.dart';
import 'package:veterinary_pos/src/features/payments/data/payments_api.dart';
import 'package:veterinary_pos/src/features/payments/presentation/payments_screen.dart';

class _FakePaymentsApi extends PaymentsApi {
  @override
  Future<List<JsonMap>> list() async => [
    {
      'payment_id': 4,
      'sale_id': 4,
      'pay_amount': 10,
      'pay_method': 'Online',
      'pay_date': '2026-11-02T17:01:57.520Z',
      'pay_reference': null,
      'sal_invoice_no': 'INV-1793620917478',
    },
  ];
}

void main() {
  testWidgets('shows payment details returned by the API', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: PaymentsScreen(paymentsApi: _FakePaymentsApi())),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('INV-1793620917478'), findsOneWidget);
    expect(find.text('Rs 10.00'), findsOneWidget);
    expect(find.text('Online'), findsOneWidget);
    expect(find.text('02/11/2026'), findsOneWidget);
    expect(find.text('—'), findsOneWidget);
  });
}
