import 'package:equatable/equatable.dart';

class LandmarkPoint extends Equatable {
  final double x;
  final double y;
  final double z;

  const LandmarkPoint({
    required this.x,
    required this.y,
    this.z = 0.0,
  });

  @override
  List<Object?> get props => [x, y, z];
}

class HandLandmarkerResult extends Equatable {
  final List<LandmarkPoint> landmarks;
  final String handedness; // 'Left' or 'Right'
  final double score;

  const HandLandmarkerResult({
    required this.landmarks,
    this.handedness = 'Right',
    this.score = 1.0,
  });

  @override
  List<Object?> get props => [landmarks, handedness, score];
}

/// Interface for hand landmark detection.
/// Initially implemented as a placeholder, to be integrated with MediaPipe Hand Landmarker later.
abstract class HandLandmarkerService {
  Future<void> initialize();
  Future<List<HandLandmarkerResult>> detect(dynamic imageInput);
  Future<void> dispose();
}

