import '../../../core/network/api_client.dart';

class PaymentsApi {
  PaymentsApi([ApiClient? client]) : _client = client ?? ApiClient.instance;
  final ApiClient _client;

  Future<List<JsonMap>> list() => _client.getList('payments');
}
