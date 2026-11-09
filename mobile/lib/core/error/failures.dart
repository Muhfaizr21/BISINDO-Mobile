import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure([this.message = 'An unexpected error occurred']);

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server Error']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache Error']);
}

class CameraFailure extends Failure {
  const CameraFailure([super.message = 'Camera initialization or capture failed']);
}

class ModelInferenceFailure extends Failure {
  const ModelInferenceFailure([super.message = 'Model inference failed']);
}

class HandLandmarkFailure extends Failure {
  const HandLandmarkFailure([super.message = 'Hand landmark detection failed']);
}

