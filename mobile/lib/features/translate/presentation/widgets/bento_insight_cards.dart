import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// Custom Painter for the Semi-Circular Donut Gauge
/// Gradient transitioning from Neon Cyan (#00E5FF) to Magenta (#FF007F).
class DonutGaugePainter extends CustomPainter {
  final double progress; // 0.0 to 1.0

  DonutGaugePainter({this.progress = 0.85});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.85);
    final radius = math.min(size.width / 2, size.height * 0.78);
    const strokeWidth = 7.0;

    // Background track arc (180 degrees from pi to 0)
    final bgPaint = Paint()
      ..color = AppColors.surfaceHigher
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      math.pi,
      false,
      bgPaint,
    );

    // Active Gradient Arc
    final rect = Rect.fromCircle(center: center, radius: radius);
    final sweepGradient = const SweepGradient(
      colors: [AppColors.accentCyan, AppColors.primary, AppColors.accentPink],
      stops: [0.0, 0.5, 1.0],
      startAngle: math.pi,
      endAngle: 2 * math.pi,
    );

    final activePaint = Paint()
      ..shader = sweepGradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = math.pi * progress.clamp(0.05, 1.0);
    canvas.drawArc(
      rect,
      math.pi,
      sweepAngle,
      false,
      activePaint,
    );

    // Glow effect for the active arc
    final glowPaint = Paint()
      ..shader = sweepGradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + 4.0
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);

    canvas.drawArc(
      rect,
      math.pi,
      sweepAngle,
      false,
      glowPaint,
    );

    // End thumb dot at current progress position
    final currentAngle = math.pi + sweepAngle;
    final thumbX = center.dx + radius * math.cos(currentAngle);
    final thumbY = center.dy + radius * math.sin(currentAngle);

    final thumbPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(thumbX, thumbY), 4.5, thumbPaint);
  }

  @override
  bool shouldRepaint(covariant DonutGaugePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// Custom Painter for the Smooth Bell-Curve Spline Wave
/// Features electric violet glow line with distinct peak dots.
class SplineWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    final path = Path();
    // Start at bottom-left baseline
    path.moveTo(0, height * 0.75);

    // Cubic bezier curves forming the bell curve
    path.cubicTo(
      width * 0.25,
      height * 0.75,
      width * 0.35,
      height * 0.15,
      width * 0.50,
      height * 0.15,
    );
    path.cubicTo(
      width * 0.65,
      height * 0.15,
      width * 0.75,
      height * 0.75,
      width,
      height * 0.75,
    );

    // Gradient fill beneath the curve
    final fillPath = Path.from(path)
      ..lineTo(width, height)
      ..lineTo(0, height)
      ..close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.primary.withValues(alpha: 0.35),
          AppColors.primary.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, width, height))
      ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, fillPaint);

    // Glow line stroke
    final glowPaint = Paint()
      ..color = AppColors.primaryLight.withValues(alpha: 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0);

    canvas.drawPath(path, glowPaint);

    // Primary stroke line
    final linePaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, linePaint);

    // Two dots at inflection/peak points
    final dotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final dotBorderPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Peak dot
    final peakOffset = Offset(width * 0.50, height * 0.15);
    canvas.drawCircle(peakOffset, 3.5, dotPaint);
    canvas.drawCircle(peakOffset, 3.5, dotBorderPaint);

    // Mid dot
    final rightDot = Offset(width * 0.75, height * 0.75);
    canvas.drawCircle(rightDot, 3.0, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Bento 2x2 Grid of Insight & Telemetry Cards
/// Exact recreation of the reference screenshot design system.
class BentoInsightCards extends StatelessWidget {
  final int detectedHandsCount;
  final bool isDetecting;
  final double confidence;

  const BentoInsightCards({
    super.key,
    this.detectedHandsCount = 1,
    this.isDetecting = true,
    this.confidence = 0.978,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Row 1: Kinematics & Hand Gauge
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card 1: Top-Left (Kinematics / Geo-style Stat)
            Expanded(
              child: _buildBentoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 15,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Kinematika',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        // Badge (like the US flag capsule in reference)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceHigher,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppColors.borderLight,
                              width: 0.8,
                            ),
                          ),
                          child: const Text(
                            '21 Pts',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.accentCyan,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${(confidence * 100).toStringAsFixed(1)}%',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'MediaPipe 21-Points Hand Mesh aktif terkalibrasi',
                      style: TextStyle(
                        fontSize: 11,
                        height: 1.35,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Card 2: Top-Right (Donut Gauge Arc)
            Expanded(
              child: _buildBentoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.people_outline,
                          size: 15,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Deteksi Tangan',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Donut Gauge with Center Value
                    SizedBox(
                      height: 72,
                      width: double.infinity,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomPaint(
                            size: const Size(double.infinity, 72),
                            painter: DonutGaugePainter(
                              progress: isDetecting ? 0.96 : 0.45,
                            ),
                          ),
                          Positioned(
                            top: 26,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  isDetecting ? '96%' : 'Standby',
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  'Akurasi',
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    color: AppColors.textMuted,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Bottom labels (Kiri / Kanan)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: AppColors.accentCyan,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Kiri',
                              style: TextStyle(
                                fontSize: 10.5,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: AppColors.accentPink,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Kanan',
                              style: TextStyle(
                                fontSize: 10.5,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Row 2: Hold Slider & Spline Wave
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card 3: Bottom-Left (Hold Activity Slider)
            Expanded(
              child: _buildBentoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.timer_outlined,
                          size: 15,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Gesture Hold',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '0.5s',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Glowing Slider Bar
                    Container(
                      height: 5,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceHigher,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          FractionallySizedBox(
                            widthFactor: 0.65,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    AppColors.primaryDark,
                                    AppColors.primary,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(3),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(alpha: 0.5),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Thumb Circle
                          Positioned(
                            left: 70,
                            child: Container(
                              width: 9,
                              height: 9,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary,
                                    blurRadius: 3,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Tahan posisi tangan 0.5s untuk mencatat huruf',
                      style: TextStyle(
                        fontSize: 11,
                        height: 1.35,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Card 4: Bottom-Right (Spline Wave 60 FPS)
            Expanded(
              child: _buildBentoCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.sensors,
                          size: 15,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Engine Speed',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '60 FPS',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Spline Wave Visualizer
                    SizedBox(
                      height: 38,
                      width: double.infinity,
                      child: CustomPaint(
                        painter: SplineWavePainter(),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'On-Device WebGL kinematics aktif tanpa jeda',
                      style: TextStyle(
                        fontSize: 11,
                        height: 1.35,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBentoCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.border,
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
