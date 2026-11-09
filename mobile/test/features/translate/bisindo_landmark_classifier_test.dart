import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/translate/data/datasources/bisindo_landmark_classifier.dart';
import 'package:mobile/features/translate/domain/entities/hand_landmarks.dart';

void main() {
  group('BisindoLandmarkClassifier Test', () {
    test('returns empty gesture when no hands are detected', () {
      final result = BisindoLandmarkClassifier.classifyHands(const []);
      expect(result.label, equals(''));
      expect(result.confidence, equals(0.0));
    });

    test('classifies standard open 5-finger sample hand', () {
      final result = BisindoLandmarkClassifier.classifyHands([
        HandSkeleton.sample(),
      ]);
      expect(result.label.isNotEmpty, isTrue);
      expect(result.confidence, greaterThan(0.8));
    });
  });
}

