import '../../../../core/utils/usecase.dart';
import '../entities/gesture.dart';
import '../entities/translation.dart';
import '../repositories/translate_repository.dart';

class TranslateGestureUseCase implements UseCase<Translation, List<Gesture>> {
  final TranslateRepository repository;

  TranslateGestureUseCase(this.repository);

  @override
  Future<Translation> call(List<Gesture> gestures) async {
    return await repository.translateGestures(gestures);
  }
}

