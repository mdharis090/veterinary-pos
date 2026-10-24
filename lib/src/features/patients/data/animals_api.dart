import '../../../core/network/api_client.dart';

class AnimalsApi {
  AnimalsApi([ApiClient? client]) : _client = client ?? ApiClient.instance;
  final ApiClient _client;

  Future<List<JsonMap>> list() => _client.getList('animals');
  Future<JsonMap> getById(int id) => _client.getData('animals/$id');
  Future<List<JsonMap>> listByOwner(int ownerId) =>
      _client.getList('animals/owner/$ownerId');
  Future<JsonMap> create(JsonMap animal) =>
      _client.postData('animals', body: animal);
  Future<void> update(int id, JsonMap animal) async {
    await _client.put('animals/$id', body: animal);
  }

  Future<void> delete(int id) async {
    await _client.delete('animals/$id');
  }
}
