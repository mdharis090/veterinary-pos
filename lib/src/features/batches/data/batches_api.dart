import '../../../core/network/api_client.dart';

class BatchesApi {
  BatchesApi([ApiClient? client]) : _client = client ?? ApiClient.instance;
  final ApiClient _client;

  Future<List<JsonMap>> list() => _client.getList('batches');
  Future<JsonMap> create(JsonMap batch) =>
      _client.postData('batches', body: batch);
}
