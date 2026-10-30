import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:veterinary_pos/src/core/network/api_client.dart';
import 'package:veterinary_pos/src/core/network/api_exception.dart';
import 'package:veterinary_pos/src/core/network/token_storage.dart';
import 'package:veterinary_pos/src/features/purchases/data/purchases_api.dart';

class _MemoryTokenStorage extends TokenStorage {
  @override
  Future<String?> readToken() async => null;
}

void main() {
  test('lists purchases from the purchases endpoint', () async {
    final api = PurchasesApi(
      ApiClient(
        baseUrl: 'https://api.example.test/api',
        tokenStorage: _MemoryTokenStorage(),
        httpClient: MockClient((request) async {
          expect(request.method, 'GET');
          expect(request.url.path, '/api/purchases');
          return http.Response(
            jsonEncode({
              'success': true,
              'data': [
                {'purchase_id': 12, 'pur_total_amount': 42.5},
              ],
            }),
            200,
          );
        }),
      ),
    );

    final purchases = await api.list();

    expect(purchases.single['purchase_id'], 12);
    expect(purchases.single['pur_total_amount'], 42.5);
  });

  test('sends purchase header and item fields to create endpoint', () async {
    final purchase = <String, dynamic>{
      'supplier_id': 3,
      'pur_invoice_no': 'INV-12',
      'pur_discount': 2,
      'items': [
        {
          'medicine_id': 8,
          'pi_batch_no': 'B-101',
          'pi_qty': 2,
          'pi_price': 20,
          'pi_expiry_date': '2027-10-26',
        },
      ],
    };
    final api = PurchasesApi(
      ApiClient(
        baseUrl: 'https://api.example.test/api',
        tokenStorage: _MemoryTokenStorage(),
        httpClient: MockClient((request) async {
          expect(request.method, 'POST');
          expect(request.url.path, '/api/purchases');
          expect(jsonDecode(request.body), purchase);
          return http.Response(
            jsonEncode({
              'success': true,
              'message': 'Purchase created',
              'purchase_id': 12,
              'total': 38,
            }),
            201,
          );
        }),
      ),
    );

    final created = await api.create(purchase);

    expect(created['purchase_id'], 12);
    expect(created['total'], 38);
  });

  test('reports an unsuccessful purchase response', () async {
    final api = PurchasesApi(
      ApiClient(
        baseUrl: 'https://api.example.test/api',
        tokenStorage: _MemoryTokenStorage(),
        httpClient: MockClient(
          (_) async => http.Response(
            jsonEncode({'success': false, 'message': 'Supplier not found'}),
            200,
          ),
        ),
      ),
    );

    await expectLater(
      api.create({'supplier_id': 99, 'items': []}),
      throwsA(
        isA<ApiException>().having(
          (error) => error.message,
          'message',
          'Supplier not found',
        ),
      ),
    );
  });
}
