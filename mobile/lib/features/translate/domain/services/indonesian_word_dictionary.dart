class IndonesianWordDictionary {
  static const List<String> commonWords = [
    'SAYA',
    'KAMU',
    'KITA',
    'MEREKA',
    'HALO',
    'HAI',
    'TERIMA KASIH',
    'SAMA-SAMA',
    'SELAMAT PAGI',
    'SELAMAT SIANG',
    'SELAMAT SORE',
    'SELAMAT MALAM',
    'APA KABAR',
    'BAIK',
    'TIDAK',
    'IYA',
    'BISA',
    'TOLONG',
    'MAAF',
    'PERMISI',
    'NAMA',
    'SIAPA',
    'DIMANA',
    'KAPAN',
    'MENGAPA',
    'BAGAIMANA',
    'BELAJAR',
    'BAHASA',
    'ISYARAT',
    'INDONESIA',
    'BISINDO',
    'TEMAN',
    'KELUARGA',
    'SENANG',
    'SEHAT',
  ];

  /// Returns suggested words based on the current word being typed.
  static List<String> getSuggestions(String fullText) {
    if (fullText.trim().isEmpty) return const [];

    // Get the last token (word currently being spelled)
    final words = fullText.split(' ');
    final lastWord = words.isNotEmpty ? words.last.toUpperCase().trim() : '';
    if (lastWord.isEmpty) return const [];

    final suggestions = <String>[];
    for (final dictWord in commonWords) {
      if (dictWord.startsWith(lastWord) && dictWord != lastWord) {
        suggestions.add(dictWord);
      }
    }
    return suggestions.take(4).toList();
  }

  /// Replaces the last token in [fullText] with the selected [chosenWord].
  static String applySuggestion(String fullText, String chosenWord) {
    final words = fullText.split(' ');
    if (words.isEmpty) return '$chosenWord ';
    words[words.length - 1] = chosenWord;
    return '${words.join(' ')} ';
  }
}

