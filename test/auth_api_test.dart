import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:veterinary_pos/src/core/network/api_client.dart';
import 'package:veterinary_pos/src/core/network/token_storage.dart';
import 'package:veterinary_pos/src/features/auth/data/auth_api.dart';

class _MemoryTokenStorage extends TokenStorage {
  @override
  Future<String?> readToken() async => null;
}

void main() {
  test('posts credentials and parses the Node login response', () async {
    http.Request? capturedRequest;
    final api = AuthApi(
      ApiClient(
        baseUrl: 'https://api.example.test/api',
        tokenStorage: _MemoryTokenStorage(),
        httpClient: MockClient((request) async {
          capturedRequest = request;
          return http.Response(
            jsonEncode({
              'success': true,
              'message': 'Login successful',
              'token': 'test.jwt.token',
              'user': {
                'user_id': 1,
                'username': 'admin',
                'role_id': 1,
                'role_name': 'Admin',
              },
            }),
            200,
          );
        }),
      ),
    );

    final session = await api.login(username: 'admin', password: 'secret');

    expect(capturedRequest?.method, 'POST');
    expect(capturedRequest?.url.path, '/api/auth/login');
    expect(jsonDecode(capturedRequest!.body), {
      'username': 'admin',
      'password': 'secret',
    });
    expect(session.token, 'test.jwt.token');
    expect(session.user['username'], 'admin');
    expect(session.user['role_name'], 'Admin');
  });
}
