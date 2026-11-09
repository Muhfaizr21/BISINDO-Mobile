import 'dart:async';
import 'dart:math' as math;
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/datasources/bisindo_landmark_classifier.dart';
import '../../domain/entities/gesture.dart';
import '../../domain/entities/hand_landmarks.dart';
import '../../domain/services/camera_service.dart';
import 'hand_landmarks_painter.dart';

class CameraViewWidget extends StatefulWidget {
  final CameraService cameraService;
  final bool isDetecting;
  final List<HandSkeleton> detectedHands;
  final ValueChanged<Gesture>? onGestureConfirmed;
  final VoidCallback? onToggleDetection;
  final BisindoTargetMode targetMode;

  const CameraViewWidget({
    super.key,
    required this.cameraService,
    required this.isDetecting,
    this.detectedHands = const [],
    this.onGestureConfirmed,
    this.onToggleDetection,
    this.targetMode = BisindoTargetMode.alphabet,
  });

  @override
  State<CameraViewWidget> createState() => _CameraViewWidgetState();
}

class _CameraViewWidgetState extends State<CameraViewWidget>
    with WidgetsBindingObserver {
  bool _isLoading = true;
  Timer? _detectionTimer;
  List<HandSkeleton> _liveHands = const [];
  List<HandSkeleton> _prevHands = const [];
  Gesture? _liveGesture;

  String _candidateLabel = '';
  int _holdFrames = 0;
  static const int _requiredHoldFrames = 12; // ~0.5s steady hold for snappy detection
  DateTime? _lastConfirmedAt;
  String _lastConfirmedLabel = '';
  bool _gestureReleasedSinceLastConfirm = true;
  int _releasedFrameCount = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    sl.handLandmarkerService.initialize();
    sl.tfliteClassifierService.initialize();
    _initializeCamera();
    if (widget.isDetecting) {
      _startRealtimeTracking();
    }
  }

  @override
  void didUpdateWidget(covariant CameraViewWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isDetecting && !oldWidget.isDetecting) {
      _startRealtimeTracking();
    } else if (!widget.isDetecting && oldWidget.isDetecting) {
      _stopRealtimeTracking();
    }
  }

  void _startRealtimeTracking() {
    _detectionTimer?.cancel();
    _holdFrames = 0;
    _candidateLabel = '';
    _prevHands = const [];
    _detectionTimer = Timer.periodic(
      const Duration(milliseconds: 45),
      (_) => _processFrame(),
    );
  }

  void _stopRealtimeTracking() {
    _detectionTimer?.cancel();
    _detectionTimer = null;
    if (mounted) {
      setState(() {
        _liveHands = const [];
        _prevHands = const [];
        _liveGesture = null;
        _holdFrames = 0;
        _candidateLabel = '';
      });
    }
  }

  bool _isHandSteady(List<HandSkeleton> current, List<HandSkeleton> previous) {
    if (previous.isEmpty || previous.length != current.length) return false;
    for (int i = 0; i < current.length; i++) {
      final cWrist = current[i].landmarks[0];
      final pWrist = previous[i].landmarks[0];
      final cTip = current[i].landmarks[8];
      final pTip = previous[i].landmarks[8];

      final wristDelta = math.sqrt(
        math.pow(cWrist.x - pWrist.x, 2) + math.pow(cWrist.y - pWrist.y, 2),
      );
      final tipDelta = math.sqrt(
        math.pow(cTip.x - pTip.x, 2) + math.pow(cTip.y - pTip.y, 2),
      );
      if (wristDelta > 0.065 || tipDelta > 0.085) {
        return false;
      }
    }
    return true;
  }

  Future<void> _processFrame() async {
    if (!mounted || !widget.isDetecting) return;

    final results = await sl.handLandmarkerService.detect(null);
    if (!mounted || !widget.isDetecting) return;

    if (results.isEmpty) {
      _releasedFrameCount++;
      if (_releasedFrameCount >= 4) {
        _gestureReleasedSinceLastConfirm = true;
      }
      if (_liveHands.isNotEmpty || _liveGesture != null) {
        setState(() {
          _liveHands = const [];
          _prevHands = const [];
          _liveGesture = null;
          _holdFrames = 0;
          _candidateLabel = '';
        });
      }
      return;
    }

    final skeletons = results.map((r) {
      return HandSkeleton(
        handedness: r.handedness,
        confidence: r.score,
        landmarks: r.landmarks
            .map((pt) => NormalizedLandmark(x: pt.x, y: pt.y, z: pt.z))
            .toList(),
      );
    }).toList();

    final isSteady = _isHandSteady(skeletons, _prevHands);
    _prevHands = skeletons;

    final classified = BisindoLandmarkClassifier.classifyHands(
      skeletons,
      mode: widget.targetMode,
    );
    final isValidGesture =
        classified.label.isNotEmpty && classified.confidence >= 0.88;

    if (isValidGesture && isSteady) {
      _releasedFrameCount = 0;
      if (classified.label == _candidateLabel) {
        _holdFrames++;
      } else {
        _candidateLabel = classified.label;
        _holdFrames = 1;
      }

      if (_holdFrames >= _requiredHoldFrames) {
        final now = DateTime.now();
        final isNewGesture = _lastConfirmedLabel != classified.label;
        final cooldownPassed = _lastConfirmedAt == null ||
            isNewGesture ||
            (_gestureReleasedSinceLastConfirm &&
                now.difference(_lastConfirmedAt!).inMilliseconds > 900);

        if (cooldownPassed) {
          _lastConfirmedAt = now;
          _lastConfirmedLabel = classified.label;
          _gestureReleasedSinceLastConfirm = false;
          _holdFrames = 0;
          widget.onGestureConfirmed?.call(classified);
        }
      }
    } else if (!isValidGesture) {
      _holdFrames = 0;
      _candidateLabel = '';
      _releasedFrameCount++;
      if (_releasedFrameCount >= 5) {
        _gestureReleasedSinceLastConfirm = true;
      }
    }

    setState(() {
      _liveHands = skeletons;
      _liveGesture = isValidGesture ? classified : null;
    });
  }

  Future<void> _initializeCamera() async {
    setState(() => _isLoading = true);
    await widget.cameraService.initialize();
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (widget.cameraService.controller == null ||
        !widget.cameraService.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      widget.cameraService.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  @override
  void dispose() {
    _detectionTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    widget.cameraService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        height: 380,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.border),
        ),
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: AppColors.primary),
              SizedBox(height: 14),
              Text(
                'Menyiapkan kamera & MediaPipe...',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final controller = widget.cameraService.controller;

    if (controller == null || !widget.cameraService.isInitialized) {
      return Container(
        height: 380,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: widget.isDetecting
                ? AppColors.primary.withValues(alpha: 0.6)
                : AppColors.border,
            width: 1.2,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceHigher,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    widget.isDetecting ? Icons.videocam : Icons.videocam_off,
                    color: widget.isDetecting
                        ? AppColors.primaryLight
                        : AppColors.textMuted,
                    size: 38,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.isDetecting
                      ? 'Area Deteksi Aktif (Mode Simulasi)\nSiap menerima koordinat gestur tangan'
                      : 'Kamera Tidak Tersedia / Izin Belum Diberikan\nGunakan tombol simulasi di bawah untuk menguji',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: widget.isDetecting
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                    fontSize: 13.5,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 18),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: const BorderSide(color: AppColors.borderLight),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                  onPressed: _initializeCamera,
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Coba Deteksi Kamera Ulang'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final isFrontCamera = widget.cameraService.currentCamera?.lensDirection ==
        CameraLensDirection.front;
    final activeHands =
        _liveHands.isNotEmpty ? _liveHands : widget.detectedHands;
    final holdProgress =
        (_holdFrames / _requiredHoldFrames).clamp(0.0, 1.0);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: widget.isDetecting
              ? AppColors.primary.withValues(alpha: 0.6)
              : AppColors.border,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.45),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Live Camera Preview with synchronized 21-point Hand Skeleton
            SizedBox(
              height: 380,
              width: double.infinity,
              child: FittedBox(
                fit: BoxFit.cover,
                clipBehavior: Clip.hardEdge,
                child: SizedBox(
                  width: 380 *
                      ((controller.value.isInitialized &&
                              controller.value.aspectRatio > 0)
                          ? controller.value.aspectRatio
                          : (4.0 / 3.0)),
                  height: 380,
                  child: CameraPreview(
                    controller,
                    child: CustomPaint(
                      painter: HandLandmarksPainter(
                        hands: activeHands,
                        isFrontCamera: !kIsWeb && isFrontCamera,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Live Gesture Prediction HUD at Top-Left
            if (widget.isDetecting && _liveHands.isNotEmpty)
              Positioned(
                top: 14,
                left: 14,
                child: _liveGesture != null
                    ? InkWell(
                        onTap: () => widget.onGestureConfirmed?.call(_liveGesture!),
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surface.withValues(alpha: 0.90),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: AppColors.accentCyan.withValues(alpha: 0.8),
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.accentCyan.withValues(alpha: 0.25),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  value: holdProgress,
                                  strokeWidth: 2.8,
                                  backgroundColor: AppColors.surfaceHigher,
                                  color: AppColors.accentCyan,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${widget.targetMode == BisindoTargetMode.numbers ? "Angka" : "Huruf"}: ${_liveGesture!.label} (${(_liveGesture!.confidence * 100).toStringAsFixed(0)}%)',
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    '${_liveHands.length} tangan • Tahan stabil / ketuk',
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 10.5,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surface.withValues(alpha: 0.88),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppColors.accentAmber.withValues(alpha: 0.7),
                            width: 1.0,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.info_outline,
                              color: AppColors.accentAmber,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              widget.targetMode == BisindoTargetMode.numbers
                                  ? 'Bentuk angka 0-9 BISINDO (${_liveHands.length} tangan)'
                                  : 'Gerakan belum sesuai abjad BISINDO (${_liveHands.length} tangan)',
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),

            // Camera Overlay Controls at Top-Right
            Positioned(
              top: 14,
              right: 14,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: Text(
                      widget.targetMode == BisindoTargetMode.numbers
                          ? '🔢 Angka 0-9'
                          : '🔤 Abjad A-Z',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  if (widget.cameraService.cameras.length > 1)
                    IconButton.filledTonal(
                      tooltip: 'Ganti Kamera',
                      onPressed: () async {
                        await widget.cameraService.switchCamera();
                        if (mounted) setState(() {});
                      },
                      icon: const Icon(Icons.cameraswitch, color: Colors.white, size: 18),
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.surface.withValues(alpha: 0.85),
                      ),
                    ),
                ],
              ),
            ),

            // Standby Hint Overlay when not detecting
            if (!widget.isDetecting)
              Positioned.fill(
                child: GestureDetector(
                  onTap: widget.onToggleDetection,
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.35),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surface.withValues(alpha: 0.90),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: AppColors.primaryLight.withValues(alpha: 0.5),
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.25),
                              blurRadius: 12,
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.play_circle_fill,
                              color: AppColors.primaryLight,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Deteksi Standby • Ketuk untuk Memulai',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            // Status Badge at Bottom-Left
            Positioned(
              bottom: 14,
              left: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.surface.withValues(alpha: 0.90),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: widget.isDetecting
                        ? (_liveHands.isNotEmpty
                            ? AppColors.accentGreen
                            : AppColors.accentAmber)
                        : AppColors.borderLight,
                    width: 1.0,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.isDetecting
                            ? (_liveHands.isNotEmpty
                                ? AppColors.accentGreen
                                : AppColors.accentAmber)
                            : AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.isDetecting
                          ? (_liveHands.isNotEmpty
                              ? 'Tangan Terdeteksi (${_liveHands.length})'
                              : 'Arahkan Tangan ke Kamera')
                          : 'Standby',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
