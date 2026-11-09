import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/history_item.dart';
import '../models/history_item_model.dart';

abstract class HistoryLocalDataSource {
  Future<List<HistoryItem>> getHistoryItems();
  Future<void> saveHistoryItem(HistoryItem item);
  Future<void> deleteHistoryItem(String id);
  Future<void> clearHistory();
}

class HistoryLocalDataSourceImpl implements HistoryLocalDataSource {
  final List<HistoryItem> _fallbackMemory = [];

  Future<Box<Map>?> _getBox() async {
    try {
      if (Hive.isBoxOpen(AppConstants.historyBox)) {
        return Hive.box<Map>(AppConstants.historyBox);
      }
      return await Hive.openBox<Map>(AppConstants.historyBox);
    } catch (_) {
      // Fallback when Hive path is not initialized (e.g. widget tests)
      return null;
    }
  }

  @override
  Future<List<HistoryItem>> getHistoryItems() async {
    final box = await _getBox();
    if (box != null) {
      final items = <HistoryItem>[];
      for (var i = box.length - 1; i >= 0; i--) {
        final val = box.getAt(i);
        if (val != null) {
          items.add(HistoryItemModel.fromMap(val));
        }
      }
      return items;
    }
    return List.unmodifiable(_fallbackMemory);
  }

  @override
  Future<void> saveHistoryItem(HistoryItem item) async {
    final box = await _getBox();
    if (box != null) {
      final model = HistoryItemModel.fromEntity(item);
      await box.put(item.id, model.toMap());
    } else {
      _fallbackMemory.insert(0, item);
    }
  }

  @override
  Future<void> deleteHistoryItem(String id) async {
    final box = await _getBox();
    if (box != null) {
      await box.delete(id);
    } else {
      _fallbackMemory.removeWhere((item) => item.id == id);
    }
  }

  @override
  Future<void> clearHistory() async {
    final box = await _getBox();
    if (box != null) {
      await box.clear();
    } else {
      _fallbackMemory.clear();
    }
  }
}
