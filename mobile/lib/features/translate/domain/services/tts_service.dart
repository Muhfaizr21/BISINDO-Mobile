import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

abstract class TtsService {
  Future<void> initialize();
  Future<void> speak(String text);
  Future<void> stop();
  bool get isSpeaking;
}

class TtsServiceImpl implements TtsService {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isSpeaking = false;
  bool _initialized = false;

  @override
  bool get isSpeaking => _isSpeaking;

  @override
  Future<void> initialize() async {
    if (_initialized) return;
    try {
      await _flutterTts.setLanguage("id-ID");
      await _flutterTts.setSpeechRate(0.48); // Natural, clear Indonesian pacing
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);

      _flutterTts.setStartHandler(() {
        _isSpeaking = true;
      });

      _flutterTts.setCompletionHandler(() {
        _isSpeaking = false;
      });

      _flutterTts.setCancelHandler(() {
        _isSpeaking = false;
      });

      _flutterTts.setErrorHandler((_) {
        _isSpeaking = false;
      });

      _initialized = true;
    } catch (e) {
      debugPrint('[TtsService] Init error: $e');
    }
  }

  @override
  Future<void> speak(String text) async {
    final clean = text.trim();
    if (clean.isEmpty) return;
    try {
      await initialize();
      _isSpeaking = true;
      await _flutterTts.speak(clean);
    } catch (e) {
      _isSpeaking = false;
      debugPrint('[TtsService] Speak error: $e');
    }
  }

  @override
  Future<void> stop() async {
    try {
      await _flutterTts.stop();
      _isSpeaking = false;
    } catch (e) {
      debugPrint('[TtsService] Stop error: $e');
    }
  }
}

