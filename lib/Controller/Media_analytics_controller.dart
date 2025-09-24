// services/analytics_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../environmental variables.dart';

class AnalyticsService {
  // Fetch all media analytics (paginated)
  static Future<Map<String, dynamic>?> getAllMediaAnalytics({
    int page = 1,
    int limit = 15,
  }) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/api/media/analytics?page=$page&limit=$limit"),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
      print("Failed to fetch all media analytics: ${response.body}");
      return null;
    } catch (e) {
      print("Error fetching all media analytics: $e");
      return null;
    }
  }

  // Fetch single media item analytics
  static Future<Map<String, dynamic>?> getMediaAnalytics(String mediaItemId) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/api/media/analytics/$mediaItemId"),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
      print("Failed to fetch media analytics: ${response.body}");
      return null;
    } catch (e) {
      print("Error fetching media analytics: $e");
      return null;
    }
  }
}
