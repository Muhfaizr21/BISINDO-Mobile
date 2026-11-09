import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

class ApiConstants {
  // Supabase Configuration
  static const String supabaseUrl = 'https://kdhsejrotfajtqygkcse.supabase.co';
  static const String supabasePublishableKey =
      'sb_publishable_5WWbMQmB9mEK9-RaSeqnWg_UoBkblXJ';

  // Backend API Base URL (Golang Server)
  static String get backendBaseUrl {
    if (kIsWeb) {
      return 'http://localhost:8080';
    }
    try {
      if (Platform.isAndroid) {
        // Android Emulator loops back to host via 10.0.2.2
        return 'http://10.0.2.2:8080';
      }
    } catch (_) {
      // Fallback
    }
    // iOS Simulator, macOS desktop, or physical network
    return 'http://127.0.0.1:8080';
  }

  // Endpoints
  static String get healthEndpoint => '$backendBaseUrl/api/health';
  static String get historyEndpoint => '$backendBaseUrl/api/history';
  static String get learnEndpoint => '$backendBaseUrl/api/learn';
}

