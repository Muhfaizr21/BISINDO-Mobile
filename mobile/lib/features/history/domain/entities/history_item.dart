import 'package:equatable/equatable.dart';

class HistoryItem extends Equatable {
  final String id;
  final String text;
  final DateTime timestamp;

  const HistoryItem({
    required this.id,
    required this.text,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [id, text, timestamp];
}

