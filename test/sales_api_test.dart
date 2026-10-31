import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:veterinary_pos/src/core/network/api_client.dart';
import 'package:veterinary_pos/src/core/network/api_exception.dart';
import 'package:veterinary_pos/src/core/network/token_storage.dart';
import 'package:veterinary_pos/src/features/sales/data/sales_api.dart';

class _MemoryTokenStorage extends TokenStorage {
  @override
  Future<String?> readToken() async => null;
}

void main() {
  test('posts the POS sale fields and returns created sale data', () async {
    final sale = <String, dynamic>{
      'owner_id': 1,
      'animal_id': 2,
      'sal_payment_method': 'Cash',
      'sal_discount': 5,
      'items': [
        {'medicine_id': 3, 'si_qty': 2, 'si_price': 10},
      ],
    };
    final api = SalesApi(
      ApiClient(
        baseUrl: 'https://api.example.test/api',
        tokenStorage: _MemoryTokenStorage(),
        httpClient: MockClient((request) async {
          expect(request.method, 'POST');
          expect(request.url.path, '/api/sales');
          expect(jsonDecode(request.body), sale);
          return http.Response(
            jsonEncode({
              'success': true,
              'message': 'Sale completed',
              'data': {
                'sale_id': 12,
                'subtotal': 20,
                'discount': 5,
                'total': 15,
              },
            }),
            201,
          );
        }),
      ),
    );

    final result = await api.create(sale);

    expect(result['sale_id'], 12);
    expect(result['total'], 15);
  });

  test(
    'reports sale validation errors returned with a successful HTTP status',
    () async {
      final api = SalesApi(
        ApiClient(
          baseUrl: 'https://api.example.test/api',
          tokenStorage: _MemoryTokenStorage(),
          httpClient: MockClient(
            (_) async => http.Response(
              jsonEncode({
                'success': false,
                'message': 'Insufficient medicine stock',
              }),
              200,
            ),
          ),
        ),
      );

      await expectLater(
        api.create({'items': []}),
        throwsA(
          isA<ApiException>().having(
            (error) => error.message,
            'message',
            'Insufficient medicine stock',
          ),
        ),
      );
    },
  );
}
