import '../../domain/entities/learn_item.dart';

abstract class LearnLocalDataSource {
  Future<List<LearnItem>> getCachedLearnMaterials();
  Future<void> cacheLearnMaterials(List<LearnItem> items);
}

class LearnLocalDataSourceImpl implements LearnLocalDataSource {
  @override
  Future<List<LearnItem>> getCachedLearnMaterials() async {
    // Return sample offline data
    return const [
      LearnItem(
        id: '1',
        title: 'Alfabet A - Z',
        description: 'Belajar gestur tangan untuk alfabet BISINDO/SIBI',
        category: 'Dasar',
      ),
      LearnItem(
        id: '2',
        title: 'Angka 1 - 10',
        description: 'Belajar gestur tangan untuk angka 1 sampai 10',
        category: 'Dasar',
      ),
      LearnItem(
        id: '3',
        title: 'Sapaan Sehari-hari',
        description: 'Belajar gestur untuk Halo, Terima Kasih, dan Selamat Pagi',
        category: 'Percakapan',
      ),
    ];
  }

  @override
  Future<void> cacheLearnMaterials(List<LearnItem> items) async {
    // Placeholder for Hive cache
  }
}

