import 'dart:math' as math;
import '../../domain/entities/gesture.dart';
import '../../domain/entities/hand_landmarks.dart';

/// Geometric 21-Landmark BISINDO (Indonesian Sign Language) Classifier.
/// Supports both 1-hand and 2-hand BISINDO alphabet gestures (A-Z).
class BisindoLandmarkClassifier {
  static double _dist(NormalizedLandmark a, NormalizedLandmark b) {
    final dx = a.x - b.x;
    final dy = a.y - b.y;
    return math.sqrt(dx * dx + dy * dy);
  }

  static double _angleDeg(
    NormalizedLandmark a,
    NormalizedLandmark b,
    NormalizedLandmark c,
  ) {
    final ux = a.x - b.x;
    final uy = a.y - b.y;
    final vx = c.x - b.x;
    final vy = c.y - b.y;
    final magU = math.sqrt(ux * ux + uy * uy);
    final magV = math.sqrt(vx * vx + vy * vy);
    if (magU < 1e-5 || magV < 1e-5) return 180.0;
    final cosTheta = ((ux * vx + uy * vy) / (magU * magV)).clamp(-1.0, 1.0);
    return math.acos(cosTheta) * 180.0 / math.pi;
  }

  static _HandFeatures _extractFeatures(HandSkeleton hand) {
    final lm = hand.landmarks;
    final palmSize = math.max(_dist(lm[0], lm[9]), 0.05);

    bool isFingerExtended(int mcp, int pip, int dip, int tip) {
      final tipDist = _dist(lm[0], lm[tip]);
      final pipDist = _dist(lm[0], lm[pip]);
      final mcpDist = _dist(lm[0], lm[mcp]);
      final angle = _angleDeg(lm[mcp], lm[pip], lm[tip]);
      return tipDist > pipDist * 1.08 && tipDist > mcpDist * 1.22 && angle > 132.0;
    }

    bool isFingerSemiCurled(int mcp, int pip, int dip, int tip) {
      final tipDist = _dist(lm[0], lm[tip]);
      final mcpDist = _dist(lm[0], lm[mcp]);
      final angle = _angleDeg(lm[mcp], lm[pip], lm[tip]);
      return tipDist > mcpDist * 0.90 && angle >= 95.0 && angle <= 145.0;
    }

    final indexExt = isFingerExtended(5, 6, 7, 8);
    final middleExt = isFingerExtended(9, 10, 11, 12);
    final ringExt = isFingerExtended(13, 14, 15, 16);
    final pinkyExt = isFingerExtended(17, 18, 19, 20);

    final indexSemi = isFingerSemiCurled(5, 6, 7, 8);
    final middleSemi = isFingerSemiCurled(9, 10, 11, 12);
    final ringSemi = isFingerSemiCurled(13, 14, 15, 16);
    final pinkySemi = isFingerSemiCurled(17, 18, 19, 20);

    final thumbToIndexMcp = _dist(lm[4], lm[5]) / palmSize;
    final thumbToMiddleMcp = _dist(lm[4], lm[9]) / palmSize;
    final thumbAngle = _angleDeg(lm[1], lm[2], lm[4]);
    final thumbOut =
        thumbToIndexMcp > 0.62 && thumbToMiddleMcp > 0.68 && thumbAngle > 135.0;

    final pinchIndex = _dist(lm[4], lm[8]) / palmSize;
    final pinchMiddle = _dist(lm[4], lm[12]) / palmSize;
    final indexMiddleSpread = _dist(lm[8], lm[12]) / palmSize;

    final dx = lm[9].x - lm[0].x;
    final dy = lm[9].y - lm[0].y;
    final isHorizontal = dx.abs() > dy.abs() * 1.15;
    final isPointingDown = dy > 0.18 && dy.abs() > dx.abs();

    int extendedCount = 0;
    if (indexExt) extendedCount++;
    if (middleExt) extendedCount++;
    if (ringExt) extendedCount++;
    if (pinkyExt) extendedCount++;

    return _HandFeatures(
      lm: lm,
      palmSize: palmSize,
      indexExt: indexExt,
      middleExt: middleExt,
      ringExt: ringExt,
      pinkyExt: pinkyExt,
      indexSemi: indexSemi,
      middleSemi: middleSemi,
      ringSemi: ringSemi,
      pinkySemi: pinkySemi,
      thumbOut: thumbOut,
      pinchIndex: pinchIndex,
      pinchMiddle: pinchMiddle,
      indexMiddleSpread: indexMiddleSpread,
      isHorizontal: isHorizontal,
      isPointingDown: isPointingDown,
      extendedCount: extendedCount,
    );
  }

