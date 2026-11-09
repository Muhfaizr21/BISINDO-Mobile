import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/translate_gesture_usecase.dart';
import 'translate_event.dart';
import 'translate_state.dart';

class TranslateBloc extends Bloc<TranslateEvent, TranslateState> {
  final TranslateGestureUseCase translateGestureUseCase;

  TranslateBloc({required this.translateGestureUseCase}) : super(TranslateInitial()) {
    on<StartDetectionEvent>((event, emit) {
      emit(const TranslateDetecting(
        detectedGestures: [],
        translatedText: '',
      ));
    });

    on<GestureDetectedEvent>((event, emit) async {
      if (state is TranslateDetecting) {
        final current = state as TranslateDetecting;
        final updatedGestures = [...current.detectedGestures, event.gesture];
        final translation = await translateGestureUseCase(updatedGestures);
        emit(current.copyWith(
          detectedGestures: updatedGestures,
          translatedText: translation.text,
        ));
      }
    });

    on<StopDetectionEvent>((event, emit) {
      if (state is TranslateDetecting) {
        final current = state as TranslateDetecting;
        emit(TranslateStopped(finalTranslation: current.translatedText));
      } else {
        emit(const TranslateStopped());
      }
    });

    on<ClearTranslationEvent>((event, emit) {
      emit(TranslateInitial());
    });
  }
}

