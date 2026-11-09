import '../../../../core/utils/usecase.dart';
import '../entities/history_item.dart';
import '../repositories/history_repository.dart';

class SaveHistoryItemUseCase implements UseCase<void, HistoryItem> {
  final HistoryRepository repository;

  SaveHistoryItemUseCase(this.repository);

  @override
  Future<void> call(HistoryItem item) async {
    await repository.saveHistory(item);
  }
}

