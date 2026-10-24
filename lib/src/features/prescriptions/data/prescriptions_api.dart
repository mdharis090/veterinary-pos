import '../../../core/network/api_client.dart';

class PrescriptionsApi {
  PrescriptionsApi([ApiClient? client]) : _client = client ?? ApiClient.instance;
  final ApiClient _client;

  Future<List<JsonMap>> list() => _client.getList('prescriptions');
  Future<JsonMap> create(JsonMap prescription) =>
      _client.postData('prescriptions', body: prescription);
}
