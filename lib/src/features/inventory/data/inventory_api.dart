import '../../../core/network/api_client.dart';

class InventoryApi {
  InventoryApi([ApiClient? client]) : _client = client ?? ApiClient.instance;
  final ApiClient _client;

  Future<List<JsonMap>> stock() => _client.getList('inventory/stock');
  Future<List<JsonMap>> lowStock() => _client.getList('inventory/low-stock');
  Future<List<JsonMap>> expired() => _client.getList('inventory/expired');
  Future<List<JsonMap>> logs() => _client.getList('inventory/logs');
}
