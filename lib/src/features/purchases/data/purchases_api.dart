import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';

class PurchasesApi {
  PurchasesApi([ApiClient? client]) : _client = client ?? ApiClient.instance;

  final ApiClient _client;

  Future<List<JsonMap>> list() => _client.getList('purchases');

  Future<JsonMap> create(JsonMap purchase) async {
    final response = await _client.post('purchases', body: purchase);
    if (response['success'] != true) {
      final message = response['message'] ?? response['error'];
      throw ApiException(
        message is String && message.isNotEmpty
            ? message
            : 'The purchase could not be created.',
      );
    }
    return response;
  }
}
