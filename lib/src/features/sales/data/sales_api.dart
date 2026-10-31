import '../../../core/network/api_exception.dart';
import '../../../core/network/api_client.dart';

class SalesApi {
  SalesApi([ApiClient? client]) : _client = client ?? ApiClient.instance;
  final ApiClient _client;

  Future<List<JsonMap>> list() => _client.getList('sales');
  Future<JsonMap> getById(int id) => _client.getData('sales/$id');
  Future<JsonMap> create(JsonMap sale) async {
    final response = await _client.post('sales', body: sale);
    if (response['success'] != true) {
      final message = response['message'] ?? response['error'];
      throw ApiException(
        message is String && message.isNotEmpty
            ? message
            : 'The sale could not be completed.',
      );
    }
    final data = response['data'];
    if (data is! Map<String, dynamic>) {
      throw const ApiException('The server returned an incomplete sale.');
    }
    return data;
  }
}
