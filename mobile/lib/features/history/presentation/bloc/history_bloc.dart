import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/usecase.dart';
import '../../domain/repositories/history_repository.dart';
import '../../domain/usecases/delete_history_item_usecase.dart';
import '../../domain/usecases/get_history_usecase.dart';
import '../../domain/usecases/save_history_item_usecase.dart';
import 'history_event.dart';
import 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final GetHistoryUseCase getHistoryUseCase;
  final SaveHistoryItemUseCase saveHistoryItemUseCase;
  final DeleteHistoryItemUseCase deleteHistoryItemUseCase;
  final HistoryRepository repository;

  HistoryBloc({
    required this.getHistoryUseCase,
    required this.saveHistoryItemUseCase,
    required this.deleteHistoryItemUseCase,
    required this.repository,
  }) : super(HistoryInitial()) {
    on<LoadHistoryEvent>((event, emit) async {
      emit(HistoryLoading());
      try {
        final items = await getHistoryUseCase(const NoParams());
        emit(HistoryLoaded(items));
      } catch (e) {
        emit(HistoryError(e.toString()));
      }
    });

    on<AddHistoryItemEvent>((event, emit) async {
      try {
        await saveHistoryItemUseCase(event.item);
        final items = await getHistoryUseCase(const NoParams());
        emit(HistoryLoaded(items));
      } catch (e) {
        emit(HistoryError(e.toString()));
      }
    });

    on<DeleteHistoryItemEvent>((event, emit) async {
      try {
        await deleteHistoryItemUseCase(event.id);
        final items = await getHistoryUseCase(const NoParams());
        emit(HistoryLoaded(items));
      } catch (e) {
        emit(HistoryError(e.toString()));
      }
    });

    on<ClearHistoryEvent>((event, emit) async {
      try {
        await repository.clearHistory();
        emit(const HistoryLoaded([]));
      } catch (e) {
        emit(HistoryError(e.toString()));
      }
    });
  }
}
