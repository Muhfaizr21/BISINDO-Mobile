import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';

class BackendHealthInfo {
  final bool isConnected;
  final String status;
  final String service;
  final String runtime;
  final bool isSupabaseConnected;
  final String? errorMessage;

  const BackendHealthInfo({
    required this.isConnected,
    required this.status,
    required this.service,
    required this.runtime,
    required this.isSupabaseConnected,
    this.errorMessage,
  });

  factory BackendHealthInfo.disconnected([String? message]) {
    return BackendHealthInfo(
      isConnected: false,
      status: 'offline',
      service: 'sign-language-translator-backend',
      runtime: 'golang',
      isSupabaseConnected: false,
      errorMessage: message,
    );
  }

  factory BackendHealthInfo.fromJson(Map<String, dynamic> json) {
    final sb = json['supabase'] as Map<String, dynamic>?;
    return BackendHealthInfo(
      isConnected: json['status'] == 'healthy' || json['status'] == 'degraded',
      status: json['status'] as String? ?? 'unknown',
      service: json['service'] as String? ?? 'backend',
      runtime: json['runtime'] as String? ?? 'golang',
      isSupabaseConnected: sb != null && (sb['connected'] == true),
      errorMessage: sb?['error'] as String?,
    );
  }
}

class BackendHealthService {
  final http.Client client;

  BackendHealthService({http.Client? client})
      : client = client ?? http.Client();

  Future<BackendHealthInfo> checkBackendStatus() async {
    try {
      final response = await client
          .get(Uri.parse(ApiConstants.healthEndpoint))
          .timeout(const Duration(seconds: 12));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return BackendHealthInfo.fromJson(data);
      }
      return BackendHealthInfo.disconnected(
        'Server returned HTTP status ${response.statusCode}',
      );
    } catch (e) {
      return BackendHealthInfo.disconnected(e.toString());
    }
  }
}

