import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:veterinary_pos/src/core/network/api_client.dart';
import 'package:veterinary_pos/src/core/network/api_exception.dart';
import 'package:veterinary_pos/src/core/network/token_storage.dart';

class _MemoryTokenStorage extends TokenStorage {
  @override
  Future<String?> readToken() async => 'test-token';
}

void main() {
  test('sends bearer token and decodes list envelope', () async {
    http.Request? capturedRequest;
    final client = ApiClient(
      baseUrl: 'https://api.example.test/api',
      tokenStorage: _MemoryTokenStorage(),
      httpClient: MockClient((request) async {
        capturedRequest = request;
        return http.Response(
          jsonEncode({
            'success': true,
            'data': [
              {'owner_id': 7, 'ow_name': 'Test Owner'},
            ],
          }),
          200,
        );
      }),
    );

    final owners = await client.getList('owners');

    expect(capturedRequest?.url.path, '/api/owners');
    expect(
      capturedRequest?.headers.entries
          .singleWhere((entry) => entry.key.toLowerCase() == 'authorization')
          .value,
      'Bearer test-token',
    );
    expect(owners.single['owner_id'], 7);
  });

  test('preserves server message and status in API errors', () async {
    final client = ApiClient(
      baseUrl: 'https://api.example.test/api',
      tokenStorage: _MemoryTokenStorage(),
      httpClient: MockClient(
        (_) async => http.Response(
          jsonEncode({'success': false, 'message': 'Invalid credentials'}),
          401,
        ),
      ),
    );

    await expectLater(
      client.post('auth/login', body: {'username': 'x', 'password': 'y'}),
      throwsA(
        isA<ApiException>()
            .having((error) => error.message, 'message', 'Invalid credentials')
            .having((error) => error.statusCode, 'statusCode', 401),
      ),
    );
  });
}
