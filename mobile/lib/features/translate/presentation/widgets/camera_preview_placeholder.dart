import 'package:flutter/material.dart';

class CameraPreviewPlaceholder extends StatelessWidget {
  final bool isDetecting;

  const CameraPreviewPlaceholder({
    super.key,
    this.isDetecting = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 350,
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDetecting ? Colors.green : Colors.grey.shade700,
          width: 2,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isDetecting ? Icons.videocam : Icons.videocam_off,
              color: isDetecting ? Colors.greenAccent : Colors.white54,
              size: 56,
            ),
            const SizedBox(height: 12),
            Text(
              isDetecting
                  ? 'Area Kamera Aktif (Placeholder)\nDeteksi MediaPipe siap diintegrasikan'
                  : 'Kamera Tidak Aktif\nTekan Mulai untuk mendeteksi gesture',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDetecting ? Colors.white : Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

