abstract class TranslateLocalDataSource {
  Future<void> cacheRecentTranslation(String text);
  Future<String?> getRecentTranslation();
}

class TranslateLocalDataSourceImpl implements TranslateLocalDataSource {
  @override
  Future<void> cacheRecentTranslation(String text) async {
    // Placeholder for Hive cache
  }

  @override
  Future<String?> getRecentTranslation() async {
    // Placeholder
    return null;
  }
}

