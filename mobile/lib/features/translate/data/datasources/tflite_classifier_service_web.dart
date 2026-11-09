import 'dart:developer' as dev;
import 'package:flutter/services.dart';
import '../../domain/entities/gesture.dart';
import '../../domain/entities/hand_landmarks.dart';
import 'bisindo_landmark_classifier.dart';
import 'tflite_classifier_service.dart';

/// Web implementation of [TfliteClassifierService].
/// Uses MediaPipe 21-point 3D Hand Landmarks + [BisindoLandmarkClassifier]
/// for real-time 1-hand and 2-hand BISINDO gesture recognition on Web/Chrome.
class TfliteClassifierServiceImpl implements TfliteClassifierService {
  static const String _labelsPath = 'assets/models/labels.txt';

  List<String> _labels = [];
  bool _isLoaded = false;

  @override
  bool get isModelLoaded => _isLoaded;

  @override
  List<String> get labels => List.unmodifiable(_labels);

  @override
  Future<void> initialize() async {
    try {
      final labelData = await rootBundle.loadString(_labelsPath);
      _labels = labelData
          .split('\n')
          .map((line) => line.trim())
          .where((line) => line.isNotEmpty)
          .toList();
      _isLoaded = true;
      dev.log(
        'BISINDO Web Classifier initialized with ${_labels.length} classes',
        name: 'TfliteClassifierWeb',
      );
    } catch (e) {
      dev.log('Failed to load labels on web: $e', name: 'TfliteClassifierWeb');
      _isLoaded = false;
    }
  }

  @override
  Future<Gesture> classify(dynamic input) async {
    if (input is List<HandSkeleton>) {
      return BisindoLandmarkClassifier.classifyHands(input);
    }
    if (_labels.isEmpty) {
      return const Gesture(label: 'A', confidence: 0.90);
    }
    return Gesture(
      label: _labels.first,
      confidence: 0.90,
    );
  }

  @override
  void dispose() {
    _isLoaded = false;
  }
}
