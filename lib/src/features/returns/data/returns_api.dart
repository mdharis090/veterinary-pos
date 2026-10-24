import '../../../core/network/api_client.dart';

class ReturnsApi {
  ReturnsApi([ApiClient? client]) : _client = client ?? ApiClient.instance;
  final ApiClient _client;

  Future<List<JsonMap>> list() => _client.getList('returns');
  Future<JsonMap> create(JsonMap saleReturn) =>
      _client.postData('returns', body: saleReturn);
}
