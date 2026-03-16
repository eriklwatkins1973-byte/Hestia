import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/resource.dart';

/// Service for fetching [Resource] data from the backend API.
class ResourceService {
  final http.Client _client;
  final String _baseUrl;

  ResourceService({
    http.Client? client,
    String baseUrl = 'https://api.hestia.example.com',
  })  : _client = client ?? http.Client(),
        _baseUrl = baseUrl;

  /// Returns all active resources belonging to [countyId].
  ///
  /// Throws an [Exception] if the server responds with a non-200 status code.
  Future<List<Resource>> getResourcesByCounty(String countyId) async {
    final uri = Uri.parse('$_baseUrl/resources').replace(
      queryParameters: {'county_id': countyId},
    );

    final response = await _client.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data =
          jsonDecode(response.body) as List<dynamic>;
      return data
          .map((json) => Resource.fromJson(json as Map<String, dynamic>))
          .toList();
    }

    throw Exception(
      'Failed to load resources for county $countyId: '
      'HTTP ${response.statusCode}',
    );
  }
}
