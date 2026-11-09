import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/translate/domain/entities/gesture.dart';
import 'package:mobile/features/translate/domain/entities/translation.dart';
import 'package:mobile/features/translate/domain/repositories/translate_repository.dart';
import 'package:mobile/features/translate/domain/usecases/translate_gesture_usecase.dart';
import 'package:mobile/features/translate/presentation/bloc/translate_bloc.dart';
import 'package:mobile/features/translate/presentation/bloc/translate_event.dart';
import 'package:mobile/features/translate/presentation/bloc/translate_state.dart';

class FakeTranslateRepository implements TranslateRepository {
  @override
  Future<Translation> translateGestures(List<Gesture> gestures) async {
    return Translation(
      text: gestures.map((g) => g.label).join(' '),
      gestures: gestures,
      timestamp: DateTime(2026, 1, 1),
    );
  }

  @override
  Future<Gesture> classifyLandmarks(dynamic landmarks) async {
    return const Gesture(label: 'Halo', confidence: 0.95);
  }
}

void main() {
  group('TranslateBloc Test', () {
    late FakeTranslateRepository fakeRepository;
    late TranslateGestureUseCase useCase;
    late TranslateBloc bloc;

    setUp(() {
      fakeRepository = FakeTranslateRepository();
      useCase = TranslateGestureUseCase(fakeRepository);
      bloc = TranslateBloc(translateGestureUseCase: useCase);
    });

    tearDown(() {
      bloc.close();
    });

    test('initial state is TranslateInitial', () {
      expect(bloc.state, equals(TranslateInitial()));
    });

    blocTest<TranslateBloc, TranslateState>(
      'emits [TranslateDetecting] when StartDetectionEvent is added',
      build: () => bloc,
      act: (b) => b.add(StartDetectionEvent()),
      expect: () => [
        const TranslateDetecting(detectedGestures: [], translatedText: ''),
      ],
    );

    blocTest<TranslateBloc, TranslateState>(
      'emits updated [TranslateDetecting] when GestureDetectedEvent is added',
      build: () => bloc,
      seed: () => const TranslateDetecting(detectedGestures: [], translatedText: ''),
      act: (b) => b.add(const GestureDetectedEvent(Gesture(label: 'Halo', confidence: 0.9))),
      expect: () => [
        const TranslateDetecting(
          detectedGestures: [Gesture(label: 'Halo', confidence: 0.9)],
          translatedText: 'Halo',
        ),
      ],
    );

    blocTest<TranslateBloc, TranslateState>(
      'emits [TranslateStopped] when StopDetectionEvent is added',
      build: () => bloc,
      seed: () => const TranslateDetecting(
        detectedGestures: [Gesture(label: 'Halo', confidence: 0.9)],
        translatedText: 'Halo',
      ),
      act: (b) => b.add(StopDetectionEvent()),
      expect: () => [
        const TranslateStopped(finalTranslation: 'Halo'),
      ],
    );
  });
}

