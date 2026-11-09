import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../../domain/entities/history_item.dart';
import '../models/history_item_model.dart';

abstract class HistoryRemoteDataSource {
  Future<List<HistoryItem>> fetchHistory();
  Future<HistoryItem?> saveHistoryRemote(HistoryItem item);
  Future<bool> clearHistoryRemote();
}

class HistoryRemoteDataSourceImpl implements HistoryRemoteDataSource {
  final http.Client client;

  HistoryRemoteDataSourceImpl({http.Client? client})
      : client = client ?? http.Client();

  @override
  Future<List<HistoryItem>> fetchHistory() async {
    try {
      final response = await client
          .get(
            Uri.parse(ApiConstants.historyEndpoint),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList
            .map((item) =>
                HistoryItemModel.fromMap(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  @override
  Future<HistoryItem?> saveHistoryRemote(HistoryItem item) async {
    try {
      final model = HistoryItemModel.fromEntity(item);
      final response = await client
          .post(
            Uri.parse(ApiConstants.historyEndpoint),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(model.toMap()),
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        return HistoryItemModel.fromMap(data);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<bool> clearHistoryRemote() async {
    try {
      final response = await client
          .delete(
            Uri.parse(ApiConstants.historyEndpoint),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
