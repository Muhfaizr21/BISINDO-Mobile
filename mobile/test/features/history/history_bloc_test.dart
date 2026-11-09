import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/history/domain/entities/history_item.dart';
import 'package:mobile/features/history/domain/repositories/history_repository.dart';
import 'package:mobile/features/history/domain/usecases/delete_history_item_usecase.dart';
import 'package:mobile/features/history/domain/usecases/get_history_usecase.dart';
import 'package:mobile/features/history/domain/usecases/save_history_item_usecase.dart';
import 'package:mobile/features/history/presentation/bloc/history_bloc.dart';
import 'package:mobile/features/history/presentation/bloc/history_event.dart';
import 'package:mobile/features/history/presentation/bloc/history_state.dart';

class FakeHistoryRepository implements HistoryRepository {
  final List<HistoryItem> _items = [];

  @override
  Future<List<HistoryItem>> getHistory() async {
    return List.unmodifiable(_items);
  }

  @override
  Future<void> saveHistory(HistoryItem item) async {
    _items.insert(0, item);
  }

  @override
  Future<void> deleteHistory(String id) async {
    _items.removeWhere((item) => item.id == id);
  }

  @override
  Future<void> clearHistory() async {
    _items.clear();
  }
}

void main() {
  group('HistoryBloc Test', () {
    late FakeHistoryRepository repository;
    late GetHistoryUseCase getHistoryUseCase;
    late SaveHistoryItemUseCase saveHistoryItemUseCase;
    late DeleteHistoryItemUseCase deleteHistoryItemUseCase;
    late HistoryBloc bloc;

    setUp(() {
      repository = FakeHistoryRepository();
      getHistoryUseCase = GetHistoryUseCase(repository);
      saveHistoryItemUseCase = SaveHistoryItemUseCase(repository);
      deleteHistoryItemUseCase = DeleteHistoryItemUseCase(repository);
      bloc = HistoryBloc(
        getHistoryUseCase: getHistoryUseCase,
        saveHistoryItemUseCase: saveHistoryItemUseCase,
        deleteHistoryItemUseCase: deleteHistoryItemUseCase,
        repository: repository,
      );
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state is HistoryInitial', () {
      expect(bloc.state, equals(HistoryInitial()));
    });

    blocTest<HistoryBloc, HistoryState>(
      'emits [HistoryLoading, HistoryLoaded] when LoadHistoryEvent is added',
      build: () => bloc,
      act: (b) => b.add(LoadHistoryEvent()),
      expect: () => [
        HistoryLoading(),
        const HistoryLoaded([]),
      ],
    );

    final item = HistoryItem(
      id: '1',
      text: 'Halo',
      timestamp: DateTime(2026, 1, 1),
    );

    blocTest<HistoryBloc, HistoryState>(
      'emits [HistoryLoaded] with new item when AddHistoryItemEvent is added',
      build: () => bloc,
      act: (b) => b.add(AddHistoryItemEvent(item)),
      expect: () => [
        HistoryLoaded([item]),
      ],
    );

    blocTest<HistoryBloc, HistoryState>(
      'emits [HistoryLoaded] without item when DeleteHistoryItemEvent is added',
      build: () => bloc,
      seed: () => HistoryLoaded([item]),
      act: (b) {
        repository.saveHistory(item);
        b.add(DeleteHistoryItemEvent(item.id));
      },
      expect: () => [
        const HistoryLoaded([]),
      ],
    );
  });
}
