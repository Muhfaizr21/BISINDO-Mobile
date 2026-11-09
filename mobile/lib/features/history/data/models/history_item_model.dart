import '../../domain/entities/history_item.dart';

class HistoryItemModel extends HistoryItem {
  const HistoryItemModel({
    required super.id,
    required super.text,
    required super.timestamp,
  });

  factory HistoryItemModel.fromEntity(HistoryItem entity) {
    return HistoryItemModel(
      id: entity.id,
      text: entity.text,
      timestamp: entity.timestamp,
    );
  }

  factory HistoryItemModel.fromMap(Map<dynamic, dynamic> map) {
    return HistoryItemModel(
      id: map['id'] as String? ?? '',
      text: map['text'] as String? ?? '',
      timestamp: DateTime.fromMillisecondsSinceEpoch(
        map['timestamp'] as int? ?? DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }
}

