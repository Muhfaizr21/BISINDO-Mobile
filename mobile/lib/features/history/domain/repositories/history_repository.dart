import '../entities/history_item.dart';

abstract class HistoryRepository {
  Future<List<HistoryItem>> getHistory();
  Future<void> saveHistory(HistoryItem item);
  Future<void> deleteHistory(String id);
  Future<void> clearHistory();
}
