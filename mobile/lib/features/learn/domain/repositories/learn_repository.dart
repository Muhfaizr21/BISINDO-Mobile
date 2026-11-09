import '../entities/learn_item.dart';

abstract class LearnRepository {
  Future<List<LearnItem>> getLearnMaterials();
}

