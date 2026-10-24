import '../../../core/network/api_client.dart';

class ConsultationsApi {
  ConsultationsApi([ApiClient? client]) : _client = client ?? ApiClient.instance;
  final ApiClient _client;

  Future<List<JsonMap>> list() => _client.getList('consultations');
  Future<JsonMap> create(JsonMap consultation) =>
      _client.postData('consultations', body: consultation);
}
