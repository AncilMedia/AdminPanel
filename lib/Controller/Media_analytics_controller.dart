import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../environmental variables.dart';

class AnalyticsService {
  Future<String?> _getOrganizationId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('organizationId');
  }

  Future<Map<String, dynamic>> getAllMediaAnalytics({
    DateTime? startDate,
    DateTime? endDate,
    int page = 1,
    int limit = 15,
    String sortField = 'date',
    String sortOrder = 'desc',
  }) async {
    final orgId = await _getOrganizationId();

    final query = <String, String>{
      'page': '$page',
      'limit': '$limit',
      'sortField': sortField,
      'sortOrder': sortOrder,
    };

    if (orgId?.isNotEmpty ?? false) query['organizationId'] = orgId!;
    if (startDate != null) query['startDate'] = DateFormat('yyyy-MM-dd').format(startDate);
    if (endDate != null) query['endDate'] = DateFormat('yyyy-MM-dd').format(endDate);

    final uri = Uri.parse('$baseUrl/api/media/analytics')
        .replace(queryParameters: query);

    if (kDebugMode) print("🌐 $uri");

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception("Analytics fetch failed ${response.statusCode}");
    }

    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> getAllMediaAnalyticsByOrganization({
    DateTime? startDate,
    DateTime? endDate,
    int page = 1,
    int limit = 15,
    String sortField = 'date',
    String sortOrder = 'desc',
  }) async {
    final orgId = await _getOrganizationId();
    if (orgId == null) throw Exception("Org ID missing");

    final query = <String, String>{
      'page': '$page',
      'limit': '$limit',
      'sortField': sortField,
      'sortOrder': sortOrder,
    };

    if (startDate != null) query['startDate'] = DateFormat('yyyy-MM-dd').format(startDate);
    if (endDate != null) query['endDate'] = DateFormat('yyyy-MM-dd').format(endDate);

    final uri = Uri.parse('$baseUrl/api/media/analytics/org/$orgId')
        .replace(queryParameters: query);

    if (kDebugMode) print("🌐 $uri");

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception("Org analytics fetch failed ${response.statusCode}");
    }

    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> getSingleMediaAnalytics(String mediaItemId) async {
    final uri = Uri.parse('$baseUrl/api/media/analytics/$mediaItemId');

    if (kDebugMode) print("🌐 $uri");

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception("Single analytics fetch failed ${response.statusCode}");
    }

    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> logPlayEvent({
    required String mediaItemId,
    required String userId,
    int playedDuration = 0,
    String device = 'other',
    String? sessionId,
  }) async {
    final uri = Uri.parse('$baseUrl/api/media/analytics/log');

    final body = json.encode({
      'mediaItemId': mediaItemId,
      'userId': userId,
      'playedDuration': playedDuration,
      'device': device,
      'sessionId': sessionId,
    });

    final response = await http.post(uri,
        headers: {'Content-Type': 'application/json'}, body: body);

    if (response.statusCode != 200) {
      throw Exception("Play log failed ${response.statusCode}");
    }

    return json.decode(response.body);
  }
}