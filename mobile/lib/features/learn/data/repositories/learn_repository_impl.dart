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
    // Attempt local first, then remote as fallback
    final localData = await localDataSource.getCachedLearnMaterials();
    if (localData.isNotEmpty) {
      return localData;
    }
    return await remoteDataSource.fetchLearnMaterials();
  }
}

