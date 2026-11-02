import '../../../core/network/api_exception.dart';
import '../../../core/network/api_client.dart';

class ReturnsApi {
  ReturnsApi([ApiClient? client]) : _client = client ?? ApiClient.instance;
  final ApiClient _client;

  Future<List<JsonMap>> list() => _client.getList('returns');
  Future<JsonMap> create(JsonMap saleReturn) async {
    final response = await _client.post('returns', body: saleReturn);
    if (response['success'] != true) {
      final message = response['message'] ?? response['error'];
      throw ApiException(
        message is String && message.isNotEmpty
            ? message
            : 'The return could not be processed.',
      );
    }
    final data = response['data'];
    if (data is! Map<String, dynamic>) {
      throw const ApiException('The server returned an incomplete return.');
    }
    return data;
  }
}
