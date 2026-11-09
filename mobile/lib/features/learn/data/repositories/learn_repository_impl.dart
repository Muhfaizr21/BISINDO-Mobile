import '../../domain/entities/learn_item.dart';
import '../../domain/repositories/learn_repository.dart';
import '../datasources/learn_local_data_source.dart';
import '../datasources/learn_remote_data_source.dart';

class LearnRepositoryImpl implements LearnRepository {
  final LearnLocalDataSource localDataSource;
  final LearnRemoteDataSource remoteDataSource;

  LearnRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<List<LearnItem>> getLearnMaterials() async {
    final localData = await localDataSource.getCachedLearnMaterials();
    final localMap = {for (final item in localData) item.id: item};

    try {
      final remoteData = await remoteDataSource.fetchLearnMaterials();
      if (remoteData.isNotEmpty) {
        return remoteData.map((item) {
          final fallbackImage = localMap[item.id]?.imageAsset;
          if ((item.imageAsset == null || item.imageAsset!.isEmpty) &&
              fallbackImage != null) {
            return LearnItem(
              id: item.id,
              title: item.title,
              description: item.description,
              category: item.category,
              imageAsset: fallbackImage,
            );
          }
          return item;
        }).toList();
      }
    } catch (_) {
      // Fallback to local catalog if offline
    }

    return localData;
  }
}
