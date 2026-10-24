import '../../../core/network/api_client.dart';

class MedicinesApi {
  MedicinesApi([ApiClient? client]) : _client = client ?? ApiClient.instance;
  final ApiClient _client;

  Future<List<JsonMap>> list() => _client.getList('medicines');
  Future<JsonMap> getById(int id) => _client.getData('medicines/$id');
  Future<JsonMap> create(JsonMap medicine) =>
      _client.postData('medicines', body: medicine);
  Future<void> update(int id, JsonMap medicine) async {
    await _client.put('medicines/$id', body: medicine);
  }

  Future<void> delete(int id) async {
    await _client.delete('medicines/$id');
  }
}
