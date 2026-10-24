import '../../../core/network/api_client.dart';

class SalesApi {
  SalesApi([ApiClient? client]) : _client = client ?? ApiClient.instance;
  final ApiClient _client;

  Future<List<JsonMap>> list() => _client.getList('sales');
  Future<JsonMap> getById(int id) => _client.getData('sales/$id');
  Future<JsonMap> create(JsonMap sale) =>
      _client.postData('sales', body: sale);
}
