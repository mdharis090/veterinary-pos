import '../../../core/network/api_client.dart';

class SuppliersApi {
  SuppliersApi([ApiClient? client]) : _client = client ?? ApiClient.instance;
  final ApiClient _client;

  Future<List<JsonMap>> list() => _client.getList('suppliers');
  Future<JsonMap> create(JsonMap supplier) =>
      _client.postData('suppliers', body: supplier);
}
