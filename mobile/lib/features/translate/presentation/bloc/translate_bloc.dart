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
      if (state is TranslateDetecting) {
        emit(const TranslateDetecting(
          detectedGestures: [],
          translatedText: '',
        ));
      } else {
        emit(TranslateInitial());
      }
    });

    on<AppendSpaceEvent>((event, emit) {
      if (state is TranslateDetecting) {
        final current = state as TranslateDetecting;
        final newText = current.translatedText.isNotEmpty && !current.translatedText.endsWith(' ')
            ? '${current.translatedText} '
            : current.translatedText;
        emit(current.copyWith(translatedText: newText));
      } else if (state is TranslateStopped) {
        final current = state as TranslateStopped;
        final newText = current.finalTranslation.isNotEmpty && !current.finalTranslation.endsWith(' ')
            ? '${current.finalTranslation} '
            : current.finalTranslation;
        emit(TranslateStopped(finalTranslation: newText));
      }
    });

    on<BackspaceEvent>((event, emit) {
      if (state is TranslateDetecting) {
        final current = state as TranslateDetecting;
        if (current.translatedText.isNotEmpty) {
          final newText = current.translatedText.substring(0, current.translatedText.length - 1);
          final updatedGestures = current.detectedGestures.isNotEmpty
              ? current.detectedGestures.sublist(0, current.detectedGestures.length - 1)
              : current.detectedGestures;
          emit(current.copyWith(
            translatedText: newText,
            detectedGestures: updatedGestures,
          ));
        }
      } else if (state is TranslateStopped) {
        final current = state as TranslateStopped;
        if (current.finalTranslation.isNotEmpty) {
          final newText = current.finalTranslation.substring(0, current.finalTranslation.length - 1);
          emit(TranslateStopped(finalTranslation: newText));
        }
      }
    });

    on<SetTranslatedTextEvent>((event, emit) {
      if (state is TranslateDetecting) {
        final current = state as TranslateDetecting;
        emit(current.copyWith(translatedText: event.text));
      } else if (state is TranslateStopped) {
        emit(TranslateStopped(finalTranslation: event.text));
      }
    });
  }
}

