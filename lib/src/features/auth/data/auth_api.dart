import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';

class AuthSession {
  const AuthSession({required this.token, required this.user});

  final String token;
  final JsonMap user;

  factory AuthSession.fromJson(JsonMap json) {
    if (json['success'] != true) {
      final message = json['message'];
      throw ApiException(
        message is String && message.isNotEmpty
            ? message
            : 'Login was not accepted by the server.',
      );
    }
    final token = json['token'];
    final user = json['user'];
    if (token is! String || token.isEmpty || user is! Map<String, dynamic>) {
      throw const ApiException(
        'The server returned an incomplete login response.',
      );
    }
    return AuthSession(token: token, user: user);
  }
}

class AuthApi {
  AuthApi([ApiClient? client]) : _client = client ?? ApiClient.instance;

  final ApiClient _client;

  Future<AuthSession> login({
    required String username,
    required String password,
  }) async => AuthSession.fromJson(
    await _client.post(
      'auth/login',
      body: {'username': username, 'password': password},
    ),
  );

  Future<JsonMap> register({
    required String username,
    required String password,
    required int roleId,
    String status = 'Active',
  }) => _client.post(
    'auth/register',
    body: {
      'username': username,
      'password': password,
      'role_id': roleId,
      'status': status,
    },
  );

  Future<JsonMap> currentUser() => _client.get('auth/me');
}
