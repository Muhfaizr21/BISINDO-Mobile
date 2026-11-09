import 'package:equatable/equatable.dart';
import '../../domain/entities/history_item.dart';

abstract class HistoryEvent extends Equatable {
  const HistoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadHistoryEvent extends HistoryEvent {}

class AddHistoryItemEvent extends HistoryEvent {
  final HistoryItem item;

  const AddHistoryItemEvent(this.item);

  @override
  List<Object?> get props => [item];
}

class DeleteHistoryItemEvent extends HistoryEvent {
  final String id;

  const DeleteHistoryItemEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class ClearHistoryEvent extends HistoryEvent {}
