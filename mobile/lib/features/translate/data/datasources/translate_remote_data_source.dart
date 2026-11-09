abstract class TranslateRemoteDataSource {
  Future<String> fetchGrammarCorrection(String rawText);
}

class TranslateRemoteDataSourceImpl implements TranslateRemoteDataSource {
  @override
  Future<String> fetchGrammarCorrection(String rawText) async {
    // Placeholder remote implementation
    return rawText;
  }
}

