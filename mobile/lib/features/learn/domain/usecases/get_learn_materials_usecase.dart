import '../../../../core/utils/usecase.dart';
import '../entities/learn_item.dart';
import '../repositories/learn_repository.dart';

class GetLearnMaterialsUseCase implements UseCase<List<LearnItem>, NoParams> {
  final LearnRepository repository;

  GetLearnMaterialsUseCase(this.repository);

  @override
  Future<List<LearnItem>> call(NoParams params) async {
    return await repository.getLearnMaterials();
  }
}

