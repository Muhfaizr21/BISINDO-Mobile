import 'dart:math' as math;
import '../../domain/entities/gesture.dart';
import '../../domain/entities/hand_landmarks.dart';

enum BisindoTargetMode {
  alphabet,
  numbers,
}

/// High-Precision 21-Landmark BISINDO (Indonesian Sign Language) Classifier.
/// Strictly synchronized with the 26 BISINDO Alphabet Dataset images (assets/images/bisindo/A.jpg - Z.jpg)
/// and BISINDO Numbers 0-9. Non-letter poses (Thumbs Up, Fist, Open Palm, Single Index) are strictly rejected.
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

  /// Angle (0..180 deg) between vector (a1 -> a2) and vector (b1 -> b2).
  static double _vectorAngleDeg(
    NormalizedLandmark a1,
    NormalizedLandmark a2,
    NormalizedLandmark b1,
    NormalizedLandmark b2,
  ) {
    final ux = a2.x - a1.x;
    final uy = a2.y - a1.y;
    final vx = b2.x - b1.x;
    final vy = b2.y - b1.y;
    final magU = math.sqrt(ux * ux + uy * uy);
    final magV = math.sqrt(vx * vx + vy * vy);
    if (magU < 1e-5 || magV < 1e-5) return 0.0;
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
      return tipDist > pipDist * 1.12 &&
          tipDist > mcpDist * 1.28 &&
          angle1 > 140.0 &&
          angle2 > 138.0;
    }

    bool isFingerSemiCurled(int mcp, int pip, int dip, int tip) {
      final tipDist = _dist(lm[0], lm[tip]);
      final mcpDist = _dist(lm[0], lm[mcp]);
      final tipToMcp = _dist(lm[mcp], lm[tip]) / palmSize;
      final angle = _angleDeg(lm[mcp], lm[pip], lm[tip]);
      return tipDist > mcpDist * 1.05 &&
          tipToMcp > 0.55 &&
          angle >= 100.0 &&
          angle <= 148.0;
    }

    bool isFingerCurled(int mcp, int pip, int dip, int tip) {
      final tipDist = _dist(lm[0], lm[tip]);
      final pipDist = _dist(lm[0], lm[pip]);
      final tipToMcp = _dist(lm[mcp], lm[tip]) / palmSize;
      final angle = _angleDeg(lm[mcp], lm[pip], lm[tip]);
      return tipDist < pipDist * 1.04 || tipToMcp < 0.55 || angle < 100.0;
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

    // Detect Thumbs-Up (Thumb pointing up while 4 fingers are curled)
    final isThumbsUp = extendedCount == 0 &&
        curledCount >= 3 &&
        (lm[4].y < lm[5].y - 0.10 * palmSize || lm[4].y < lm[8].y - 0.12 * palmSize);

    // Detect Closed Fist (All 4 fingers folded into palm)
    final isFist = extendedCount == 0 &&
        curledCount >= 3 &&
        _dist(lm[5], lm[8]) / palmSize < 0.56 &&
        _dist(lm[9], lm[12]) / palmSize < 0.56;

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
      isThumbsUp: isThumbsUp,
      isFist: isFist,
    );
  }

  static Gesture classifyHands(
    List<HandSkeleton> hands, {
    BisindoTargetMode mode = BisindoTargetMode.alphabet,
  }) {
    final validHands = hands.where((h) => h.landmarks.length >= 21).toList();
    if (validHands.isEmpty) {
      return const Gesture(label: '', confidence: 0.0);
    }

    if (mode == BisindoTargetMode.numbers) {
      return _classifyNumbers(validHands);
    }

    return _classifyAlphabet(validHands);
  }

  static Gesture _classifyAlphabet(List<HandSkeleton> validHands) {
    // =========================================================================
    // 1. TWO-HAND BISINDO ALPHABET RULES
    //    Synchronized with Belajar Dataset: A, B, D, F, G, H, K, M, N, P, Q, S, T, W, X, Y
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

      // 1a. BISINDO T, A, X, W, H (when both hands raise only index finger)
      if (bothOnlyIndex) {
        // BISINDO T (T.jpg): One vertical index and one horizontal index resting on its top tip
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
        final tipsCrossedHorizontally =
            f1.lm[8].x >= f2.lm[8].x - 0.03 * avgPalm;
        final angledInward = (f1.lm[8].x - f1.lm[5].x) > 0.04 * avgPalm &&
            (f2.lm[5].x - f2.lm[8].x) > 0.04 * avgPalm;
        final shaftsClose =
            (dIndexDips < 0.72 || dIndexPips < 0.82) &&
            (dIndexDips <= dIndexTips * 1.15 || dIndexPips <= dIndexTips * 1.20);

        // BISINDO A (A.jpg): Both thumbs extended out meeting horizontally at base, index tips meeting at apex
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

        // BISINDO X (X.jpg): Two index fingers crossed in an X
        if (indexSegmentsCross ||
            (tipsCrossedHorizontally && (dIndexDips < 0.85 || dIndexPips < 0.90)) ||
            (shaftsClose && dThumbTips > 0.65 && (!f1.thumbOut || !f2.thumbOut)) ||
            (angledInward &&
                (!f1.thumbOut || !f2.thumbOut) &&
                (dIndexTips < 0.65 || dIndexDips < 0.72))) {
          return const Gesture(label: 'X', confidence: 0.95);
        }

        // BISINDO W (W.jpg): Two L-shaped hands touching at thumb tips in the center (\ / \ /)
        if (f1.thumbOut &&
            f2.thumbOut &&
            dThumbTips < 0.68 &&
            dIndexTips >= 0.65) {
          return const Gesture(label: 'W', confidence: 0.94);
        }

        // BISINDO H (H.jpg): Two parallel vertical index posts with horizontal thumb crossbar (|-|)
        if (!f1.isHorizontal &&
            !f2.isHorizontal &&
            dIndexTips >= 0.40 &&
            dIndexTips < 1.60 &&
            (f1.thumbOut || f2.thumbOut)) {
          return const Gesture(label: 'H', confidence: 0.93);
        }
      }

      // 1b. BISINDO M (M.jpg) & N (N.jpg): Base open palm + 3 fingers (M) or 2 fingers (N) placed against it
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

      // 1c. Vertical Index Post + Modifier Hand: B (B.jpg), F (F.jpg), K (K.jpg), Y (Y.jpg), P (P.jpg), D (D.jpg)
      final f1IsPost =
          f1.extendedCount == 1 && f1.indexExt && !f1.isHorizontal;
      final f2IsPost =
          f2.extendedCount == 1 && f2.indexExt && !f2.isHorizontal;

      if (f1IsPost || f2IsPost) {
        final post = f1IsPost ? f1 : f2;
        final mod = f1IsPost ? f2 : f1;
        final modToPostDist = _dist(mod.lm[8], post.lm[6]) / avgPalm;

        if (modToPostDist < 1.45) {
          // BISINDO B (B.jpg): 3 or 4 horizontal fingers against vertical index post
          if (mod.isHorizontal && mod.extendedCount >= 3) {
            return const Gesture(label: 'B', confidence: 0.94);
          }
          // BISINDO F (F.jpg): 2 horizontal fingers (index + middle) across vertical index post
          if (mod.isHorizontal &&
              mod.extendedCount == 2 &&
              mod.indexExt &&
              mod.middleExt) {
            return const Gesture(label: 'F', confidence: 0.93);
          }
          // BISINDO Y (Y.jpg) vs K (K.jpg):
          if (!mod.isHorizontal &&
              ((mod.extendedCount == 2 && mod.indexExt && mod.middleExt) ||
                  (mod.extendedCount == 1 && mod.indexExt && mod.thumbOut))) {
            if (post.lm[8].y > mod.lm[5].y) {
              return const Gesture(label: 'Y', confidence: 0.92);
            }
            return const Gesture(label: 'K', confidence: 0.92);
          }
          // BISINDO P (P.jpg) vs D (D.jpg): Modifier hand forms a C/loop against vertical post
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

      // 1d. BISINDO W (2-hand V shapes side-by-side)
      if (f1.extendedCount == 2 &&
          f1.indexExt &&
          f1.middleExt &&
          f2.extendedCount == 2 &&
          f2.indexExt &&
          f2.middleExt &&
          dIndexTips < 0.85) {
        return const Gesture(label: 'W', confidence: 0.94);
      }

      // 1e. BISINDO Q (Q.jpg): One hand forms O circle, other hand index pokes near it
      if ((f1.pinchIndex < 0.48 && f2.indexExt && f2.extendedCount == 1) ||
          (f2.pinchIndex < 0.48 && f1.indexExt && f1.extendedCount == 1)) {
        if (dIndexTips < 0.90) {
          return const Gesture(label: 'Q', confidence: 0.92);
        }
      }

      // 1f. BISINDO G (G.jpg): Two closed fists stacked vertically
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

      // 1g. BISINDO S (S.jpg): Two C/hook hands stacked in opposite directions
      if (f1.extendedCount <= 1 &&
          f2.extendedCount <= 1 &&
          !f1.isFist &&
          !f2.isFist &&
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
    // 2. SINGLE-HAND BISINDO ALPHABET RULES
    //    Strictly limited to the 10 single-hand BISINDO letters in Belajar:
    //    C, E, I, J, L, O, R, U, V, Z
    // =========================================================================
    final f = _extractFeatures(validHands[0]);
    final lm = f.lm;

    // HARD GATE: Reject Thumbs-Up and Closed Fist immediately!
    if (f.isThumbsUp || f.isFist) {
      return const Gesture(label: '', confidence: 0.0);
    }

    // 2a. Huruf L (L.jpg):
    //     ONLY Index strictly upright + Thumb strictly extended sideways at ~90 deg (55..130 deg),
    //     and thumb tip is well below index tip.
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
      final thumbIndexAngle = _vectorAngleDeg(lm[5], lm[8], lm[2], lm[4]);
      final thumbBelowIndex = (lm[4].y - lm[8].y) > 0.42 * f.palmSize;
      final thumbSidewaysFromIndex = (lm[4].x - lm[5].x).abs() > 0.35 * f.palmSize;
      if (thumbIndexAngle >= 52.0 &&
          thumbIndexAngle <= 132.0 &&
          thumbBelowIndex &&
          thumbSidewaysFromIndex) {
        return const Gesture(label: 'L', confidence: 0.96);
      }
    }

    // 2b. Huruf I (I.jpg) vs Huruf J (J.jpg):
    //     ONLY Pinky extended, index + middle + ring tightly curled, thumb tucked.
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
        return const Gesture(label: 'J', confidence: 0.93);
      }
      return const Gesture(label: 'I', confidence: 0.95);
    }

    // 2c. Huruf U (U.jpg):
    //     Dataset pose: Index + Pinky extended upright (or Thumb + Pinky extended upright)
    //     with middle & ring curled in between forming the U valley.
    if (!f.middleExt &&
        !f.ringExt &&
        f.middleCurled &&
        f.ringCurled &&
        !f.isHorizontal &&
        !f.isPointingDown) {
      if (f.indexExt && f.pinkyExt) {
        return const Gesture(label: 'U', confidence: 0.95);
      }
      if (f.thumbOut && f.pinkyExt && !f.indexExt && f.indexCurled) {
        return const Gesture(label: 'U', confidence: 0.94);
      }
    }

    // 2d. Huruf V (V.jpg) vs Huruf R (R.jpg - 2 upright fingers crossed/pressed):
    //     Index & Middle extended upright while Ring & Pinky are curled and Thumb is tucked.
    if (f.indexExt &&
        f.middleExt &&
        !f.ringExt &&
        !f.pinkyExt &&
        f.ringCurled &&
        f.pinkyCurled &&
        !f.thumbOut &&
        !f.isHorizontal &&
        !f.isPointingDown) {
      final mcpDeltaX = lm[5].x - lm[9].x;
      final tipDeltaX = lm[8].x - lm[12].x;
      if (mcpDeltaX * tipDeltaX < 0 || f.indexMiddleSpread < 0.16) {
        return const Gesture(label: 'R', confidence: 0.93);
      }
      if (f.indexMiddleSpread >= 0.25) {
        return const Gesture(label: 'V', confidence: 0.95);
      }
    }

    // 2e. Huruf R (R.jpg dataset pose: Index & Thumb snapped/crossed at top, Middle + Ring + Pinky curled):
    if (!f.middleExt &&
        !f.ringExt &&
        !f.pinkyExt &&
        f.middleCurled &&
        f.ringCurled &&
        f.pinkyCurled &&
        !f.isHorizontal &&
        !f.isPointingDown &&
        f.pinchIndex < 0.34 &&
        lm[8].y < lm[5].y - 0.38 * f.palmSize &&
        lm[4].y < lm[5].y - 0.28 * f.palmSize) {
      return const Gesture(label: 'R', confidence: 0.93);
    }

    // 2f. Huruf E (E.jpg):
    //     3 fingers (Index, Middle, Ring) extended HORIZONTALLY, Pinky curled.
    if (f.isHorizontal &&
        f.indexExt &&
        f.middleExt &&
        f.ringExt &&
        !f.pinkyExt &&
        f.pinkyCurled) {
      return const Gesture(label: 'E', confidence: 0.94);
    }

    // 2g. Huruf Z (Z.jpg):
    //     4 fingers (Index, Middle, Ring, Pinky) extended HORIZONTALLY, Thumb tucked.
    if (f.isHorizontal &&
        f.indexExt &&
        f.middleExt &&
        f.ringExt &&
        f.pinkyExt &&
        !f.thumbOut) {
      return const Gesture(label: 'Z', confidence: 0.92);
    }

    // 2h. Huruf O (O.jpg):
    //     Thumb tip & Index tip touching in a round circle (pinchIndex < 0.36),
    //     fingers curved forward (not folded into a flat fist), thumb at bottom of circle.
    if (f.pinchIndex < 0.36 &&
        f.pinchMiddle < 0.50 &&
        !f.indexExt &&
        !f.middleExt &&
        !f.ringExt &&
        !f.pinkyExt &&
        _dist(lm[0], lm[8]) / f.palmSize > 1.08 &&
        _dist(lm[5], lm[8]) / f.palmSize > 0.52 &&
        lm[4].y >= lm[8].y - 0.05 * f.palmSize) {
      return const Gesture(label: 'O', confidence: 0.94);
    }

    // 2i. Huruf C (C.jpg):
    //     Strict C-arch geometry:
    //     - Index & Middle are semi-curled in an arch (NOT straight extended, NOT curled into palm)
    //     - Index tip (lm[8]) and Middle tip (lm[12]) are ABOVE Thumb tip (lm[4])
    //     - Open vertical C-gap between Index tip and Thumb tip (0.44 .. 0.98 * palmSize)
    //     - Both Index and Thumb reach in the same horizontal direction from the palm
    final indexReach = _dist(lm[5], lm[8]) / f.palmSize;
    final middleReach = _dist(lm[9], lm[12]) / f.palmSize;
    final indexFromWrist = _dist(lm[0], lm[8]) / f.palmSize;
    final indexAboveThumb = (lm[4].y - lm[8].y) / f.palmSize;
    final middleAboveThumb = (lm[4].y - lm[12].y) / f.palmSize;
    final sameHorizDir = (lm[8].x - lm[5].x) * (lm[4].x - lm[2].x) > 0;

    if (f.extendedCount == 0 &&
        f.indexSemi &&
        f.middleSemi &&
        !f.indexCurled &&
        !f.middleCurled &&
        indexReach > 0.60 &&
        middleReach > 0.58 &&
        indexFromWrist > 1.20 &&
        indexAboveThumb >= 0.25 &&
        indexAboveThumb <= 1.00 &&
        middleAboveThumb >= 0.20 &&
        f.pinchIndex >= 0.44 &&
        f.pinchIndex <= 0.98 &&
        _dist(lm[4], lm[5]) / f.palmSize > 0.48 &&
        sameHorizDir &&
        !f.isPointingDown) {
      return const Gesture(label: 'C', confidence: 0.93);
    }

    // Any other pose (Thumbs Up, Fist, Open Palm, Single Vertical Index, etc.) is strictly rejected!
    return const Gesture(label: '', confidence: 0.0);
  }

  // =========================================================================
  // 3. BISINDO NUMBERS 0 - 9 CLASSIFICATION (1-Hand & 2-Hand Rules)
  // =========================================================================
  static Gesture _classifyNumbers(List<HandSkeleton> validHands) {
    if (validHands.isEmpty) {
      return const Gesture(label: '', confidence: 0.0);
    }

    // -----------------------------------------------------------------------
    // 3a. Dua Tangan (Two Hands Composite Counting: 6, 7, 8, 9, 10)
    // Standar BISINDO: Satu telapak tangan terbuka (5) + jari tangan kedua (1 s/d 5)
    // -----------------------------------------------------------------------
    if (validHands.length >= 2) {
      final f1 = _extractFeatures(validHands[0]);
      final f2 = _extractFeatures(validHands[1]);

      final h1Is5 = f1.extendedCount >= 4 && f1.thumbOut;
      final h2Is5 = f2.extendedCount >= 4 && f2.thumbOut;

      if (h1Is5 && h2Is5) {
        return const Gesture(label: '10', confidence: 0.95);
      }

      if (h1Is5 || h2Is5) {
        final countHand = h1Is5 ? f2 : f1;

        // 5 + 4 = 9
        if ((countHand.indexExt &&
                countHand.middleExt &&
                countHand.ringExt &&
                countHand.pinkyExt &&
                !countHand.thumbOut) ||
            countHand.extendedCount == 4) {
          return const Gesture(label: '9', confidence: 0.94);
        }

        // 5 + 3 = 8
        if ((countHand.indexExt &&
                countHand.middleExt &&
                countHand.ringExt &&
                !countHand.pinkyExt) ||
            (countHand.thumbOut &&
                countHand.indexExt &&
                countHand.middleExt &&
                !countHand.ringExt) ||
            countHand.extendedCount == 3) {
          return const Gesture(label: '8', confidence: 0.94);
        }

        // 5 + 2 = 7
        if ((countHand.indexExt &&
                countHand.middleExt &&
                !countHand.ringExt &&
                !countHand.pinkyExt) ||
            countHand.extendedCount == 2) {
          return const Gesture(label: '7', confidence: 0.94);
        }

        // 5 + 1 = 6
        if ((countHand.indexExt &&
                !countHand.middleExt &&
                !countHand.ringExt &&
                !countHand.pinkyExt) ||
            countHand.extendedCount == 1) {
          return const Gesture(label: '6', confidence: 0.94);
        }
      }

      return const Gesture(label: '', confidence: 0.0);
    }

    // -----------------------------------------------------------------------
    // 3b. Satu Tangan (Single Hand Digits: 0, 1, 2, 3, 4, 5 & 1-Hand Alt)
    // -----------------------------------------------------------------------
    final f = _extractFeatures(validHands[0]);
    final lm = f.lm;

    // Reject Thumbs-Up and Closed Fist in numbers mode as well
    if (f.isThumbsUp || f.isFist) {
      return const Gesture(label: '', confidence: 0.0);
    }

    // Angka 0: Ibu jari dan telunjuk bersentuhan membentuk lingkaran bulat O (bukan mengepal)
    if (f.pinchIndex <= 0.38 &&
        !f.indexExt &&
        !f.middleExt &&
        !f.ringExt &&
        !f.pinkyExt &&
        _dist(lm[0], lm[8]) / f.palmSize > 1.08 &&
        _dist(lm[5], lm[8]) / f.palmSize > 0.52 &&
        lm[4].y >= lm[8].y - 0.05 * f.palmSize) {
      return const Gesture(label: '0', confidence: 0.95);
    }

    // Angka 5: Telapak tangan terbuka lebar, kelima jari terentang
    if (f.extendedCount >= 4 && f.thumbOut) {
      return const Gesture(label: '5', confidence: 0.96);
    }

    // Angka 4: 4 jari tegak ke atas, ibu jari melipat di telapak tangan
    if (f.indexExt && f.middleExt && f.ringExt && f.pinkyExt && !f.thumbOut) {
      return const Gesture(label: '4', confidence: 0.96);
    }

    // Angka 3: 3 jari tegak ke atas (telunjuk, tengah, manis ATAU jempol, telunjuk, tengah)
    if ((f.indexExt && f.middleExt && f.ringExt && !f.pinkyExt && !f.thumbOut) ||
        (f.thumbOut && f.indexExt && f.middleExt && !f.ringExt && !f.pinkyExt)) {
      return const Gesture(label: '3', confidence: 0.95);
    }

    // Angka 2: 2 jari tegak ke atas (telunjuk dan jari tengah)
    if (f.indexExt && f.middleExt && !f.ringExt && !f.pinkyExt && !f.thumbOut) {
      return const Gesture(label: '2', confidence: 0.96);
    }

    // Angka 1: Hanya 1 jari tegak ke atas (jari telunjuk)
    if (f.indexExt && !f.middleExt && !f.ringExt && !f.pinkyExt && !f.thumbOut) {
      return const Gesture(label: '1', confidence: 0.96);
    }

    // Alternatif 1 Tangan: Angka 6 (Jempol dan kelingking terbuka - Shaka gesture)
    if (f.thumbOut && f.pinkyExt && !f.indexExt && !f.middleExt && !f.ringExt) {
      return const Gesture(label: '6', confidence: 0.93);
    }

    // Alternatif 1 Tangan: Angka 9 (Ibu jari & telunjuk menempel bulat, 3 jari lain tegak)
    if (f.pinchIndex <= 0.40 && f.middleExt && f.ringExt && f.pinkyExt) {
      return const Gesture(label: '9', confidence: 0.93);
    }

    // Alternatif 1 Tangan: Angka 7 (Ibu jari & telunjuk terbuka bentuk L siku-siku)
    if (f.thumbOut &&
        f.indexExt &&
        !f.middleExt &&
        !f.ringExt &&
        !f.pinkyExt &&
        (lm[4].y - lm[8].y) > 0.42 * f.palmSize) {
      return const Gesture(label: '7', confidence: 0.92);
    }

    // Alternatif 1 Tangan: Angka 8 (Jari tengah menyentuh jempol, jari lain tegak)
    if (f.pinchMiddle <= 0.42 && f.indexExt && f.ringExt && f.pinkyExt) {
      return const Gesture(label: '8', confidence: 0.92);
    }

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
  final bool isThumbsUp;
  final bool isFist;

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
    required this.isThumbsUp,
    required this.isFist,
  });
}
