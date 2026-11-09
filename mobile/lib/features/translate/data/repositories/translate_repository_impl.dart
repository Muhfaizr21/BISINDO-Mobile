import '../../domain/entities/gesture.dart';
import '../../domain/entities/translation.dart';
import '../../domain/repositories/translate_repository.dart';
import '../datasources/tflite_classifier_service.dart';
import '../datasources/translate_local_data_source.dart';
import '../datasources/translate_remote_data_source.dart';

class TranslateRepositoryImpl implements TranslateRepository {
  final TranslateLocalDataSource localDataSource;
  final TranslateRemoteDataSource remoteDataSource;
  final TfliteClassifierService? classifierService;

  TranslateRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    this.classifierService,
  });

  @override
  Future<Translation> translateGestures(List<Gesture> gestures) async {
    final text = gestures.map((g) => g.label).join(' ');
    return Translation(
      text: text,
      gestures: gestures,
      timestamp: DateTime.now(),
    );
  }

  @override
  Future<Gesture> classifyLandmarks(dynamic landmarks) async {
    if (classifierService != null) {
      return await classifierService!.classify(landmarks);
    }
    return const Gesture(label: 'A', confidence: 0.95);
  }
}
