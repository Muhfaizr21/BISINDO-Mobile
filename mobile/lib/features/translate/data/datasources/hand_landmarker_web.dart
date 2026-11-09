import 'dart:convert';
import 'dart:js_interop';
import '../../domain/services/hand_landmarker_service.dart';

@JS('bisindoInitMediaPipe')
external void _bisindoInitMediaPipe();

@JS('bisindoDetectFrameJson')
external JSString? _bisindoDetectFrameJson();

class HandLandmarkerPlaceholderDataSource implements HandLandmarkerService {
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  @override
  Future<void> initialize() async {
    try {
      _bisindoInitMediaPipe();
      _isInitialized = true;
    } catch (_) {
      _isInitialized = false;
    }
  }

  @override
  Future<List<HandLandmarkerResult>> detect(dynamic imageInput) async {
    try {
      final jsResult = _bisindoDetectFrameJson();
      if (jsResult == null) return const [];

      final jsonStr = jsResult.toDart;
      if (jsonStr.isEmpty) return const [];

      final decoded = jsonDecode(jsonStr) as Map<String, dynamic>;
      final handsRaw = decoded['hands'] as List<dynamic>? ?? const [];
      if (handsRaw.isEmpty) return const [];

      final results = <HandLandmarkerResult>[];
      for (final h in handsRaw) {
        final handMap = h as Map<String, dynamic>;
        final handedness = (handMap['handedness'] as String?) ?? 'Right';
        final confidence = (handMap['confidence'] as num?)?.toDouble() ?? 0.95;
        final lmList = handMap['landmarks'] as List<dynamic>? ?? const [];

        if (lmList.length >= 21) {
          final points = lmList.map((pt) {
            final ptMap = pt as Map<String, dynamic>;
            return LandmarkPoint(
              x: (ptMap['x'] as num).toDouble(),
              y: (ptMap['y'] as num).toDouble(),
              z: (ptMap['z'] as num?)?.toDouble() ?? 0.0,
            );
          }).toList();

          results.add(
            HandLandmarkerResult(
              landmarks: points,
              handedness: handedness,
              score: confidence,
            ),
          );
        }
      }
      return results;
    } catch (_) {
      return const [];
    }
  }

  @override
  Future<void> dispose() async {
    _isInitialized = false;
  }
}

