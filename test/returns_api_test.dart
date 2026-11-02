import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:veterinary_pos/src/core/network/api_client.dart';
import 'package:veterinary_pos/src/core/network/api_exception.dart';
import 'package:veterinary_pos/src/core/network/token_storage.dart';
import 'package:veterinary_pos/src/features/returns/data/returns_api.dart';

class _MemoryTokenStorage extends TokenStorage {
  @override
  Future<String?> readToken() async => null;
}

void main() {
  test('lists returns from the returns endpoint', () async {
    final api = ReturnsApi(
      ApiClient(
        baseUrl: 'https://api.example.test/api',
        tokenStorage: _MemoryTokenStorage(),
        httpClient: MockClient((request) async {
          expect(request.method, 'GET');
          expect(request.url.path, '/api/returns');
          return http.Response(
            jsonEncode({
              'success': true,
              'data': [
                {
                  'return_id': 1,
                  'sale_id': 1,
                  'medicine_id': 1,
                  'ret_qty': 2,
                  'ret_refund_amount': 200,
                  'ret_reason': 'Damaged medicine',
                  'ret_date': '2026-11-02T17:19:10.030Z',
                },
              ],
            }),
            200,
          );
        }),
      ),
    );

    final results = await api.list();

    expect(results.single['return_id'], 1);
    expect(results.single['ret_reason'], 'Damaged medicine');
  });

  test('posts the return payload and returns created data', () async {
    final saleReturn = <String, dynamic>{
      'sale_id': 1,
      'medicine_id': 1,
      'ret_qty': 2,
      'ret_refund_amount': 200,
      'ret_reason': 'Damaged medicine',
    };
    final api = ReturnsApi(
      ApiClient(
        baseUrl: 'https://api.example.test/api',
        tokenStorage: _MemoryTokenStorage(),
        httpClient: MockClient((request) async {
          expect(request.method, 'POST');
          expect(request.url.path, '/api/returns');
          expect(jsonDecode(request.body), saleReturn);
          return http.Response(
            jsonEncode({
              'success': true,
              'data': {'return_id': 1, ...saleReturn},
            }),
            201,
          );
        }),
      ),
    );

    final result = await api.create(saleReturn);

    expect(result['return_id'], 1);
    expect(result['ret_qty'], 2);
  });

  test('surfaces return validation errors from the API', () async {
    final api = ReturnsApi(
      ApiClient(
        baseUrl: 'https://api.example.test/api',
        tokenStorage: _MemoryTokenStorage(),
        httpClient: MockClient(
          (_) async => http.Response(
            jsonEncode({
              'success': false,
              'message': 'The return quantity exceeds the sale quantity.',
            }),
            200,
          ),
        ),
      ),
    );

    await expectLater(
      api.create({'sale_id': 1}),
      throwsA(
        isA<ApiException>().having(
          (error) => error.message,
          'message',
          'The return quantity exceeds the sale quantity.',
        ),
      ),
    );
  });
}
