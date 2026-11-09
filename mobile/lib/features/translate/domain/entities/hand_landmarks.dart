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

  /// Standard normalized 21-landmark hand skeleton for rendering and testing
  factory HandSkeleton.sample({
    String handedness = 'Right',
    double confidence = 0.95,
  }) {
    return HandSkeleton(
      handedness: handedness,
      confidence: confidence,
      landmarks: const [
        NormalizedLandmark(x: 0.50, y: 0.80), // 0: Wrist
        // Thumb
        NormalizedLandmark(x: 0.44, y: 0.74), // 1
        NormalizedLandmark(x: 0.39, y: 0.67), // 2
        NormalizedLandmark(x: 0.35, y: 0.60), // 3
        NormalizedLandmark(x: 0.33, y: 0.53), // 4
        // Index
        NormalizedLandmark(x: 0.46, y: 0.57), // 5
        NormalizedLandmark(x: 0.44, y: 0.48), // 6
        NormalizedLandmark(x: 0.43, y: 0.41), // 7
        NormalizedLandmark(x: 0.42, y: 0.35), // 8
        // Middle
        NormalizedLandmark(x: 0.50, y: 0.56), // 9
        NormalizedLandmark(x: 0.50, y: 0.45), // 10
        NormalizedLandmark(x: 0.50, y: 0.38), // 11
        NormalizedLandmark(x: 0.50, y: 0.32), // 12
        // Ring
        NormalizedLandmark(x: 0.54, y: 0.57), // 13
        NormalizedLandmark(x: 0.55, y: 0.47), // 14
        NormalizedLandmark(x: 0.56, y: 0.41), // 15
        NormalizedLandmark(x: 0.57, y: 0.36), // 16
        // Pinky
        NormalizedLandmark(x: 0.58, y: 0.61), // 17
        NormalizedLandmark(x: 0.60, y: 0.54), // 18
        NormalizedLandmark(x: 0.61, y: 0.48), // 19
        NormalizedLandmark(x: 0.62, y: 0.43), // 20
      ],
    );
  }

  @override
  List<Object?> get props => [landmarks, handedness, confidence];
}
