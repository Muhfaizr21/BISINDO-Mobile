import '../../domain/entities/gesture.dart';

export 'tflite_classifier_service_web.dart'
    if (dart.library.ffi) 'tflite_classifier_service_native.dart';

abstract class TfliteClassifierService {
  Future<void> initialize();
  Future<Gesture> classify(dynamic input);
  List<String> get labels;
  bool get isModelLoaded;
  void dispose();
}
