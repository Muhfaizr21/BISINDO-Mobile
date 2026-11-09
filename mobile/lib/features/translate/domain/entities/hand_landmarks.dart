import 'package:equatable/equatable.dart';

class NormalizedLandmark extends Equatable {
  final double x; // [0.0, 1.0]
  final double y; // [0.0, 1.0]
  final double z; // Depth relative to wrist

  const NormalizedLandmark({
    required this.x,
    required this.y,
    this.z = 0.0,
  });

  @override
  List<Object?> get props => [x, y, z];
}

class HandSkeleton extends Equatable {
  final List<NormalizedLandmark> landmarks; // exactly 21 points
  final String handedness; // "Left" or "Right"
  final double confidence;

  const HandSkeleton({
    required this.landmarks,
    this.handedness = 'Right',
    this.confidence = 1.0,
  });

  // Standard MediaPipe 21 Hand Landmark Connections
  static const List<List<int>> connections = [
    // Thumb
    [0, 1], [1, 2], [2, 3], [3, 4],
    // Index finger
    [0, 5], [5, 6], [6, 7], [7, 8],
    // Middle finger
    [5, 9], [9, 10], [10, 11], [11, 12],
    // Ring finger
    [9, 13], [13, 14], [14, 15], [15, 16],
    // Pinky
    [13, 17], [17, 18], [18, 19], [19, 20],
    // Palm base
    [0, 17],
  ];

  @override
  List<Object?> get props => [landmarks, handedness, confidence];
}

