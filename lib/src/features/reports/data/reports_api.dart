import '../../../core/network/api_client.dart';

class ReportsApi {
  ReportsApi([ApiClient? client]) : _client = client ?? ApiClient.instance;
  final ApiClient _client;

  Future<JsonMap> dashboard() => _client.getData('reports/dashboard');
  Future<List<JsonMap>> dailySales() =>
      _client.getList('reports/daily-sales');
  Future<List<JsonMap>> monthlySales() =>
      _client.getList('reports/monthly-sales');
  Future<List<JsonMap>> topMedicines() =>
      _client.getList('reports/top-medicines');
  Future<List<JsonMap>> ownerSales() =>
      _client.getList('reports/owner-sales');
  Future<List<JsonMap>> purchases() =>
      _client.getList('reports/purchases');
  Future<List<JsonMap>> payments() =>
      _client.getList('reports/payments');
}
