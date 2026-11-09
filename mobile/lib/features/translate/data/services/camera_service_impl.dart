import 'package:camera/camera.dart';
import '../../domain/services/camera_service.dart';

class CameraServiceImpl implements CameraService {
  List<CameraDescription> _cameras = [];
  CameraController? _controller;
  int _selectedCameraIndex = 0;
  bool _isInitialized = false;

  @override
  CameraController? get controller => _controller;

  @override
  bool get isInitialized =>
      _isInitialized && _controller != null && _controller!.value.isInitialized;

  @override
  List<CameraDescription> get cameras => _cameras;

  @override
  CameraDescription? get currentCamera {
    if (_cameras.isEmpty || _selectedCameraIndex >= _cameras.length) {
      return null;
    }
    return _cameras[_selectedCameraIndex];
  }

  @override
  Future<void> initialize() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        _isInitialized = false;
        return;
      }

      // Default to front camera for sign language translation if available
      final frontCameraIndex = _cameras.indexWhere(
        (cam) => cam.lensDirection == CameraLensDirection.front,
      );
      if (frontCameraIndex != -1) {
        _selectedCameraIndex = frontCameraIndex;
      } else {
        _selectedCameraIndex = 0;
      }

      await _initController(_cameras[_selectedCameraIndex]);
    } catch (_) {
      _isInitialized = false;
    }
  }

  Future<void> _initController(CameraDescription camera) async {
    await _controller?.dispose();

    final controller = CameraController(
      camera,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    try {
      await controller.initialize();
      _controller = controller;
      _isInitialized = true;
    } catch (_) {
      _isInitialized = false;
    }
  }

  @override
  Future<void> switchCamera() async {
    if (_cameras.length < 2) return;

    _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras.length;
    await _initController(_cameras[_selectedCameraIndex]);
  }

  @override
  Future<void> startImageStream(Function(CameraImage image) onAvailable) async {
    if (_controller != null &&
        _controller!.value.isInitialized &&
        !_controller!.value.isStreamingImages) {
      try {
        await _controller!.startImageStream(onAvailable);
      } catch (_) {}
    }
  }

  @override
  Future<void> stopImageStream() async {
    if (_controller != null &&
        _controller!.value.isInitialized &&
        _controller!.value.isStreamingImages) {
      try {
        await _controller!.stopImageStream();
      } catch (_) {}
    }
  }

  @override
  Future<void> dispose() async {
    _isInitialized = false;
    await stopImageStream();
    await _controller?.dispose();
    _controller = null;
  }
}
