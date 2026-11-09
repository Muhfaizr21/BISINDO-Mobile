import '../../domain/entities/learn_item.dart';

abstract class LearnLocalDataSource {
  Future<List<LearnItem>> getCachedLearnMaterials();
  Future<void> cacheLearnMaterials(List<LearnItem> items);
}

class LearnLocalDataSourceImpl implements LearnLocalDataSource {
  static const List<LearnItem> _defaultMaterials = [
    // 26 BISINDO Alphabet Classes with image assets from dataset
    LearnItem(
      id: 'bisindo-a',
      title: 'Huruf A',
      description: 'Kedua tangan mengepal dengan ibu jari tangan dominan tegak bersandar pada sisi jari telunjuk.',
      category: 'Abjad BISINDO',
      imageAsset: 'assets/images/bisindo/A.jpg',
    ),
    LearnItem(
      id: 'bisindo-b',
      title: 'Huruf B',
      description: 'Kedua tangan terbuka tegak ke atas, saling mendekat dan sejajar di depan dada.',
      category: 'Abjad BISINDO',
      imageAsset: 'assets/images/bisindo/B.jpg',
    ),
    LearnItem(
      id: 'bisindo-c',
      title: 'Huruf C',
      description: 'Tangan dominan membentuk lengkungan huruf C menghadap ke samping atau ke depan.',
      category: 'Abjad BISINDO',
      imageAsset: 'assets/images/bisindo/C.jpg',
    ),
    LearnItem(
      id: 'bisindo-d',
      title: 'Huruf D',
      description: 'Jari telunjuk tangan dominan tegak lurus ke atas, jari lainnya melingkar menyentuh ibu jari.',
      category: 'Abjad BISINDO',
      imageAsset: 'assets/images/bisindo/D.jpg',
    ),
    LearnItem(
      id: 'bisindo-e',
      title: 'Huruf E',
      description: 'Seluruh ujung jari tangan dominan ditekuk ke bawah merapat menyentuh ujung ibu jari.',
      category: 'Abjad BISINDO',
      imageAsset: 'assets/images/bisindo/E.jpg',
    ),
    LearnItem(
      id: 'bisindo-f',
      title: 'Huruf F',
      description: 'Ujung jari telunjuk dan ibu jari bersentuhan membentuk lingkaran kecil, tiga jari lainnya tegak ke atas.',
      category: 'Abjad BISINDO',
      imageAsset: 'assets/images/bisindo/F.jpg',
    ),
    LearnItem(
      id: 'bisindo-g',
      title: 'Huruf G',
      description: 'Ibu jari dan jari telunjuk direntangkan sejajar secara horizontal ke arah depan/samping.',
      category: 'Abjad BISINDO',
      imageAsset: 'assets/images/bisindo/G.jpg',
    ),
    LearnItem(
      id: 'bisindo-h',
      title: 'Huruf H',
      description: 'Jari telunjuk dan jari tengah direntangkan bersamaan horizontal ke samping/depan.',
      category: 'Abjad BISINDO',
      imageAsset: 'assets/images/bisindo/H.jpg',
    ),
    LearnItem(
      id: 'bisindo-i',
      title: 'Huruf I',
      description: 'Jari kelingking terangkat lurus tegak ke atas, keempat jari lainnya tertutup rapat.',
      category: 'Abjad BISINDO',
      imageAsset: 'assets/images/bisindo/I.jpg',
    ),
    LearnItem(
      id: 'bisindo-j',
      title: 'Huruf J',
      description: 'Jari kelingking terangkat ke atas lalu digerakkan meliuk membentuk garis lengkung huruf J di udara.',
      category: 'Abjad BISINDO',
      imageAsset: 'assets/images/bisindo/J.jpg',
    ),
    LearnItem(
      id: 'bisindo-k',
      title: 'Huruf K',
      description: 'Jari telunjuk tegak ke atas, jari tengah miring ke depan, dengan ibu jari berada di antara keduanya.',
      category: 'Abjad BISINDO',
      imageAsset: 'assets/images/bisindo/K.jpg',
    ),
    LearnItem(
      id: 'bisindo-l',
      title: 'Huruf L',
      description: 'Ibu jari dan jari telunjuk direntangkan tegak membentuk sudut siku-siku 90 derajat menyerupai huruf L.',
      category: 'Abjad BISINDO',
      imageAsset: 'assets/images/bisindo/L.jpg',
    ),
    LearnItem(
      id: 'bisindo-m',
      title: 'Huruf M',
      description: 'Tiga jari tangan (telunjuk, tengah, manis) ditekuk ke bawah menutupi ibu jari.',
      category: 'Abjad BISINDO',
      imageAsset: 'assets/images/bisindo/M.jpg',
    ),
    LearnItem(
      id: 'bisindo-n',
      title: 'Huruf N',
      description: 'Dua jari tangan (telunjuk dan tengah) ditekuk ke bawah menutupi ibu jari.',
      category: 'Abjad BISINDO',
      imageAsset: 'assets/images/bisindo/N.jpg',
    ),
    LearnItem(
      id: 'bisindo-o',
      title: 'Huruf O',
      description: 'Seluruh jari tangan dilengkungkan merata membentuk lingkaran bulat sempurna huruf O.',
      category: 'Abjad BISINDO',
      imageAsset: 'assets/images/bisindo/O.jpg',
    ),
    LearnItem(
      id: 'bisindo-p',
      title: 'Huruf P',
      description: 'Bentuk gestur huruf K yang diarahkan mengarah ke bawah.',
      category: 'Abjad BISINDO',
      imageAsset: 'assets/images/bisindo/P.jpg',
    ),
    LearnItem(
      id: 'bisindo-q',
      title: 'Huruf Q',
      description: 'Bentuk gestur huruf G yang diarahkan miring ke bawah.',
      category: 'Abjad BISINDO',
      imageAsset: 'assets/images/bisindo/Q.jpg',
    ),
    LearnItem(
      id: 'bisindo-r',
      title: 'Huruf R',
      description: 'Jari telunjuk dan jari tengah disilangkan satu sama lain ke atas secara tegak.',
      category: 'Abjad BISINDO',
      imageAsset: 'assets/images/bisindo/R.jpg',
    ),
    LearnItem(
      id: 'bisindo-s',
      title: 'Huruf S',
      description: 'Tangan mengepal erat dengan ibu jari ditekuk menyilang di depan kepalan jari-jemari.',
      category: 'Abjad BISINDO',
      imageAsset: 'assets/images/bisindo/S.jpg',
    ),
    LearnItem(
      id: 'bisindo-t',
      title: 'Huruf T',
      description: 'Ibu jari diselipkan di antara jari telunjuk dan jari tengah dalam posisi mengepal.',
      category: 'Abjad BISINDO',
      imageAsset: 'assets/images/bisindo/T.jpg',
    ),
    LearnItem(
      id: 'bisindo-u',
      title: 'Huruf U',
      description: 'Jari telunjuk dan jari tengah ditegakkan ke atas secara rapat sejajar.',
      category: 'Abjad BISINDO',
      imageAsset: 'assets/images/bisindo/U.jpg',
    ),
    LearnItem(
      id: 'bisindo-v',
      title: 'Huruf V',
      description: 'Jari telunjuk dan jari tengah ditegakkan ke atas membentuk huruf V (victory) merenggang.',
      category: 'Abjad BISINDO',
      imageAsset: 'assets/images/bisindo/V.jpg',
    ),
    LearnItem(
      id: 'bisindo-w',
      title: 'Huruf W',
      description: 'Tiga jari (telunjuk, tengah, manis) ditegakkan ke atas membentuk huruf W merenggang.',
      category: 'Abjad BISINDO',
      imageAsset: 'assets/images/bisindo/W.jpg',
    ),
    LearnItem(
      id: 'bisindo-x',
      title: 'Huruf X',
      description: 'Jari telunjuk sedikit ditekuk membentuk kait atau lengkungan kait kecil.',
      category: 'Abjad BISINDO',
      imageAsset: 'assets/images/bisindo/X.jpg',
    ),
    LearnItem(
      id: 'bisindo-y',
      title: 'Huruf Y',
      description: 'Ibu jari dan kelingking direntangkan keluar ke samping, tiga jari tengah dilipat ke dalam telapak.',
      category: 'Abjad BISINDO',
      imageAsset: 'assets/images/bisindo/Y.jpg',
    ),
    LearnItem(
      id: 'bisindo-z',
      title: 'Huruf Z',
      description: 'Jari telunjuk ditegakkan lalu digerakkan menggores pola zigzag huruf Z di udara.',
      category: 'Abjad BISINDO',
      imageAsset: 'assets/images/bisindo/Z.jpg',
    ),
    // Angka & Percakapan
    LearnItem(
      id: 'angka-1-5',
      title: 'Angka 1 sampai 5',
      description: 'Hitungan jari dasar dari satu jari terangkat hingga lima jari terbuka lebar.',
      category: 'Angka',
    ),
    LearnItem(
      id: 'salam-dasar',
      title: 'Sapaan: Halo dan Terima Kasih',
      description: 'Gestur sapaan ramah dan ucapan terima kasih standar BISINDO.',
      category: 'Percakapan',
    ),
  ];

  @override
  Future<List<LearnItem>> getCachedLearnMaterials() async {
    return _defaultMaterials;
  }

  @override
  Future<void> cacheLearnMaterials(List<LearnItem> items) async {
    // Cache persistence
  }
}
