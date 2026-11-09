import 'dart:developer' as dev;
import 'package:flutter/services.dart';
import '../../domain/entities/gesture.dart';
import 'tflite_classifier_service.dart';

/// Web implementation of [TfliteClassifierService].
/// Note: TensorFlow Lite C-bindings (dart:ffi) are unavailable on the Web.
/// This web implementation provides safe label loading from assets and a fallback
/// prediction mechanism so that the Flutter app can be developed, previewed, and tested in Chrome.
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
        'TFLite Web fallback initialized with ${_labels.length} BISINDO classes (Web Mode)',
        name: 'TfliteClassifierWeb',
      );
    } catch (e) {
      dev.log('Failed to load labels on web: $e', name: 'TfliteClassifierWeb');
      _isLoaded = false;
    }
  }

  @override
  Future<Gesture> classify(dynamic input) async {
    if (_labels.isEmpty) {
      return const Gesture(label: 'A', confidence: 0.90);
    }
    // Safe web fallback prediction
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
