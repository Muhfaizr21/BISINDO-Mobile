import '../../domain/services/hand_landmarker_service.dart';

/// Placeholder implementation of [HandLandmarkerService].
/// This will be replaced with the actual MediaPipe Hand Landmarker implementation.
class HandLandmarkerPlaceholderDataSource implements HandLandmarkerService {
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  @override
  Future<void> initialize() async {
    // Placeholder initialization
    _isInitialized = true;
  }

  @override
  Future<List<HandLandmarkerResult>> detect(dynamic imageInput) async {
    // Return empty or dummy landmarks as placeholder
    return const [];
  }

  @override
  Future<void> dispose() async {
    _isInitialized = false;
  }
}