  static Gesture classifyHands(List<HandSkeleton> hands) {
    final validHands =
        hands.where((h) => h.landmarks.length >= 21).toList();
    if (validHands.isEmpty) {
      return const Gesture(label: '', confidence: 0.0);
    }

    // 1. Two-Hand BISINDO Gesture Rules
    if (validHands.length >= 2) {
      final f1 = _extractFeatures(validHands[0]);
      final f2 = _extractFeatures(validHands[1]);
      final avgPalm = (f1.palmSize + f2.palmSize) / 2.0;

      final indexTipsDist = _dist(f1.lm[8], f2.lm[8]) / avgPalm;
      final thumbTipsDist = _dist(f1.lm[4], f2.lm[4]) / avgPalm;
      final indexPipsDist = _dist(f1.lm[6], f2.lm[6]) / avgPalm;
      final palmsDist = _dist(f1.lm[9], f2.lm[9]) / avgPalm;

      // BISINDO A: Triangle formed by both hands' index & thumb touching
      if (indexTipsDist < 0.75 && thumbTipsDist < 0.95) {
        return const Gesture(label: 'A', confidence: 0.95);
      }

      // BISINDO X: Two index fingers crossed
      if (f1.extendedCount == 1 &&
          f2.extendedCount == 1 &&
          f1.indexExt &&
          f2.indexExt &&
          indexPipsDist < 0.85) {
        return const Gesture(label: 'X', confidence: 0.94);
      }

      // BISINDO T: One vertical index and one horizontal index/hand on top
      if ((f1.indexExt && f2.isHorizontal) || (f2.indexExt && f1.isHorizontal)) {
        return const Gesture(label: 'T', confidence: 0.93);
      }

      // BISINDO G: Two fists stacked/touching
      if (f1.extendedCount == 0 && f2.extendedCount == 0 && palmsDist < 1.6) {
        return const Gesture(label: 'G', confidence: 0.92);
      }

      // BISINDO H: Both hands with index+middle extended crossing
      if (f1.indexExt &&
          f1.middleExt &&
          !f1.ringExt &&
          f2.indexExt &&
          f2.middleExt &&
          !f2.ringExt) {
        return const Gesture(label: 'H', confidence: 0.93);
      }

      // BISINDO M: 3 fingers of one hand against palm of other hand
      if ((f1.extendedCount == 3 && !f1.pinkyExt) ||
          (f2.extendedCount == 3 && !f2.pinkyExt)) {
        return const Gesture(label: 'M', confidence: 0.92);
      }

      // BISINDO N: 2 fingers of one hand against flat palm of other hand
      if ((f1.extendedCount == 2 && f1.indexExt && f1.middleExt && f2.extendedCount >= 3) ||
          (f2.extendedCount == 2 && f2.indexExt && f2.middleExt && f1.extendedCount >= 3)) {
        return const Gesture(label: 'N', confidence: 0.92);
      }

      // BISINDO B: One hand flat vertical (4 fingers) + other hand curved next to it
      if (f1.extendedCount == 4 || f2.extendedCount == 4) {
        return const Gesture(label: 'B', confidence: 0.93);
      }

      // BISINDO D / P: One hand vertical index, other hand C-shape
      if ((f1.extendedCount == 1 && f1.indexExt) ||
          (f2.extendedCount == 1 && f2.indexExt)) {
        return const Gesture(label: 'D', confidence: 0.91);
      }

      // BISINDO K: Both hands thumb+index extended meeting
      if (f1.thumbOut && f2.thumbOut) {
        return const Gesture(label: 'K', confidence: 0.90);
      }
    }

    // 2. Single-Hand BISINDO Gesture Rules
    final f = _extractFeatures(validHands[0]);
    final lm = f.lm;

    // F: Thumb and index tips pinched together, while middle, ring, pinky are extended up
    if (f.pinchIndex < 0.45 && f.middleExt && f.ringExt && f.pinkyExt) {
      return const Gesture(label: 'F', confidence: 0.95);
    }

    // O: Thumb tip touching index/middle tips forming an O circle, ring/pinky not straight up
    if (f.pinchIndex < 0.48 && f.pinchMiddle < 0.58 && !f.ringExt && !f.pinkyExt) {
      return const Gesture(label: 'O', confidence: 0.94);
    }

    // L: Thumb extended sideways AND only index extended up
    if (f.thumbOut && f.indexExt && !f.middleExt && !f.ringExt && !f.pinkyExt) {
      if (f.isPointingDown) {
        return const Gesture(label: 'Q', confidence: 0.91);
      }
      if (f.isHorizontal) {
        return const Gesture(label: 'G', confidence: 0.92);
      }
      return const Gesture(label: 'L', confidence: 0.96);
    }

    // Y: Thumb AND pinky extended out, middle 3 fingers curled
    if (f.thumbOut && f.pinkyExt && !f.indexExt && !f.middleExt && !f.ringExt) {
      return const Gesture(label: 'Y', confidence: 0.95);
    }

    // I vs J: Only pinky extended
    if (f.pinkyExt && !f.indexExt && !f.middleExt && !f.ringExt && !f.thumbOut) {
      final pinkyDx = (lm[20].x - lm[17].x).abs();
      final pinkyDy = (lm[20].y - lm[17].y).abs();
      if (pinkyDx > pinkyDy * 0.55) {
        return const Gesture(label: 'J', confidence: 0.91);
      }
      return const Gesture(label: 'I', confidence: 0.95);
    }

    // W: Index, middle, ring extended up, pinky curled
    if (f.indexExt && f.middleExt && f.ringExt && !f.pinkyExt) {
      return const Gesture(label: 'W', confidence: 0.95);
    }

    // 4 Fingers Extended (Index, Middle, Ring, Pinky) -> B or C
    if (f.indexExt && f.middleExt && f.ringExt && f.pinkyExt) {
      final fingersSpread = _dist(lm[8], lm[20]) / f.palmSize;
      // If thumb is extended out to the side and fingers are held close/tilted in a C-jaw
      if (f.thumbOut && fingersSpread < 0.95 && f.pinchIndex < 1.28) {
        return const Gesture(label: 'C', confidence: 0.93);
      }
      return const Gesture(label: 'B', confidence: 0.94);
    }

    // C: Curved fingers with thumb open forming a C arc
    final semiCount =
        (f.indexSemi ? 1 : 0) +
        (f.middleSemi ? 1 : 0) +
        (f.ringSemi ? 1 : 0) +
        (f.pinkySemi ? 1 : 0);
    if (semiCount >= 2 && f.pinchIndex >= 0.45 && f.pinchIndex <= 1.35) {
      if (f.thumbOut || _dist(lm[4], lm[5]) / f.palmSize > 0.48) {
        return const Gesture(label: 'C', confidence: 0.93);
      }
      return const Gesture(label: 'E', confidence: 0.90);
    }

    // 2 Fingers Extended (Index & Middle) -> U, V, R, K, H, P
    if (f.indexExt && f.middleExt && !f.ringExt && !f.pinkyExt) {
      if (f.isPointingDown) {
        return const Gesture(label: 'P', confidence: 0.92);
      }
      if (f.isHorizontal) {
        return const Gesture(label: 'H', confidence: 0.93);
      }
      // Check if index and middle cross each other (R)
      final mcpDeltaX = lm[5].x - lm[9].x;
      final tipDeltaX = lm[8].x - lm[12].x;
      if (mcpDeltaX * tipDeltaX < 0 || f.indexMiddleSpread < 0.16) {
        return const Gesture(label: 'R', confidence: 0.92);
      }
      if (f.thumbOut && lm[4].y < lm[5].y) {
        return const Gesture(label: 'K', confidence: 0.92);
      }
      if (f.indexMiddleSpread >= 0.27) {
        return const Gesture(label: 'V', confidence: 0.95);
      }
      return const Gesture(label: 'U', confidence: 0.94);
    }

    // 1 Finger (Index Only) -> D, G, Q, Z
    if (f.indexExt && !f.middleExt && !f.ringExt && !f.pinkyExt && !f.thumbOut) {
      if (f.isPointingDown) {
        return const Gesture(label: 'Q', confidence: 0.91);
      }
      if (f.isHorizontal) {
        return const Gesture(label: 'G', confidence: 0.92);
      }
      final indexTilt = (lm[8].x - lm[5].x).abs() / f.palmSize;
      if (indexTilt > 0.36) {
        return const Gesture(label: 'Z', confidence: 0.90);
      }
      return const Gesture(label: 'D', confidence: 0.94);
    }

    // X: Index semi-curled/hooked, other fingers curled
    if (f.indexSemi && !f.middleExt && !f.ringExt && !f.pinkyExt) {
      return const Gesture(label: 'X', confidence: 0.91);
    }

    // Fist / Closed Hand Variations -> A, S, T, M, N, E
    if (f.extendedCount == 0) {
      // A: Thumb upright alongside index MCP/PIP
      if (lm[4].y < lm[6].y && _dist(lm[4], lm[6]) / f.palmSize < 0.65) {
        return const Gesture(label: 'A', confidence: 0.93);
      }
      // T: Thumb tip tucked between index and middle
      if (_dist(lm[4], lm[6]) / f.palmSize < 0.36 &&
          _dist(lm[4], lm[10]) / f.palmSize < 0.38) {
        return const Gesture(label: 'T', confidence: 0.90);
      }
      // M: Thumb reaching across toward ring/pinky
      if (_dist(lm[4], lm[14]) / f.palmSize < 0.45) {
        return const Gesture(label: 'M', confidence: 0.89);
      }
      // N: Thumb near middle finger PIP
      if (_dist(lm[4], lm[10]) / f.palmSize < 0.42) {
        return const Gesture(label: 'N', confidence: 0.90);
      }
      return const Gesture(label: 'S', confidence: 0.91);
    }

    return const Gesture(label: 'C', confidence: 0.86);
  }
}

class _HandFeatures {
  final List<NormalizedLandmark> lm;
  final double palmSize;
  final bool indexExt;
  final bool middleExt;
  final bool ringExt;
  final bool pinkyExt;
  final bool indexSemi;
  final bool middleSemi;
  final bool ringSemi;
  final bool pinkySemi;
  final bool thumbOut;
  final double pinchIndex;
  final double pinchMiddle;
  final double indexMiddleSpread;
  final bool isHorizontal;
  final bool isPointingDown;
  final int extendedCount;

  const _HandFeatures({
    required this.lm,
    required this.palmSize,
    required this.indexExt,
    required this.middleExt,
    required this.ringExt,
    required this.pinkyExt,
    required this.indexSemi,
    required this.middleSemi,
    required this.ringSemi,
    required this.pinkySemi,
    required this.thumbOut,
    required this.pinchIndex,
    required this.pinchMiddle,
    required this.indexMiddleSpread,
    required this.isHorizontal,
    required this.isPointingDown,
    required this.extendedCount,
  });
}

