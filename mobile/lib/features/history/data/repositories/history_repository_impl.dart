import '../../domain/entities/history_item.dart';
import '../../domain/repositories/history_repository.dart';
import '../datasources/history_local_data_source.dart';
import '../datasources/history_remote_data_source.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryLocalDataSource localDataSource;
  final HistoryRemoteDataSource remoteDataSource;

  HistoryRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<List<HistoryItem>> getHistory() async {
    final localItems = await localDataSource.getHistoryItems();
    final mergedMap = <String, HistoryItem>{
      for (final item in localItems) item.id: item,
    };

    try {
      final remoteItems = await remoteDataSource.fetchHistory();
      for (final remoteItem in remoteItems) {
        if (!mergedMap.containsKey(remoteItem.id)) {
          mergedMap[remoteItem.id] = remoteItem;
          await localDataSource.saveHistoryItem(remoteItem);
        }
      }
    } catch (_) {
      // Offline mode: use cached local items
    }

    final sorted = mergedMap.values.toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return sorted;
  }

  @override
  Future<void> saveHistory(HistoryItem item) async {
    await localDataSource.saveHistoryItem(item);
    try {
      await remoteDataSource.saveHistoryRemote(item);
    } catch (_) {}
  }

  @override
  Future<void> deleteHistory(String id) async {
    await localDataSource.deleteHistoryItem(id);
  }

  @override
  Future<void> clearHistory() async {
    await localDataSource.clearHistory();
    try {
      await remoteDataSource.clearHistoryRemote();
    } catch (_) {}
  }
}
