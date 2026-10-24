import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  TokenStorage({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  static final TokenStorage instance = TokenStorage();
  static const _tokenKey = 'auth_token';
  final FlutterSecureStorage _storage;
  String? _sessionToken;

  Future<String?> readToken() async =>
      _sessionToken ?? await _storage.read(key: _tokenKey);

  Future<void> saveToken(String token, {bool persist = true}) async {
    _sessionToken = token;
    if (persist) {
      await _storage.write(key: _tokenKey, value: token);
    } else {
      await _storage.delete(key: _tokenKey);
    }
  }

  Future<void> clearToken() async {
    _sessionToken = null;
    await _storage.delete(key: _tokenKey);
  }
}
