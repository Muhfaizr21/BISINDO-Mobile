import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/hand_landmarks.dart';
import '../../domain/services/camera_service.dart';
import 'hand_landmarks_painter.dart';

class CameraViewWidget extends StatefulWidget {
  final CameraService cameraService;
  final bool isDetecting;
  final List<HandSkeleton> detectedHands;

  const CameraViewWidget({
    super.key,
    required this.cameraService,
    required this.isDetecting,
    this.detectedHands = const [],
  });

  @override
  State<CameraViewWidget> createState() => _CameraViewWidgetState();
}

class _CameraViewWidgetState extends State<CameraViewWidget> with WidgetsBindingObserver {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
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
                'Menyiapkan kamera...',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
      );
    }

    final controller = widget.cameraService.controller;

    // Fallback if no camera hardware is available (e.g. desktop or some emulators)
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
                  color: widget.isDetecting ? Colors.greenAccent : Colors.white54,
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
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.white),
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

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Live Camera Preview
          SizedBox(
            height: 380,
            width: double.infinity,
            child: CameraPreview(controller),
          ),

          // Hand Landmarks Skeleton Overlay
          Positioned.fill(
            child: CustomPaint(
              painter: HandLandmarksPainter(
                hands: widget.detectedHands,
                isFrontCamera: isFrontCamera,
              ),
            ),
          ),

          // Camera Overlay Controls
          Positioned(
            top: 12,
            right: 12,
            child: Row(
              children: [
                if (widget.cameraService.cameras.length > 1)
                  IconButton.filledTonal(
                    tooltip: 'Ganti Kamera',
                    onPressed: () async {
                      await widget.cameraService.switchCamera();
                      if (mounted) setState(() {});
                    },
                    icon: const Icon(Icons.cameraswitch, color: Colors.white),
                    style: IconButton.styleFrom(backgroundColor: Colors.black54),
                  ),
              ],
            ),
          ),

          // Status Badge at bottom left
          Positioned(
            bottom: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: widget.isDetecting ? Colors.green.withValues(alpha: 0.8) : Colors.black54,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(
                    widget.isDetecting ? Icons.lens : Icons.pause_circle_outline,
                    color: Colors.white,
                    size: 14,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    widget.isDetecting ? 'Mendeteksi Gestur' : 'Standby',
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

