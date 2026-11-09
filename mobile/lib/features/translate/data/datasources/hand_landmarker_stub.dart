import '../../domain/services/hand_landmarker_service.dart';

class HandLandmarkerPlaceholderDataSource implements HandLandmarkerService {
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  @override
  Future<void> initialize() async {
    _isInitialized = true;
  }

  @override
  Future<List<HandLandmarkerResult>> detect(dynamic imageInput) async {
    return const [];
  }

  @override
  Future<void> dispose() async {
    _isInitialized = false;
  }
}

