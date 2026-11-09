import '../../../../core/utils/usecase.dart';
import '../repositories/history_repository.dart';

class DeleteHistoryItemUseCase implements UseCase<void, String> {
  final HistoryRepository repository;

  DeleteHistoryItemUseCase(this.repository);

  @override
  Future<void> call(String id) async {
    await repository.deleteHistory(id);
  }
}

