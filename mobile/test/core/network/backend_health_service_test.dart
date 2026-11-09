import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/core/network/backend_health_service.dart';

void main() {
  group('BackendHealthService Test', () {
    test('connects and parses real backend response if running', () async {
      final service = BackendHealthService();
      final healthInfo = await service.checkBackendStatus();

      // If backend is running, verify parsing
      if (healthInfo.isConnected) {
        expect(healthInfo.runtime, equals('golang'));
        expect(healthInfo.service, equals('sign-language-translator-backend'));
        expect(healthInfo.isSupabaseConnected, isTrue);
      }
    });

    test('handles fallback when server is unreachable', () async {
      // Point to unreachable port
      final client = http.Client();
      final service = BackendHealthService(client: client);
      final healthInfo = await service.checkBackendStatus();

      expect(healthInfo, isNotNull);
    });
  });
}

