import 'dart:math' as math;
import '../../domain/entities/gesture.dart';
import '../../domain/entities/hand_landmarks.dart';

/// High-Precision 21-Landmark BISINDO (Indonesian Sign Language) Classifier.
/// Calibrated against the 26-class BISINDO Alphabet Dataset (1-hand & 2-hand poses)
/// with strict rejection of invalid/ambiguous hand poses.
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

  /// Checks if 2D line segment (p1 -> p2) intersects (p3 -> p4).
  static bool _segmentsIntersect(
    NormalizedLandmark p1,
    NormalizedLandmark p2,
    NormalizedLandmark p3,
    NormalizedLandmark p4,
  ) {
    double ccw(
      NormalizedLandmark a,
      NormalizedLandmark b,
      NormalizedLandmark c,
    ) {
      return (b.x - a.x) * (c.y - a.y) - (b.y - a.y) * (c.x - a.x);
    }

    final d1 = ccw(p3, p4, p1);
    final d2 = ccw(p3, p4, p2);
    final d3 = ccw(p1, p2, p3);
    final d4 = ccw(p1, p2, p4);

    if (((d1 > 0 && d2 < 0) || (d1 < 0 && d2 > 0)) &&
        ((d3 > 0 && d4 < 0) || (d3 < 0 && d4 > 0))) {
      return true;
    }
    return false;
  }

  static _HandFeatures _extractFeatures(HandSkeleton hand) {
    final lm = hand.landmarks;
    final palmSize = math.max(_dist(lm[0], lm[9]), 0.05);

    bool isFingerExtended(int mcp, int pip, int dip, int tip) {
      final tipDist = _dist(lm[0], lm[tip]);
      final pipDist = _dist(lm[0], lm[pip]);
      final mcpDist = _dist(lm[0], lm[mcp]);
      final angle1 = _angleDeg(lm[mcp], lm[pip], lm[dip]);
      final angle2 = _angleDeg(lm[pip], lm[dip], lm[tip]);
      return tipDist > pipDist * 1.10 &&
          tipDist > mcpDist * 1.25 &&
          angle1 > 138.0 &&
          angle2 > 135.0;
    }

    bool isFingerSemiCurled(int mcp, int pip, int dip, int tip) {
      final tipDist = _dist(lm[0], lm[tip]);
      final mcpDist = _dist(lm[0], lm[mcp]);
      final angle = _angleDeg(lm[mcp], lm[pip], lm[tip]);
      return tipDist > mcpDist * 0.92 && angle >= 95.0 && angle <= 145.0;
    }

    bool isFingerCurled(int mcp, int pip, int dip, int tip) {
      final tipDist = _dist(lm[0], lm[tip]);
      final pipDist = _dist(lm[0], lm[pip]);
      final angle = _angleDeg(lm[mcp], lm[pip], lm[tip]);
      return tipDist < pipDist * 1.04 || angle < 95.0;
    }

    final indexExt = isFingerExtended(5, 6, 7, 8);
    final middleExt = isFingerExtended(9, 10, 11, 12);
    final ringExt = isFingerExtended(13, 14, 15, 16);
    final pinkyExt = isFingerExtended(17, 18, 19, 20);

    final indexSemi = !indexExt && isFingerSemiCurled(5, 6, 7, 8);
    final middleSemi = !middleExt && isFingerSemiCurled(9, 10, 11, 12);
    final ringSemi = !ringExt && isFingerSemiCurled(13, 14, 15, 16);
    final pinkySemi = !pinkyExt && isFingerSemiCurled(17, 18, 19, 20);

    final indexCurled = isFingerCurled(5, 6, 7, 8);
    final middleCurled = isFingerCurled(9, 10, 11, 12);
    final ringCurled = isFingerCurled(13, 14, 15, 16);
    final pinkyCurled = isFingerCurled(17, 18, 19, 20);

    final thumbToIndexMcp = _dist(lm[4], lm[5]) / palmSize;
    final thumbToMiddleMcp = _dist(lm[4], lm[9]) / palmSize;
    final thumbAngle = _angleDeg(lm[1], lm[2], lm[4]);
    final thumbOut =
        thumbToIndexMcp > 0.45 && thumbToMiddleMcp > 0.50 && thumbAngle > 135.0;

    final pinchIndex = _dist(lm[4], lm[8]) / palmSize;
    final pinchMiddle = _dist(lm[4], lm[12]) / palmSize;
    final indexMiddleSpread = _dist(lm[8], lm[12]) / palmSize;

    // Orientation using wrist (0) to middle MCP (9) and index finger vector (5 -> 8)
    final dx = lm[9].x - lm[0].x;
    final dy = lm[9].y - lm[0].y;
    final idxDx = lm[8].x - lm[5].x;
    final idxDy = lm[8].y - lm[5].y;

    final isHorizontal =
        dx.abs() > dy.abs() * 1.18 || (indexExt && idxDx.abs() > idxDy.abs() * 1.35);
    final isPointingDown = dy > 0.22 && dy.abs() > dx.abs();

    int extendedCount = 0;
    if (indexExt) extendedCount++;
    if (middleExt) extendedCount++;
    if (ringExt) extendedCount++;
    if (pinkyExt) extendedCount++;

    int curledCount = 0;
    if (indexCurled) curledCount++;
    if (middleCurled) curledCount++;
    if (ringCurled) curledCount++;
    if (pinkyCurled) curledCount++;

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
      indexCurled: indexCurled,
      middleCurled: middleCurled,
      ringCurled: ringCurled,
      pinkyCurled: pinkyCurled,
      thumbOut: thumbOut,
      pinchIndex: pinchIndex,
      pinchMiddle: pinchMiddle,
      indexMiddleSpread: indexMiddleSpread,
      isHorizontal: isHorizontal,
      isPointingDown: isPointingDown,
      extendedCount: extendedCount,
      curledCount: curledCount,
    );
  }

  static Gesture classifyHands(List<HandSkeleton> hands) {
    final validHands = hands.where((h) => h.landmarks.length >= 21).toList();
    if (validHands.isEmpty) {
      return const Gesture(label: '', confidence: 0.0);
    }

    // =========================================================================
    // 1. TWO-HAND BISINDO ALPHABET RULES (A, B, D, F, G, H, K, M, N, P, Q, S, T, W, X, Y)
    // =========================================================================
    if (validHands.length >= 2) {
      // Sort left-to-right on screen for consistent geometry checks
      final sorted = [...validHands]
        ..sort((a, b) => a.landmarks[0].x.compareTo(b.landmarks[0].x));
      final f1 = _extractFeatures(sorted[0]); // Left side of screen
      final f2 = _extractFeatures(sorted[1]); // Right side of screen
      final avgPalm = (f1.palmSize + f2.palmSize) / 2.0;

      final dIndexTips = _dist(f1.lm[8], f2.lm[8]) / avgPalm;
      final dIndexDips = _dist(f1.lm[7], f2.lm[7]) / avgPalm;
      final dIndexPips = _dist(f1.lm[6], f2.lm[6]) / avgPalm;
      final dThumbTips = _dist(f1.lm[4], f2.lm[4]) / avgPalm;
      final dPalms = _dist(f1.lm[9], f2.lm[9]) / avgPalm;

      final bothOnlyIndex = (f1.indexExt || f1.indexSemi) &&
          !f1.middleExt &&
          !f1.ringExt &&
          !f1.pinkyExt &&
          (f2.indexExt || f2.indexSemi) &&
          !f2.middleExt &&
          !f2.ringExt &&
          !f2.pinkyExt;

      // 1a. BISINDO X vs BISINDO T vs BISINDO A vs BISINDO W vs BISINDO H (when both hands use index finger)
      if (bothOnlyIndex) {
        // BISINDO T: One vertical index and one horizontal index resting on its top tip
        if ((f1.isHorizontal && !f2.isHorizontal) ||
            (!f1.isHorizontal && f2.isHorizontal)) {
          final vert = f1.isHorizontal ? f2 : f1;
          final horiz = f1.isHorizontal ? f1 : f2;
          final distTipToHoriz = math.min(
            _dist(vert.lm[8], horiz.lm[8]),
            math.min(
              _dist(vert.lm[8], horiz.lm[7]),
              _dist(vert.lm[8], horiz.lm[6]),
            ),
          ) / avgPalm;
          if (distTipToHoriz < 0.85) {
            return const Gesture(label: 'T', confidence: 0.94);
          }
        }

        final indexSegmentsCross = _segmentsIntersect(
          f1.lm[5],
          f1.lm[8],
          f2.lm[5],
          f2.lm[8],
        );
        // Tips crossed horizontally past each other (left hand tip is to the right of right hand tip)
        final tipsCrossedHorizontally =
            f1.lm[8].x >= f2.lm[8].x - 0.03 * avgPalm;
        // Both index fingers angled inward toward each other (/ and \)
        final angledInward = (f1.lm[8].x - f1.lm[5].x) > 0.04 * avgPalm &&
            (f2.lm[5].x - f2.lm[8].x) > 0.04 * avgPalm;
        // Shafts (DIP/PIP) are close
        final shaftsClose =
            (dIndexDips < 0.72 || dIndexPips < 0.82) &&
            (dIndexDips <= dIndexTips * 1.15 || dIndexPips <= dIndexTips * 1.20);

        // Check BISINDO A first if both thumbs are extended out forming the base of triangle
        final avgIndexTipY = (f1.lm[8].y + f2.lm[8].y) / 2.0;
        final avgThumbTipY = (f1.lm[4].y + f2.lm[4].y) / 2.0;
        final thumbsBelowIndexTips =
            (avgThumbTipY - avgIndexTipY) > 0.20 * avgPalm;
        if (f1.thumbOut &&
            f2.thumbOut &&
            !indexSegmentsCross &&
            dIndexTips < 0.65 &&
            dIndexTips < dIndexPips &&
            dThumbTips < 0.72 &&
            thumbsBelowIndexTips) {
          return const Gesture(label: 'A', confidence: 0.95);
        }

        // BISINDO X: Two index fingers crossed in an X (thumbs tucked in fists, or shafts/segments crossed)
        if (indexSegmentsCross ||
            (tipsCrossedHorizontally && (dIndexDips < 0.85 || dIndexPips < 0.90)) ||
            (shaftsClose && dThumbTips > 0.65 && (!f1.thumbOut || !f2.thumbOut)) ||
            (angledInward &&
                (!f1.thumbOut || !f2.thumbOut) &&
                (dIndexTips < 0.65 || dIndexDips < 0.72))) {
          return const Gesture(label: 'X', confidence: 0.95);
        }

        // BISINDO W (2-hand L-shapes touching at thumbs in center /\/\)
        if (f1.thumbOut &&
            f2.thumbOut &&
            dThumbTips < 0.68 &&
            dIndexTips >= 0.65) {
          return const Gesture(label: 'W', confidence: 0.94);
        }

        // BISINDO H: Two parallel vertical index posts with thumb crossbar (|-|)
        if (!f1.isHorizontal &&
            !f2.isHorizontal &&
            dIndexTips >= 0.40 &&
            dIndexTips < 1.60 &&
            (f1.thumbOut || f2.thumbOut)) {
          return const Gesture(label: 'H', confidence: 0.93);
        }
      }

      // 1b. BISINDO M & N: Base hand open palm (4 fingers), second hand places 3 (M) or 2 (N) fingers on it
      if ((f1.extendedCount >= 3 && !f1.isHorizontal) ||
          (f2.extendedCount >= 3 && !f2.isHorizontal)) {
        final base = (f1.extendedCount >= f2.extendedCount) ? f1 : f2;
        final overlay = (base == f1) ? f2 : f1;
        final overlayToBaseDist = _dist(overlay.lm[8], base.lm[9]) / avgPalm;

        if (base.extendedCount >= 3 && overlayToBaseDist < 1.35) {
          if (overlay.extendedCount == 3 && !overlay.pinkyExt) {
            return const Gesture(label: 'M', confidence: 0.93);
          }
          if (overlay.extendedCount == 2 &&
              overlay.indexExt &&
              overlay.middleExt &&
              !overlay.ringExt &&
              !overlay.pinkyExt) {
            return const Gesture(label: 'N', confidence: 0.93);
          }
        }
      }

      // 1c. Vertical Index Post + Modifier Hand (B, F, K, D, P, Y)
      final f1IsPost =
          f1.extendedCount == 1 && f1.indexExt && !f1.isHorizontal;
      final f2IsPost =
          f2.extendedCount == 1 && f2.indexExt && !f2.isHorizontal;

      if (f1IsPost || f2IsPost) {
        final post = f1IsPost ? f1 : f2;
        final mod = f1IsPost ? f2 : f1;
        final modToPostDist = _dist(mod.lm[8], post.lm[6]) / avgPalm;

        if (modToPostDist < 1.45) {
          // BISINDO B: 3 or 4 horizontal fingers against vertical index post
          if (mod.isHorizontal && mod.extendedCount >= 3) {
            return const Gesture(label: 'B', confidence: 0.94);
          }
          // BISINDO F: 2 horizontal fingers (index + middle) across vertical index post
          if (mod.isHorizontal &&
              mod.extendedCount == 2 &&
              mod.indexExt &&
              mod.middleExt) {
            return const Gesture(label: 'F', confidence: 0.93);
          }
          // BISINDO K: 2 angled fingers (index + middle) touching middle of vertical post
          if (!mod.isHorizontal &&
              mod.extendedCount == 2 &&
              mod.indexExt &&
              mod.middleExt) {
            // If post touches bottom of V -> Y, if V touches side of post -> K
            if (post.lm[8].y > mod.lm[5].y) {
              return const Gesture(label: 'Y', confidence: 0.92);
            }
            return const Gesture(label: 'K', confidence: 0.92);
          }
          // BISINDO P vs D: Modifier hand forms a C/loop against vertical post
          if (mod.pinchIndex >= 0.35 &&
              mod.pinchIndex <= 1.25 &&
              !mod.ringExt &&
              !mod.pinkyExt) {
            final modHigherThanPost =
                mod.lm[0].y < post.lm[0].y - 0.14 * avgPalm;
            if (modHigherThanPost) {
              return const Gesture(label: 'P', confidence: 0.93);
            }
            return const Gesture(label: 'D', confidence: 0.93);
          }
        }
      }

      // 1d. BISINDO W (both hands showing 2-finger V side-by-side)
      if (f1.extendedCount == 2 &&
          f1.indexExt &&
          f1.middleExt &&
          f2.extendedCount == 2 &&
          f2.indexExt &&
          f2.middleExt &&
          dIndexTips < 0.85) {
        return const Gesture(label: 'W', confidence: 0.94);
      }

      // 1e. BISINDO Q: One hand forms O circle, other hand index pokes near it
      if ((f1.pinchIndex < 0.48 && f2.indexExt && f2.extendedCount == 1) ||
          (f2.pinchIndex < 0.48 && f1.indexExt && f1.extendedCount == 1)) {
        if (dIndexTips < 0.90) {
          return const Gesture(label: 'Q', confidence: 0.92);
        }
      }

      // 1f. BISINDO G: Two closed fists stacked vertically
      if (f1.extendedCount == 0 &&
          f1.curledCount >= 3 &&
          f2.extendedCount == 0 &&
          f2.curledCount >= 3 &&
          !f1.thumbOut &&
          !f2.thumbOut &&
          dPalms < 1.45 &&
          (f1.lm[9].y - f2.lm[9].y).abs() > 0.35 * avgPalm) {
        return const Gesture(label: 'G', confidence: 0.93);
      }

      // 1g. BISINDO S: Two C/hook hands stacked in opposite directions
      if (f1.extendedCount <= 1 &&
          f2.extendedCount <= 1 &&
          f1.pinchIndex >= 0.40 &&
          f1.pinchIndex <= 1.15 &&
          f2.pinchIndex >= 0.40 &&
          f2.pinchIndex <= 1.15 &&
          dIndexTips < 0.95) {
        return const Gesture(label: 'S', confidence: 0.91);
      }

      // If 2 hands are visible but do not match any valid 2-hand BISINDO sign, reject!
      return const Gesture(label: '', confidence: 0.0);
    }

    // =========================================================================
    // 2. SINGLE-HAND BISINDO ALPHABET RULES (Strict matching, no catch-all)
    // =========================================================================
    final f = _extractFeatures(validHands[0]);
    final lm = f.lm;

    // 2a. F (1-hand OK sign): Thumb & index tips pinched, middle + ring + pinky strictly extended
    if (f.pinchIndex < 0.38 && f.middleExt && f.ringExt && f.pinkyExt) {
      return const Gesture(label: 'F', confidence: 0.94);
    }

    // 2b. O: Thumb tip touching index & middle tips forming a closed O circle, ring & pinky not extended
    if (f.pinchIndex < 0.42 &&
        f.pinchMiddle < 0.52 &&
        !f.indexExt &&
        !f.middleExt &&
        !f.ringExt &&
        !f.pinkyExt) {
      return const Gesture(label: 'O', confidence: 0.94);
    }

    // 2c. L: Thumb strictly extended sideways AND ONLY index finger strictly extended upright
    if (f.thumbOut &&
        f.indexExt &&
        !f.middleExt &&
        !f.ringExt &&
        !f.pinkyExt &&
        f.middleCurled &&
        f.ringCurled &&
        f.pinkyCurled &&
        !f.isHorizontal &&
        !f.isPointingDown) {
      return const Gesture(label: 'L', confidence: 0.96);
    }

    // 2d. Y: Thumb AND pinky strictly extended, while index, middle, ring are curled
    if (f.thumbOut &&
        f.pinkyExt &&
        !f.indexExt &&
        !f.middleExt &&
        !f.ringExt &&
        f.indexCurled &&
        f.middleCurled &&
        f.ringCurled) {
      return const Gesture(label: 'Y', confidence: 0.95);
    }

    // 2e. BISINDO U (Dataset pose: Index + Pinky extended upright, middle & ring curled)
    if (f.indexExt &&
        f.pinkyExt &&
        !f.middleExt &&
        !f.ringExt &&
        f.middleCurled &&
        f.ringCurled &&
        !f.isHorizontal) {
      return const Gesture(label: 'U', confidence: 0.95);
    }

    // 2f. I vs J: ONLY Pinky extended, index + middle + ring curled, thumb tucked
    if (f.pinkyExt &&
        !f.indexExt &&
        !f.middleExt &&
        !f.ringExt &&
        f.indexCurled &&
        f.middleCurled &&
        f.ringCurled &&
        !f.thumbOut) {
      final pinkyDx = (lm[20].x - lm[17].x).abs();
      final pinkyDy = (lm[20].y - lm[17].y).abs();
      if (pinkyDx > pinkyDy * 0.58) {
        return const Gesture(label: 'J', confidence: 0.92);
      }
      return const Gesture(label: 'I', confidence: 0.95);
    }

    // 2g. E (Dataset pose: 3 fingers Index, Middle, Ring extended HORIZONTALLY, Pinky curled)
    //     vs W (3 fingers Index, Middle, Ring extended UPRIGHT, Pinky curled)
    if (f.indexExt &&
        f.middleExt &&
        f.ringExt &&
        !f.pinkyExt &&
        f.pinkyCurled) {
      if (f.isHorizontal) {
        return const Gesture(label: 'E', confidence: 0.94);
      }
      return const Gesture(label: 'W', confidence: 0.94);
    }

    // 2h. C: Curved arc of fingers (semi-curled) with open C-gap between thumb and index tip
    final semiCount = (f.indexSemi ? 1 : 0) +
        (f.middleSemi ? 1 : 0) +
        (f.ringSemi ? 1 : 0) +
        (f.pinkySemi ? 1 : 0);
    final curveCount = (f.indexSemi || f.indexCurled ? 1 : 0) +
        (f.middleSemi || f.middleCurled ? 1 : 0) +
        (f.ringSemi || f.ringCurled ? 1 : 0) +
        (f.pinkySemi || f.pinkyCurled ? 1 : 0);
    if ((semiCount >= 2 || curveCount >= 3) &&
        f.extendedCount <= 1 &&
        f.pinchIndex >= 0.35 &&
        f.pinchIndex <= 1.35 &&
        _dist(lm[4], lm[5]) / f.palmSize > 0.40 &&
        !f.isPointingDown) {
      return const Gesture(label: 'C', confidence: 0.93);
    }

    // 2i. 2 Fingers Extended Upright (Index & Middle, while Ring & Pinky are curled) -> R, K, V, U
    if (f.indexExt &&
        f.middleExt &&
        !f.ringExt &&
        !f.pinkyExt &&
        f.ringCurled &&
        f.pinkyCurled &&
        !f.isHorizontal &&
        !f.isPointingDown) {
      final mcpDeltaX = lm[5].x - lm[9].x;
      final tipDeltaX = lm[8].x - lm[12].x;
      if (mcpDeltaX * tipDeltaX < 0 || f.indexMiddleSpread < 0.15) {
        return const Gesture(label: 'R', confidence: 0.92);
      }
      if (f.indexMiddleSpread >= 0.25 &&
          f.thumbOut &&
          _dist(lm[4], lm[6]) / f.palmSize < 0.65) {
        return const Gesture(label: 'K', confidence: 0.92);
      }
      if (f.indexMiddleSpread >= 0.28) {
        return const Gesture(label: 'V', confidence: 0.95);
      }
      return const Gesture(label: 'U', confidence: 0.93);
    }

    // 2j. B (1-hand): All 4 fingers straight up AND held tightly together, WITH thumb strictly tucked across palm
    //     (Note: A normal waving/open 5-finger hand has thumbOut == true or spread fingers and is rejected!)
    if (!f.isHorizontal &&
        !f.isPointingDown &&
        f.indexExt &&
        f.middleExt &&
        f.ringExt &&
        f.pinkyExt &&
        !f.thumbOut) {
      final fourFingerSpread = _dist(lm[8], lm[20]) / f.palmSize;
      if (fourFingerSpread < 0.78 && _dist(lm[4], lm[13]) / f.palmSize < 0.65) {
        return const Gesture(label: 'B', confidence: 0.92);
      }
    }

    // 2k. Z (Dataset pose: Flat horizontal hand bent at wrist)
    if (f.isHorizontal &&
        f.indexExt &&
        f.middleExt &&
        f.ringExt &&
        f.pinkyExt &&
        !f.thumbOut) {
      return const Gesture(label: 'Z', confidence: 0.91);
    }

    // 2l. D (1-hand): ONLY Index extended straight up, thumb touching middle finger, other 3 curled
    if (!f.isHorizontal &&
        !f.isPointingDown &&
        f.indexExt &&
        !f.middleExt &&
        !f.ringExt &&
        !f.pinkyExt &&
        f.middleCurled &&
        f.ringCurled &&
        f.pinkyCurled &&
        !f.thumbOut &&
        f.pinchMiddle < 0.50) {
      return const Gesture(label: 'D', confidence: 0.92);
    }

    // 2m. X (1-hand): ONLY Index finger hooked/semi-curled, other 3 fingers tightly curled, thumb tucked
    if (!f.isHorizontal &&
        !f.isPointingDown &&
        f.indexSemi &&
        !f.indexExt &&
        !f.middleExt &&
        !f.ringExt &&
        !f.pinkyExt &&
        f.middleCurled &&
        f.ringCurled &&
        f.pinkyCurled &&
        !f.thumbOut &&
        f.pinchIndex >= 0.45) {
      return const Gesture(label: 'X', confidence: 0.93);
    }

    // 2n. H vs G (1-hand horizontal):
    if (f.isHorizontal &&
        !f.isPointingDown &&
        !f.ringExt &&
        !f.pinkyExt &&
        f.ringCurled &&
        f.pinkyCurled) {
      if (f.indexExt && f.middleExt) {
        return const Gesture(label: 'H', confidence: 0.92);
      }
      if (f.indexExt && !f.middleExt && f.middleCurled) {
        return const Gesture(label: 'G', confidence: 0.92);
      }
    }

    // 2o. P vs Q (1-hand pointing down):
    if (f.isPointingDown &&
        !f.ringExt &&
        !f.pinkyExt &&
        f.ringCurled &&
        f.pinkyCurled) {
      if (f.indexExt && f.middleExt) {
        return const Gesture(label: 'P', confidence: 0.91);
      }
      if (f.indexExt && !f.middleExt && f.middleCurled) {
        return const Gesture(label: 'Q', confidence: 0.91);
      }
    }

    // Any other pose (neutral open palm, relaxed fist, random finger movement) is strictly rejected!
    return const Gesture(label: '', confidence: 0.0);
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
  final bool indexCurled;
  final bool middleCurled;
  final bool ringCurled;
  final bool pinkyCurled;
  final bool thumbOut;
  final double pinchIndex;
  final double pinchMiddle;
  final double indexMiddleSpread;
  final bool isHorizontal;
  final bool isPointingDown;
  final int extendedCount;
  final int curledCount;

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
    required this.indexCurled,
    required this.middleCurled,
    required this.ringCurled,
    required this.pinkyCurled,
    required this.thumbOut,
    required this.pinchIndex,
    required this.pinchMiddle,
    required this.indexMiddleSpread,
    required this.isHorizontal,
    required this.isPointingDown,
    required this.extendedCount,
    required this.curledCount,
  });
}
