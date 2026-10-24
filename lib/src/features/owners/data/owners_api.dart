import '../../../core/network/api_client.dart';

class OwnersApi {
  OwnersApi([ApiClient? client]) : _client = client ?? ApiClient.instance;
  final ApiClient _client;

  Future<List<JsonMap>> list() => _client.getList('owners');
  Future<JsonMap> getById(int id) => _client.getData('owners/$id');
  Future<JsonMap> create(JsonMap owner) =>
      _client.postData('owners', body: owner);
  Future<void> update(int id, JsonMap owner) async {
    await _client.put('owners/$id', body: owner);
  }

  Future<void> delete(int id) async {
    await _client.delete('owners/$id');
  }
}
