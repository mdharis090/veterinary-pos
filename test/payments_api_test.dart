import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:veterinary_pos/src/core/network/api_client.dart';
import 'package:veterinary_pos/src/core/network/token_storage.dart';
import 'package:veterinary_pos/src/features/payments/data/payments_api.dart';

class _MemoryTokenStorage extends TokenStorage {
  @override
  Future<String?> readToken() async => null;
}

void main() {
  test('lists payments from the payments endpoint', () async {
    final api = PaymentsApi(
      ApiClient(
        baseUrl: 'https://api.example.test/api',
        tokenStorage: _MemoryTokenStorage(),
        httpClient: MockClient((request) async {
          expect(request.method, 'GET');
          expect(request.url.path, '/api/payments');
          return http.Response(
            jsonEncode({
              'success': true,
              'data': [
                {
                  'payment_id': 4,
                  'sale_id': 4,
                  'pay_amount': 10,
                  'pay_method': 'Online',
                  'pay_date': '2026-11-02T17:01:57.520Z',
                  'pay_reference': null,
                  'sal_invoice_no': 'INV-1793620917478',
                },
              ],
            }),
            200,
          );
        }),
      ),
    );

    final payments = await api.list();

    expect(payments.single['payment_id'], 4);
    expect(payments.single['sal_invoice_no'], 'INV-1793620917478');
    expect(payments.single['pay_reference'], isNull);
  });
}
