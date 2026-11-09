class ServerException implements Exception {
  final String message;
  ServerException([this.message = 'Server Exception']);
}

class CacheException implements Exception {
  final String message;
  CacheException([this.message = 'Cache Exception']);
}

class CameraOperationException implements Exception {
  final String message;
  CameraOperationException([this.message = 'Camera Exception']);
}

class ModelInferenceException implements Exception {
  final String message;
  ModelInferenceException([this.message = 'Model Inference Exception']);
}

