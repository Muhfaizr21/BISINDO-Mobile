import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../../domain/entities/learn_item.dart';

abstract class LearnRemoteDataSource {
  Future<List<LearnItem>> fetchLearnMaterials();
}

class LearnRemoteDataSourceImpl implements LearnRemoteDataSource {
  final http.Client client;

  LearnRemoteDataSourceImpl({http.Client? client})
      : client = client ?? http.Client();

  @override
  Future<List<LearnItem>> fetchLearnMaterials() async {
    try {
      final response = await client.get(
        Uri.parse(ApiConstants.learnEndpoint),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final List<dynamic> list = json.decode(response.body);
        return list.map((item) {
          final map = item as Map<String, dynamic>;
          return LearnItem(
            id: map['id']?.toString() ?? '',
            title: map['title'] as String? ?? '',
            description: map['description'] as String? ?? '',
            category: map['category'] as String? ?? 'Umum',
          );
        }).toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }
}
