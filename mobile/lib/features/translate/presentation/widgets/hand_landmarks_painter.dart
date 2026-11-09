import 'package:flutter/material.dart';
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
      ..color = Colors.cyanAccent.withValues(alpha: 0.35)
      ..strokeWidth = 7.0
      ..strokeCap = StrokeCap.round;

    final linePaint = Paint()
      ..color = Colors.cyanAccent
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    final jointPaint = Paint()
      ..color = Colors.greenAccent
      ..style = PaintingStyle.fill;

    final tipPaint = Paint()
      ..color = Colors.amberAccent
      ..style = PaintingStyle.fill;

    final outlinePaint = Paint()
      ..color = Colors.black54
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Tips: landmarks 4 (thumb), 8 (index), 12 (middle), 16 (ring), 20 (pinky)
    const tipIndices = {4, 8, 12, 16, 20};

    for (final hand in hands) {
      if (hand.landmarks.length < 21) continue;

      // 1. Draw connection lines
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
        final radius = isTip ? 6.0 : 4.2;
        final paint = isTip ? tipPaint : jointPaint;
        final center = Offset(x, y);

        canvas.drawCircle(center, radius, paint);
        canvas.drawCircle(center, radius, outlinePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant HandLandmarksPainter oldDelegate) {
    return oldDelegate.hands != hands ||
        oldDelegate.isFrontCamera != isFrontCamera;
  }
}
