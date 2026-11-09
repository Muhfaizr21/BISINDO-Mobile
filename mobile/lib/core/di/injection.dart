import '../../core/network/backend_health_service.dart';
import '../../features/history/data/datasources/history_local_data_source.dart';
import '../../features/history/data/datasources/history_remote_data_source.dart';
import '../../features/history/data/repositories/history_repository_impl.dart';
import '../../features/history/domain/repositories/history_repository.dart';
import '../../features/history/domain/usecases/delete_history_item_usecase.dart';
import '../../features/history/domain/usecases/get_history_usecase.dart';
import '../../features/history/domain/usecases/save_history_item_usecase.dart';
import '../../features/history/presentation/bloc/history_bloc.dart';
import '../../features/learn/data/datasources/learn_local_data_source.dart';
import '../../features/learn/data/datasources/learn_remote_data_source.dart';
import '../../features/learn/data/repositories/learn_repository_impl.dart';
import '../../features/learn/domain/repositories/learn_repository.dart';
import '../../features/learn/domain/usecases/get_learn_materials_usecase.dart';
import '../../features/learn/presentation/bloc/learn_bloc.dart';
import '../../features/translate/data/datasources/hand_landmarker_placeholder_data_source.dart';
import '../../features/translate/data/datasources/tflite_classifier_service.dart';
import '../../features/translate/data/datasources/translate_local_data_source.dart';
import '../../features/translate/data/datasources/translate_remote_data_source.dart';
import '../../features/translate/data/repositories/translate_repository_impl.dart';
import '../../features/translate/data/services/camera_service_impl.dart';
import '../../features/translate/domain/repositories/translate_repository.dart';
import '../../features/translate/domain/services/camera_service.dart';
import '../../features/translate/domain/services/hand_landmarker_service.dart';
import '../../features/translate/domain/services/tts_service.dart';
import '../../features/translate/domain/usecases/translate_gesture_usecase.dart';
import '../../features/translate/presentation/bloc/translate_bloc.dart';

class ServiceLocator {
  // Network / Health Service
  late final BackendHealthService backendHealthService;

  // Translate
  late final CameraService cameraService;
  late final HandLandmarkerService handLandmarkerService;
  late final TfliteClassifierService tfliteClassifierService;
  late final TtsService ttsService;
  late final TranslateLocalDataSource translateLocalDataSource;
  late final TranslateRemoteDataSource translateRemoteDataSource;
  late final TranslateRepository translateRepository;
  late final TranslateGestureUseCase translateGestureUseCase;

  // Learn
  late final LearnLocalDataSource learnLocalDataSource;
  late final LearnRemoteDataSource learnRemoteDataSource;
  late final LearnRepository learnRepository;
  late final GetLearnMaterialsUseCase getLearnMaterialsUseCase;

  // History
  late final HistoryLocalDataSource historyLocalDataSource;
  late final HistoryRemoteDataSource historyRemoteDataSource;
  late final HistoryRepository historyRepository;
  late final GetHistoryUseCase getHistoryUseCase;
  late final SaveHistoryItemUseCase saveHistoryItemUseCase;
  late final DeleteHistoryItemUseCase deleteHistoryItemUseCase;

  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  void init() {
    backendHealthService = BackendHealthService();
    cameraService = CameraServiceImpl();

    // Translate dependencies
    handLandmarkerService = HandLandmarkerPlaceholderDataSource();
    tfliteClassifierService = TfliteClassifierServiceImpl();
    ttsService = TtsServiceImpl();
    translateLocalDataSource = TranslateLocalDataSourceImpl();
    translateRemoteDataSource = TranslateRemoteDataSourceImpl();
    translateRepository = TranslateRepositoryImpl(
      localDataSource: translateLocalDataSource,
      remoteDataSource: translateRemoteDataSource,
      classifierService: tfliteClassifierService,
    );
    translateGestureUseCase = TranslateGestureUseCase(translateRepository);

    // Learn dependencies
    learnLocalDataSource = LearnLocalDataSourceImpl();
    learnRemoteDataSource = LearnRemoteDataSourceImpl();
    learnRepository = LearnRepositoryImpl(
      localDataSource: learnLocalDataSource,
      remoteDataSource: learnRemoteDataSource,
    );
    getLearnMaterialsUseCase = GetLearnMaterialsUseCase(learnRepository);

    // History dependencies
    historyLocalDataSource = HistoryLocalDataSourceImpl();
    historyRemoteDataSource = HistoryRemoteDataSourceImpl();
    historyRepository = HistoryRepositoryImpl(
      localDataSource: historyLocalDataSource,
      remoteDataSource: historyRemoteDataSource,
    );
    getHistoryUseCase = GetHistoryUseCase(historyRepository);
    saveHistoryItemUseCase = SaveHistoryItemUseCase(historyRepository);
    deleteHistoryItemUseCase = DeleteHistoryItemUseCase(historyRepository);
  }

  TranslateBloc createTranslateBloc() =>
      TranslateBloc(translateGestureUseCase: translateGestureUseCase);

  LearnBloc createLearnBloc() =>
      LearnBloc(getLearnMaterialsUseCase: getLearnMaterialsUseCase);

  HistoryBloc createHistoryBloc() => HistoryBloc(
        getHistoryUseCase: getHistoryUseCase,
        saveHistoryItemUseCase: saveHistoryItemUseCase,
        deleteHistoryItemUseCase: deleteHistoryItemUseCase,
        repository: historyRepository,
      );
}

final sl = ServiceLocator();
