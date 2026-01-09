import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import '../environmental variables.dart';

class PushNotificationController {
  // 🔐 Get bearer token
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  // ✅ POST: Send notification
  static Future<Map<String, dynamic>> sendNotification({
    required String title,
    required String body,
    required String event,
    required String type,
    String? userId,
    String? organizationId,
    String? color,
    String? icon,
    File? imageFile,
  }) async {
    final token = await _getToken();
    if (token == null) throw Exception('Auth token not found');

    final uri = Uri.parse('$baseUrl/api/pushnotification');
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['title'] = title
      ..fields['body'] = body
      ..fields['event'] = event
      ..fields['type'] = type;

    if (userId != null) request.fields['userId'] = userId;
    if (organizationId != null) request.fields['organizationId'] = organizationId;
    if (color != null) request.fields['color'] = color;
    if (icon != null) request.fields['icon'] = icon;

    if (imageFile != null) {
      final fileStream = http.ByteStream(imageFile.openRead());
      final length = await imageFile.length();
      final mimeType = lookupMimeType(imageFile.path) ?? 'application/octet-stream';
      final multipartFile = http.MultipartFile(
        'image',
        fileStream,
        length,
        filename: imageFile.path.split('/').last,
        contentType: MediaType.parse(mimeType),
      );
      request.files.add(multipartFile);
    }

    print('📤 Sending notification with fields: ${request.fields}');
    if (imageFile != null) print('🖼️ Attached image: ${imageFile.path}');

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print('✅ Notification sent successfully: ${response.body}');
      } else {
        print('❌ Notification failed: ${response.statusCode} - ${response.body}');
      }

      return {
        'status': response.statusCode,
        'data': responseData,
      };
    } catch (e) {
      print('❌ Error sending notification: $e');
      return {
        'status': 500,
        'data': {'message': 'Client error while sending notification'},
      };
    }
  }

  // 📥 GET: All notifications
  static Future<List<Map<String, dynamic>>> fetchNotifications() async {
    final token = await _getToken();
    if (token == null) throw Exception('Auth token not found');

    final response = await http.get(
      Uri.parse("$baseUrl/api/pushnotification"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      print('❌ Failed to fetch notifications: ${response.statusCode} - ${response.body}');
      throw Exception('Failed to load notifications');
    }

    print('✅ Notifications fetched successfully');
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((e) => e as Map<String, dynamic>).toList();
  }

  // ❌ DELETE: Notification by ID
  static Future<void> deleteNotification(String id) async {
    final token = await _getToken();
    if (token == null) throw Exception('Auth token not found');

    final url = Uri.parse('$baseUrl/api/pushnotification/$id');

    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print('✅ Notification deleted: $id');
    } else {
      print('❌ Failed to delete notification: ${response.statusCode} - ${response.body}');
      throw Exception('Failed to delete notification');
    }
  }
}
