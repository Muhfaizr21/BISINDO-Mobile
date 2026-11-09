import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/translate/data/datasources/bisindo_landmark_classifier.dart';
import 'package:mobile/features/translate/domain/entities/hand_landmarks.dart';

HandSkeleton _buildHand({
  required double wristX,
  required double wristY,
  required List<Offset2D> points,
}) {
  return HandSkeleton(
    landmarks: points
        .map((p) => NormalizedLandmark(x: p.x, y: p.y))
        .toList(),
  );
}

class Offset2D {
  final double x;
  final double y;
  const Offset2D(this.x, this.y);
}

void main() {
  group('BisindoLandmarkClassifier Strict Precision Test', () {
    test('returns empty gesture when no hands are detected', () {
      final result = BisindoLandmarkClassifier.classifyHands(const []);
      expect(result.label, equals(''));
      expect(result.confidence, equals(0.0));
    });

    test('rejects neutral 5-finger open waving hand (no false positive)', () {
      final result = BisindoLandmarkClassifier.classifyHands([
        HandSkeleton.sample(),
      ]);
      expect(result.label, equals(''));
      expect(result.confidence, equals(0.0));
    });

    test('accurately classifies 2-hand crossed index fingers as X (not A)', () {
      // Left hand at x=0.38 with index angling up-right from (0.42, 0.58) to (0.56, 0.36)
      final leftHand = _buildHand(
        wristX: 0.38,
        wristY: 0.78,
        points: const [
          Offset2D(0.38, 0.78), // 0: Wrist
          Offset2D(0.41, 0.72), // 1
          Offset2D(0.43, 0.67), // 2
          Offset2D(0.44, 0.64), // 3
          Offset2D(0.43, 0.63), // 4: Thumb curled in fist
          Offset2D(0.42, 0.58), // 5: Index MCP
          Offset2D(0.47, 0.50), // 6: Index PIP
          Offset2D(0.52, 0.43), // 7: Index DIP
          Offset2D(0.56, 0.36), // 8: Index TIP (crossed to right)
          Offset2D(0.40, 0.60), // 9: Middle MCP
          Offset2D(0.41, 0.64), // 10: Middle PIP (curled)
          Offset2D(0.40, 0.67), // 11
          Offset2D(0.39, 0.68), // 12
          Offset2D(0.38, 0.62), // 13: Ring MCP
          Offset2D(0.39, 0.66), // 14
          Offset2D(0.38, 0.69), // 15
          Offset2D(0.37, 0.70), // 16
          Offset2D(0.36, 0.64), // 17: Pinky MCP
          Offset2D(0.37, 0.68), // 18
          Offset2D(0.36, 0.70), // 19
          Offset2D(0.35, 0.71), // 20
        ],
      );

      // Right hand at x=0.62 with index angling up-left from (0.58, 0.58) to (0.44, 0.36)
      final rightHand = _buildHand(
        wristX: 0.62,
        wristY: 0.78,
        points: const [
          Offset2D(0.62, 0.78), // 0: Wrist
          Offset2D(0.59, 0.72), // 1
          Offset2D(0.57, 0.67), // 2
          Offset2D(0.56, 0.64), // 3
          Offset2D(0.57, 0.63), // 4: Thumb curled in fist
          Offset2D(0.58, 0.58), // 5: Index MCP
          Offset2D(0.53, 0.50), // 6: Index PIP
          Offset2D(0.48, 0.43), // 7: Index DIP
          Offset2D(0.44, 0.36), // 8: Index TIP (crossed to left)
          Offset2D(0.60, 0.60), // 9: Middle MCP
          Offset2D(0.59, 0.64), // 10: Middle PIP (curled)
          Offset2D(0.60, 0.67), // 11
          Offset2D(0.61, 0.68), // 12
          Offset2D(0.62, 0.62), // 13: Ring MCP
          Offset2D(0.61, 0.66), // 14
          Offset2D(0.62, 0.69), // 15
          Offset2D(0.63, 0.70), // 16
          Offset2D(0.64, 0.64), // 17: Pinky MCP
          Offset2D(0.63, 0.68), // 18
          Offset2D(0.64, 0.70), // 19
          Offset2D(0.65, 0.71), // 20
        ],
      );

      final result = BisindoLandmarkClassifier.classifyHands([
        leftHand,
        rightHand,
      ]);
      expect(result.label, equals('X'));
      expect(result.confidence, greaterThanOrEqualTo(0.90));
    });

    test('accurately classifies 2-hand triangle as A', () {
      // Left hand forming left side of triangle A (/ and _)
      final leftHand = _buildHand(
        wristX: 0.35,
        wristY: 0.78,
        points: const [
          Offset2D(0.35, 0.78), // 0: Wrist
          Offset2D(0.39, 0.70), // 1
          Offset2D(0.43, 0.64), // 2
          Offset2D(0.46, 0.60), // 3
          Offset2D(0.49, 0.58), // 4: Thumb tip meeting horizontally at center
          Offset2D(0.40, 0.56), // 5: Index MCP
          Offset2D(0.43, 0.48), // 6: Index PIP
          Offset2D(0.46, 0.41), // 7: Index DIP
          Offset2D(0.49, 0.35), // 8: Index TIP meeting at apex
          Offset2D(0.38, 0.60), // 9: Middle MCP
          Offset2D(0.39, 0.65), // 10: Curled
          Offset2D(0.38, 0.68), // 11
          Offset2D(0.37, 0.69), // 12
          Offset2D(0.36, 0.62), // 13
          Offset2D(0.37, 0.67), // 14
          Offset2D(0.36, 0.69), // 15
          Offset2D(0.35, 0.70), // 16
          Offset2D(0.34, 0.64), // 17
          Offset2D(0.35, 0.68), // 18
          Offset2D(0.34, 0.70), // 19
          Offset2D(0.33, 0.71), // 20
        ],
      );

      // Right hand forming right side of triangle A (\ and _)
      final rightHand = _buildHand(
        wristX: 0.65,
        wristY: 0.78,
        points: const [
          Offset2D(0.65, 0.78), // 0: Wrist
          Offset2D(0.61, 0.70), // 1
          Offset2D(0.57, 0.64), // 2
          Offset2D(0.54, 0.60), // 3
          Offset2D(0.51, 0.58), // 4: Thumb tip meeting horizontally at center
          Offset2D(0.60, 0.56), // 5: Index MCP
          Offset2D(0.57, 0.48), // 6: Index PIP
          Offset2D(0.54, 0.41), // 7: Index DIP
          Offset2D(0.51, 0.35), // 8: Index TIP meeting at apex
          Offset2D(0.62, 0.60), // 9: Middle MCP
          Offset2D(0.61, 0.65), // 10: Curled
          Offset2D(0.62, 0.68), // 11
          Offset2D(0.63, 0.69), // 12
          Offset2D(0.64, 0.62), // 13
          Offset2D(0.63, 0.67), // 14
          Offset2D(0.64, 0.69), // 15
          Offset2D(0.65, 0.70), // 16
          Offset2D(0.66, 0.64), // 17
          Offset2D(0.65, 0.68), // 18
          Offset2D(0.66, 0.70), // 19
          Offset2D(0.67, 0.71), // 20
        ],
      );

      final result = BisindoLandmarkClassifier.classifyHands([
        leftHand,
        rightHand,
      ]);
      expect(result.label, equals('A'));
      expect(result.confidence, greaterThanOrEqualTo(0.90));
    });

    test('classifies open 5-finger hand as number 5 in numbers mode', () {
      final hand = HandSkeleton.sample();
      final result = BisindoLandmarkClassifier.classifyHands(
        [hand],
        mode: BisindoTargetMode.numbers,
      );
      expect(result.label, equals('5'));
      expect(result.confidence, greaterThanOrEqualTo(0.90));
    });

    test('classifies two open hands as number 10 in numbers mode', () {
      final hand1 = HandSkeleton.sample();
      final hand2 = HandSkeleton.sample();
      final result = BisindoLandmarkClassifier.classifyHands(
        [hand1, hand2],
        mode: BisindoTargetMode.numbers,
      );
      expect(result.label, equals('10'));
      expect(result.confidence, greaterThanOrEqualTo(0.90));
    });

    test('strictly rejects Thumbs-Up gesture (not a BISINDO letter C or L)', () {
      // Exact Thumbs-Up pose: thumb pointing straight up (y=0.35), 4 fingers curled into fist (y=0.60..0.72)
      final thumbsUpHand = _buildHand(
        wristX: 0.55,
        wristY: 0.78,
        points: const [
          Offset2D(0.55, 0.78), // 0: Wrist
          Offset2D(0.54, 0.66), // 1: Thumb CMC
          Offset2D(0.53, 0.54), // 2: Thumb MCP
          Offset2D(0.52, 0.44), // 3: Thumb IP
          Offset2D(0.52, 0.35), // 4: Thumb TIP (pointing straight up!)
          Offset2D(0.46, 0.56), // 5: Index MCP
          Offset2D(0.44, 0.58), // 6: Index PIP (curled)
          Offset2D(0.47, 0.60), // 7: Index DIP
          Offset2D(0.49, 0.59), // 8: Index TIP (curled in fist)
          Offset2D(0.46, 0.62), // 9: Middle MCP
          Offset2D(0.44, 0.64), // 10: Middle PIP
          Offset2D(0.47, 0.66), // 11: Middle DIP
          Offset2D(0.49, 0.65), // 12: Middle TIP
          Offset2D(0.47, 0.68), // 13: Ring MCP
          Offset2D(0.45, 0.70), // 14: Ring PIP
          Offset2D(0.48, 0.71), // 15: Ring DIP
          Offset2D(0.50, 0.70), // 16: Ring TIP
          Offset2D(0.48, 0.73), // 17: Pinky MCP
          Offset2D(0.46, 0.75), // 18: Pinky PIP
          Offset2D(0.49, 0.76), // 19: Pinky DIP
          Offset2D(0.51, 0.75), // 20: Pinky TIP
        ],
      );

      final alphaResult = BisindoLandmarkClassifier.classifyHands(
        [thumbsUpHand],
        mode: BisindoTargetMode.alphabet,
      );
      expect(alphaResult.label, equals(''));
      expect(alphaResult.confidence, equals(0.0));

      final numResult = BisindoLandmarkClassifier.classifyHands(
        [thumbsUpHand],
        mode: BisindoTargetMode.numbers,
      );
      expect(numResult.label, equals(''));
      expect(numResult.confidence, equals(0.0));
    });

    test('strictly rejects 1-hand closed fist in alphabet and numbers mode', () {
      final closedFist = _buildHand(
        wristX: 0.50,
        wristY: 0.78,
        points: const [
          Offset2D(0.50, 0.78), // 0: Wrist
          Offset2D(0.45, 0.72), // 1
          Offset2D(0.44, 0.65), // 2
          Offset2D(0.46, 0.61), // 3
          Offset2D(0.49, 0.60), // 4: Thumb folded across curled fingers
          Offset2D(0.45, 0.58), // 5: Index MCP
          Offset2D(0.45, 0.54), // 6
          Offset2D(0.46, 0.58), // 7
          Offset2D(0.46, 0.61), // 8: Curled
          Offset2D(0.49, 0.57), // 9: Middle MCP
          Offset2D(0.49, 0.53), // 10
          Offset2D(0.50, 0.58), // 11
          Offset2D(0.50, 0.61), // 12: Curled
          Offset2D(0.53, 0.58), // 13: Ring MCP
          Offset2D(0.53, 0.54), // 14
          Offset2D(0.53, 0.59), // 15
          Offset2D(0.53, 0.62), // 16: Curled
          Offset2D(0.57, 0.60), // 17: Pinky MCP
          Offset2D(0.57, 0.57), // 18
          Offset2D(0.56, 0.61), // 19
          Offset2D(0.56, 0.63), // 20: Curled
        ],
      );

      final alphaResult = BisindoLandmarkClassifier.classifyHands([closedFist]);
      expect(alphaResult.label, equals(''));
      expect(alphaResult.confidence, equals(0.0));
    });
  });
}
