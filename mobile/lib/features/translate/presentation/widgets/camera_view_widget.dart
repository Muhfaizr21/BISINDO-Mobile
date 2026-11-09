import 'dart:async';
import 'dart:math' as math;
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../core/di/injection.dart';
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
      if (classified.label == _candidateLabel) {
        _holdFrames++;
      } else {
        _candidateLabel = classified.label;
        _holdFrames = 1;
      }

      if (_holdFrames >= _requiredHoldFrames) {
        final now = DateTime.now();
        final cooldownPassed = _lastConfirmedAt == null ||
            now.difference(_lastConfirmedAt!).inMilliseconds > 1200 ||
            _lastConfirmedLabel != classified.label;

        if (cooldownPassed) {
          _lastConfirmedAt = now;
          _lastConfirmedLabel = classified.label;
          _holdFrames = 0;
          widget.onGestureConfirmed?.call(classified);
        }
      }
    } else if (!isValidGesture) {
      _holdFrames = 0;
      _candidateLabel = '';
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
          color: Colors.black87,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(height: 12),
              Text(
                'Menyiapkan kamera & MediaPipe...',
                style: TextStyle(color: Colors.white70),
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
          color: Colors.black87,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: widget.isDetecting ? Colors.green : Colors.grey.shade700,
            width: 2,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.isDetecting ? Icons.videocam : Icons.videocam_off,
                  color:
                      widget.isDetecting ? Colors.greenAccent : Colors.white54,
                  size: 56,
                ),
                const SizedBox(height: 12),
                Text(
                  widget.isDetecting
                      ? 'Area Deteksi Aktif (Mode Simulasi)\nSiap menerima koordinat MediaPipe'
                      : 'Kamera Tidak Tersedia / Izin Belum Diberikan\nGunakan tombol simulasi di bawah untuk menguji',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: widget.isDetecting ? Colors.white : Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  style:
                      OutlinedButton.styleFrom(foregroundColor: Colors.white),
                  onPressed: _initializeCamera,
                  icon: const Icon(Icons.refresh),
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

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Live Camera Preview with synchronized 21-point Hand Skeleton
          SizedBox(
            height: 380,
            width: double.infinity,
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

          // Live Gesture Prediction HUD at Top-Left
          if (widget.isDetecting && _liveHands.isNotEmpty)
            Positioned(
              top: 12,
              left: 12,
              child: _liveGesture != null
                  ? InkWell(
                      onTap: () => widget.onGestureConfirmed?.call(_liveGesture!),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.78),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.cyanAccent.withValues(alpha: 0.85),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                value: holdProgress,
                                strokeWidth: 3,
                                backgroundColor: Colors.white24,
                                color: Colors.cyanAccent,
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
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  '${_liveHands.length} tangan • Tahan stabil / ketuk',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11,
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
                        color: Colors.black.withValues(alpha: 0.72),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.amber.withValues(alpha: 0.75),
                          width: 1.2,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: Colors.amberAccent,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.targetMode == BisindoTargetMode.numbers
                                ? 'Bentuk angka 0-9 BISINDO (${_liveHands.length} tangan)'
                                : 'Gerakan belum sesuai abjad BISINDO (${_liveHands.length} tangan)',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),

          // Camera Overlay Controls at Top-Right
          Positioned(
            top: 12,
            right: 12,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.65),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Text(
                    widget.targetMode == BisindoTargetMode.numbers
                        ? '🔢 Angka 0-9'
                        : '🔤 Abjad A-Z',
                    style: const TextStyle(
                      color: Colors.white,
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
                    icon: const Icon(Icons.cameraswitch, color: Colors.white),
                    style:
                        IconButton.styleFrom(backgroundColor: Colors.black54),
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
                  color: Colors.black26,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.75),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white24,
                          width: 1,
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.play_circle_fill,
                            color: Colors.blueAccent,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Deteksi Standby • Ketuk untuk Memulai',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
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
            bottom: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: widget.isDetecting
                    ? (_liveHands.isNotEmpty
                        ? (_liveGesture != null
                            ? Colors.green.withValues(alpha: 0.85)
                            : Colors.blueGrey.shade800.withValues(alpha: 0.85))
                        : Colors.orange.shade800.withValues(alpha: 0.85))
                    : Colors.black54,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(
                    widget.isDetecting
                        ? (_liveHands.isNotEmpty
                            ? Icons.back_hand
                            : Icons.pan_tool_alt_outlined)
                        : Icons.pause_circle_outline,
                    color: Colors.white,
                    size: 14,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    widget.isDetecting
                        ? (_liveHands.isNotEmpty
                            ? 'Tangan Terdeteksi (${_liveHands.length})'
                            : 'Arahkan Tangan ke Kamera')
                        : 'Standby',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
