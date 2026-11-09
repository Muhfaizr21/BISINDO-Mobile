import '../entities/gesture.dart';
import '../entities/translation.dart';

abstract class TranslateRepository {
  Future<Translation> translateGestures(List<Gesture> gestures);
  Future<Gesture> classifyLandmarks(dynamic landmarks);
}

