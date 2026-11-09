import 'package:camera/camera.dart';

abstract class CameraService {
  Future<void> initialize();
  CameraController? get controller;
  bool get isInitialized;
  List<CameraDescription> get cameras;
  CameraDescription? get currentCamera;
  Future<void> switchCamera();
  Future<void> dispose();
}

