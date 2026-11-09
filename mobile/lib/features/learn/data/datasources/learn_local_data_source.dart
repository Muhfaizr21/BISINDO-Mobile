import '../../domain/entities/learn_item.dart';

abstract class LearnLocalDataSource {
  Future<List<LearnItem>> getCachedLearnMaterials();
  Future<void> cacheLearnMaterials(List<LearnItem> items);
}

class LearnLocalDataSourceImpl implements LearnLocalDataSource {
  static const List<LearnItem> _defaultMaterials = [
    // 26 BISINDO Alphabet Classes synchronized with dataset images and gesture classifier
    LearnItem(
      id: 'bisindo-a',
      title: 'Huruf A',
      description: 'Kedua ujung jari telunjuk dipertemukan membentuk puncak segitiga dan kedua ibu jari bertemu mendatar di bawahnya membentuk huruf A.',
      category: 'Abjad BISINDO',
      imageAsset: 'assets/images/bisindo/A.jpg',
    ),
    LearnItem(
      id: 'bisindo-b',
      title: 'Huruf B',
      description: 'Jari telunjuk satu tangan ditegakkan vertikal sebagai tiang, dan tiga jari tangan lainnya ditempelkan horizontal membentuk huruf B.',
      category: 'Abjad BISINDO',
      imageAsset: 'assets/images/bisindo/B.jpg',
    ),
    LearnItem(
      id: 'bisindo-c',
      title: 'Huruf C',
      description: 'Satu tangan membuka ibu jari dan melengkungkan jari-jari lainnya membentuk lengkungan huruf C.',
      category: 'Abjad BISINDO',
      imageAsset: 'assets/images/bisindo/C.jpg',
    ),
    LearnItem(
      id: 'bisindo-d',
      title: 'Huruf D',
      description: 'Jari telunjuk satu tangan ditegakkan vertikal dan ibu jari serta telunjuk tangan lainnya membentuk lengkungan C menempel menjadi huruf D.',
      category: 'Abjad BISINDO',
      imageAsset: 'assets/images/bisindo/D.jpg',
    ),
    LearnItem(
      id: 'bisindo-e',
      title: 'Huruf E',
      description: 'Tiga jari (telunjuk, tengah, manis) pada satu tangan direntangkan mendatar secara horizontal menyerupai tiga garis huruf E.',
      category: 'Abjad BISINDO',
      imageAsset: 'assets/images/bisindo/E.jpg',
    ),
    LearnItem(
      id: 'bisindo-f',
      title: 'Huruf F',
      description: 'Jari telunjuk satu tangan ditegakkan vertikal, lalu jari telunjuk dan jari tengah tangan lainnya ditempelkan mendatar di bagian atas.',
      category: 'Abjad BISINDO',
      imageAsset: 'assets/images/bisindo/F.jpg',
    ),
    LearnItem(
      id: 'bisindo-g',
      title: 'Huruf G',
      description: 'Kedua tangan mengepal rapat dan ditumpuk secara vertikal (satu kepalan tangan di atas kepalan tangan lainnya).',
      category: 'Abjad BISINDO',
      imageAsset: 'assets/images/bisindo/G.jpg',
    ),
    LearnItem(
      id: 'bisindo-h',
      title: 'Huruf H',
      description: 'Kedua jari telunjuk ditegakkan sejajar vertikal dengan ibu jari merentang mendatar di tengah sebagai penghubung huruf H.',
      category: 'Abjad BISINDO',
      imageAsset: 'assets/images/bisindo/H.jpg',
    ),
    LearnItem(
      id: 'bisindo-i',
      title: 'Huruf I',
      description: 'Jari kelingking satu tangan ditegakkan lurus ke atas, sedangkan keempat jari lainnya mengepal rapat.',
      category: 'Abjad BISINDO',
      imageAsset: 'assets/images/bisindo/I.jpg',
    ),
    LearnItem(
      id: 'bisindo-j',
      title: 'Huruf J',
      description: 'Jari kelingking satu tangan diangkat lalu dimiringkan membentuk ayunan lengkung huruf J.',
      category: 'Abjad BISINDO',
      imageAsset: 'assets/images/bisindo/J.jpg',
    ),
    LearnItem(
      id: 'bisindo-k',
      title: 'Huruf K',
      description: 'Jari telunjuk satu tangan tegak vertikal, sedangkan telunjuk dan jari tengah tangan lainnya menyudut menempel di bagian tengahnya.',
      category: 'Abjad BISINDO',
      imageAsset: 'assets/images/bisindo/K.jpg',
    ),
    LearnItem(
      id: 'bisindo-l',
      title: 'Huruf L',
      description: 'Ibu jari dan jari telunjuk satu tangan direntangkan tegak lurus 90 derajat membentuk huruf L.',
      category: 'Abjad BISINDO',
      imageAsset: 'assets/images/bisindo/L.jpg',
    ),
    LearnItem(
      id: 'bisindo-m',
      title: 'Huruf M',
      description: 'Tiga jari (telunjuk, tengah, manis) ditempelkan pada telapak tangan lainnya yang terbuka menghadap depan.',
      category: 'Abjad BISINDO',
      imageAsset: 'assets/images/bisindo/M.jpg',
    ),
    LearnItem(
      id: 'bisindo-n',
      title: 'Huruf N',
      description: 'Dua jari (telunjuk dan tengah) ditempelkan pada telapak tangan lainnya yang terbuka menghadap depan.',
      category: 'Abjad BISINDO',
      imageAsset: 'assets/images/bisindo/N.jpg',
    ),
    LearnItem(
      id: 'bisindo-o',
      title: 'Huruf O',
      description: 'Ujung ibu jari dan jari telunjuk dipertemukan melingkar bulat membentuk huruf O.',
      category: 'Abjad BISINDO',
      imageAsset: 'assets/images/bisindo/O.jpg',
    ),
    LearnItem(
      id: 'bisindo-p',
      title: 'Huruf P',
      description: 'Jari telunjuk satu tangan tegak vertikal, sedangkan ibu jari dan telunjuk tangan lainnya melengkung menempel di ujung atasnya.',
      category: 'Abjad BISINDO',
      imageAsset: 'assets/images/bisindo/P.jpg',
    ),
    LearnItem(
      id: 'bisindo-q',
      title: 'Huruf Q',
      description: 'Satu tangan membentuk lingkaran O dan jari telunjuk tangan lainnya menyilang pada tepi lingkaran tersebut.',
      category: 'Abjad BISINDO',
      imageAsset: 'assets/images/bisindo/Q.jpg',
    ),
    LearnItem(
      id: 'bisindo-r',
      title: 'Huruf R',
      description: 'Jari telunjuk dan jari tengah satu tangan disilangkan atau dijentikkan bersama ibu jari membentuk huruf R.',
      category: 'Abjad BISINDO',
      imageAsset: 'assets/images/bisindo/R.jpg',
    ),
    LearnItem(
      id: 'bisindo-s',
      title: 'Huruf S',
      description: 'Kedua tangan membentuk lengkungan C kecil dari ibu jari dan telunjuk yang saling bertemu berlawanan arah membentuk lekuk huruf S.',
      category: 'Abjad BISINDO',
      imageAsset: 'assets/images/bisindo/S.jpg',
    ),
    LearnItem(
      id: 'bisindo-t',
      title: 'Huruf T',
      description: 'Jari telunjuk satu tangan ditegakkan vertikal dan jari telunjuk tangan lainnya diletakkan mendatar di atas ujungnya membentuk huruf T.',
      category: 'Abjad BISINDO',
      imageAsset: 'assets/images/bisindo/T.jpg',
    ),
    LearnItem(
      id: 'bisindo-u',
      title: 'Huruf U',
      description: 'Jari telunjuk dan kelingking (atau dua jari rapat) ditegakkan ke atas membentuk cekungan lembah huruf U.',
      category: 'Abjad BISINDO',
      imageAsset: 'assets/images/bisindo/U.jpg',
    ),
    LearnItem(
      id: 'bisindo-v',
      title: 'Huruf V',
      description: 'Jari telunjuk dan jari tengah satu tangan ditegakkan merenggang membentuk huruf V.',
      category: 'Abjad BISINDO',
      imageAsset: 'assets/images/bisindo/V.jpg',
    ),
    LearnItem(
      id: 'bisindo-w',
      title: 'Huruf W',
      description: 'Kedua tangan mengangkat ibu jari dan telunjuk (atau tiga jari tegak) berdampingan menyatu di tengah membentuk huruf W.',
      category: 'Abjad BISINDO',
      imageAsset: 'assets/images/bisindo/W.jpg',
    ),
    LearnItem(
      id: 'bisindo-x',
      title: 'Huruf X',
      description: 'Kedua jari telunjuk dari masing-masing tangan disilangkan di depan dada membentuk tanda silang huruf X.',
      category: 'Abjad BISINDO',
      imageAsset: 'assets/images/bisindo/X.jpg',
    ),
    LearnItem(
      id: 'bisindo-y',
      title: 'Huruf Y',
      description: 'Satu tangan membentuk cabang V (atau ibu jari & kelingking terbuka) dan telunjuk tangan lainnya menopang di bagian bawah membentuk huruf Y.',
      category: 'Abjad BISINDO',
      imageAsset: 'assets/images/bisindo/Y.jpg',
    ),
    LearnItem(
      id: 'bisindo-z',
      title: 'Huruf Z',
      description: 'Telapak tangan diratakan mendatar dengan pergelangan dan siku ditekuk membentuk sudut zig-zag huruf Z.',
      category: 'Abjad BISINDO',
      imageAsset: 'assets/images/bisindo/Z.jpg',
    ),
    // 10 Kelas Angka BISINDO (0 - 9)
    LearnItem(
      id: 'bisindo-num-0',
      title: 'Angka 0',
      description: 'Ibu jari dan jari telunjuk dipertemukan membentuk lingkaran menyerupai angka 0 / huruf O, dengan jari-jari lainnya melipat membulat.',
      category: 'Angka BISINDO',
    ),
    LearnItem(
      id: 'bisindo-num-1',
      title: 'Angka 1',
      description: 'Hanya jari telunjuk yang diangkat mengarah ke atas tegak lurus, sementara jari-jari lainnya mengepal rapat.',
      category: 'Angka BISINDO',
    ),
    LearnItem(
      id: 'bisindo-num-2',
      title: 'Angka 2',
      description: 'Jari telunjuk dan jari tengah diangkat ke atas secara sejajar, sedangkan jari manis dan kelingking mengepal rapat.',
      category: 'Angka BISINDO',
    ),
    LearnItem(
      id: 'bisindo-num-3',
      title: 'Angka 3',
      description: 'Tiga jari (telunjuk, tengah, manis) diangkat ke atas secara tegak, ibu jari dan kelingking melipat ke dalam telapak tangan.',
      category: 'Angka BISINDO',
    ),
    LearnItem(
      id: 'bisindo-num-4',
      title: 'Angka 4',
      description: 'Empat jari diangkat ke atas (telunjuk, tengah, manis, kelingking), sedangkan ibu jari dilipat di depan telapak tangan.',
      category: 'Angka BISINDO',
    ),
    LearnItem(
      id: 'bisindo-num-5',
      title: 'Angka 5',
      description: 'Telapak tangan dibuka lebar menghadap ke depan dengan kelima jari (ibu jari sampai kelingking) direntangkan terbuka.',
      category: 'Angka BISINDO',
    ),
    LearnItem(
      id: 'bisindo-num-6',
      title: 'Angka 6',
      description: 'Dua tangan: satu tangan membuka telapak tangan (5), ditambah satu jari dari tangan lainnya (5 + 1). Pada variasi 1 tangan: ibu jari dan kelingking direntangkan (pose shaka).',
      category: 'Angka BISINDO',
    ),
    LearnItem(
      id: 'bisindo-num-7',
      title: 'Angka 7',
      description: 'Dua tangan: satu tangan membuka telapak tangan (5), ditambah dua jari dari tangan lainnya (5 + 2). Pada variasi 1 tangan: ibu jari dan telunjuk membentuk sudut L.',
      category: 'Angka BISINDO',
    ),
    LearnItem(
      id: 'bisindo-num-8',
      title: 'Angka 8',
      description: 'Dua tangan: satu tangan membuka telapak tangan (5), ditambah tiga jari dari tangan lainnya (5 + 3). Pada variasi 1 tangan: jari tengah menyentuh ibu jari dengan jari lain tegak.',
      category: 'Angka BISINDO',
    ),
    LearnItem(
      id: 'bisindo-num-9',
      title: 'Angka 9',
      description: 'Dua tangan: satu tangan membuka telapak tangan (5), ditambah empat jari dari tangan lainnya (5 + 4). Pada variasi 1 tangan: telunjuk dan ibu jari bertemu bulat dengan 3 jari lain tegak.',
      category: 'Angka BISINDO',
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
