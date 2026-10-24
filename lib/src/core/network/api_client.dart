import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_config.dart';
import 'api_exception.dart';
import 'token_storage.dart';

typedef JsonMap = Map<String, dynamic>;

class ApiClient {
  ApiClient({
    http.Client? httpClient,
    TokenStorage? tokenStorage,
    String? baseUrl,
  }) : _httpClient = httpClient ?? http.Client(),
  _tokenStorage = tokenStorage ?? TokenStorage.instance,
       _baseUrl = (baseUrl ?? ApiConfig.baseUrl).replaceFirst(
         RegExp(r'/+$'),
         '',
       );

  static final ApiClient instance = ApiClient();

  final http.Client _httpClient;
  final TokenStorage _tokenStorage;
  final String _baseUrl;
  static const _requestTimeout = Duration(seconds: 30);

  Future<JsonMap> get(String path) => _request('GET', path);

  Future<JsonMap> post(String path, {required JsonMap body}) =>
      _request('POST', path, body: body);

  Future<JsonMap> put(String path, {required JsonMap body}) =>
      _request('PUT', path, body: body);

  Future<JsonMap> delete(String path) => _request('DELETE', path);

  Future<List<JsonMap>> getList(String path) async =>
      _asList((await get(path))['data'], path);

  Future<JsonMap> getData(String path) async =>
      _asMap((await get(path))['data'], path);

  Future<JsonMap> postData(String path, {required JsonMap body}) async =>
      _asMap((await post(path, body: body))['data'], path);

  Future<JsonMap> _request(
    String method,
    String path, {
    JsonMap? body,
  }) async {
    final token = await _tokenStorage.readToken();
    final headers = <String, String>{
      'Accept': 'application/json',
      if (body != null) 'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
    final request = http.Request(method, Uri.parse('$_baseUrl/$path'))
      ..headers.addAll(headers);
    if (body != null) request.body = jsonEncode(body);

    try {
      final response = await _send(request).timeout(_requestTimeout);
      final decoded = _decodeResponse(response);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        final message = decoded['message'] ?? decoded['error'];
        throw ApiException(
          message is String && message.isNotEmpty
              ? message
              : 'The request could not be completed.',
          statusCode: response.statusCode,
        );
      }
      return decoded;
    } on TimeoutException {
      throw const ApiException(
        'The server took too long to respond. Please try again.',
      );
    } on http.ClientException {
      throw const ApiException(
        'Could not connect to the server. Check the API address and network.',
      );
    }
  }

  Future<http.Response> _send(http.Request request) async =>
      http.Response.fromStream(await _httpClient.send(request));

  JsonMap _decodeResponse(http.Response response) {
    if (response.body.isEmpty) return <String, dynamic>{};
    final Object? decoded;
    try {
      decoded = jsonDecode(response.body);
    } on FormatException {
      throw const ApiException('The server returned an invalid response.');
    }
    if (decoded is! Map<String, dynamic>) {
      throw const ApiException('The server returned an unexpected response.');
    }
    return decoded;
  }

  List<JsonMap> _asList(Object? value, String path) {
    if (value is! List) {
      throw ApiException('Unexpected list response from $path.');
    }
    return value
        .map(
          (item) => item is Map<String, dynamic>
              ? item
              : throw ApiException('Unexpected item response from $path.'),
        )
        .toList(growable: false);
  }

  JsonMap _asMap(Object? value, String path) {
    if (value is! Map<String, dynamic>) {
      throw ApiException('Unexpected data response from $path.');
    }
    return value;
  }
}
