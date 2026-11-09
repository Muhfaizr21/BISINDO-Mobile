import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/hand_landmarks.dart';

class HandLandmarksPainter extends CustomPainter {
  final List<HandSkeleton> hands;
  final bool isFrontCamera;

  HandLandmarksPainter({
    required this.hands,
    this.isFrontCamera = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (hands.isEmpty) return;

    final glowLinePaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.45)
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0);

    final linePaint = Paint()
      ..color = AppColors.accentCyan
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;

    final jointCorePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final jointRingPaint = Paint()
      ..color = AppColors.accentCyan
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final tipCorePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final tipRingPaint = Paint()
      ..color = AppColors.primaryLight
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final tipGlowPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);

    // Tips: landmarks 4 (thumb), 8 (index), 12 (middle), 16 (ring), 20 (pinky)
    const tipIndices = {4, 8, 12, 16, 20};

    for (final hand in hands) {
      if (hand.landmarks.length < 21) continue;

      // 1. Draw connection lines with neon glow
      for (final connection in HandSkeleton.connections) {
        final startIndex = connection[0];
        final endIndex = connection[1];

        final start = hand.landmarks[startIndex];
        final end = hand.landmarks[endIndex];

        final startX =
            isFrontCamera ? (1.0 - start.x) * size.width : start.x * size.width;
        final startY = start.y * size.height;

        final endX =
            isFrontCamera ? (1.0 - end.x) * size.width : end.x * size.width;
        final endY = end.y * size.height;

        final p1 = Offset(startX, startY);
        final p2 = Offset(endX, endY);
        canvas.drawLine(p1, p2, glowLinePaint);
        canvas.drawLine(p1, p2, linePaint);
      }

      // 2. Draw joint landmarks
      for (var i = 0; i < hand.landmarks.length; i++) {
        final lm = hand.landmarks[i];
        final x = isFrontCamera ? (1.0 - lm.x) * size.width : lm.x * size.width;
        final y = lm.y * size.height;

        final isTip = tipIndices.contains(i);
        final center = Offset(x, y);

        if (isTip) {
          canvas.drawCircle(center, 7.0, tipGlowPaint);
          canvas.drawCircle(center, 4.5, tipCorePaint);
          canvas.drawCircle(center, 5.0, tipRingPaint);
        } else {
          canvas.drawCircle(center, 3.2, jointCorePaint);
          canvas.drawCircle(center, 3.8, jointRingPaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant HandLandmarksPainter oldDelegate) {
    return oldDelegate.hands != hands ||
        oldDelegate.isFrontCamera != isFrontCamera;
  }
}
