import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/usecase.dart';
import '../../domain/usecases/get_learn_materials_usecase.dart';
import 'learn_event.dart';
import 'learn_state.dart';

class LearnBloc extends Bloc<LearnEvent, LearnState> {
  final GetLearnMaterialsUseCase getLearnMaterialsUseCase;

  LearnBloc({required this.getLearnMaterialsUseCase}) : super(LearnInitial()) {
    on<LoadLearnMaterialsEvent>((event, emit) async {
      emit(LearnLoading());
      try {
        final items = await getLearnMaterialsUseCase(const NoParams());
        emit(LearnLoaded(items));
      } catch (e) {
        emit(LearnError(e.toString()));
      }
    });
  }
}

