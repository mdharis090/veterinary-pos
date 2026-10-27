import '../../../core/network/api_client.dart';

class PurchasesApi {
  PurchasesApi([ApiClient? client]) : _client = client ?? ApiClient.instance;

  final ApiClient _client;

  Future<List<JsonMap>> list() => _client.getList('purchases');

  Future<JsonMap> create(JsonMap purchase) =>
      _client.postData('purchases', body: purchase);
}
