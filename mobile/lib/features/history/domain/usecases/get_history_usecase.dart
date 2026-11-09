import '../../../../core/utils/usecase.dart';
import '../entities/history_item.dart';
import '../repositories/history_repository.dart';

class GetHistoryUseCase implements UseCase<List<HistoryItem>, NoParams> {
  final HistoryRepository repository;

  GetHistoryUseCase(this.repository);

  @override
  Future<List<HistoryItem>> call(NoParams params) async {
    return await repository.getHistory();
  }
}

