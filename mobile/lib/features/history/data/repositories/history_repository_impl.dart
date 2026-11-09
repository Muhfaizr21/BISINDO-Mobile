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
    // 1. Fetch from local Hive storage first (offline-first)
    final localItems = await localDataSource.getHistoryItems();
    if (localItems.isNotEmpty) {
      return localItems;
    }

    // 2. Fall back to backend server if local is empty
    final remoteItems = await remoteDataSource.fetchHistory();
    for (final item in remoteItems) {
      await localDataSource.saveHistoryItem(item);
    }
    return remoteItems;
  }

  @override
  Future<void> saveHistory(HistoryItem item) async {
    // Save locally to Hive
    await localDataSource.saveHistoryItem(item);

    // Sync to backend asynchronously
    try {
      await remoteDataSource.saveHistoryRemote(item);
    } catch (_) {
      // Offline fallback: item is still safely saved locally
    }
  }

  @override
  Future<void> deleteHistory(String id) async {
    await localDataSource.deleteHistoryItem(id);
  }

  @override
  Future<void> clearHistory() async {
    await localDataSource.clearHistory();
  }
}
