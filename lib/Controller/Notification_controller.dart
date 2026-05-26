import 'dart:convert';

import 'package:ancilmediaadminpanel/environmental variables.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Services/api_client.dart';
import '../View_model/Authentication_state.dart';

class NotificationController {

  // ======================================================
  // GET ACCESS TOKEN FROM SHARED PREFERENCES
  // ======================================================

  static Future<String?> _getAccessToken() async {

    final prefs =
    await SharedPreferences.getInstance();

    return prefs.getString(
      'accessToken',
    );
  }

  // ======================================================
  // COMMON HEADERS
  // ======================================================

  static Future<Map<String, String>> _headers() async {

    final token =
    await _getAccessToken();

    return {

      'Authorization':
      'Bearer $token',

      'Content-Type':
      'application/json',
    };
  }

  // ======================================================
  // GET ALL NOTIFICATIONS
  // ======================================================

  static Future<List<dynamic>> getAll(
      AuthState authState,
      ) async {

    try {

      final response =
      await http.get(

        Uri.parse(
          '$baseUrl/api/notifications',
        ),

        headers:
        await _headers(),
      );

      print(
        '📥 [getAll] Status: ${response.statusCode}',
      );

      print(
        '📦 [getAll] Body: ${response.body}',
      );

      if (response.statusCode == 200) {

        final decoded =
        jsonDecode(
          response.body,
        );

        final data =
        decoded['data'];

        if (data is List) {

          return data;
        }
      }

    } catch (e) {

      print(
        '❌ getAll failed: $e',
      );
    }

    return [];
  }

  // ======================================================
  // GET UNREAD NOTIFICATIONS
  // ======================================================

  static Future<List<dynamic>> getUnread(
      AuthState authState,
      ) async {

    try {

      final response =
      await http.get(

        Uri.parse(
          '$baseUrl/api/notifications/unread',
        ),

        headers:
        await _headers(),
      );

      print(
        '📥 [getUnread] Status: ${response.statusCode}',
      );

      print(
        '📦 [getUnread] Body: ${response.body}',
      );

      if (response.statusCode == 200) {

        final decoded =
        jsonDecode(
          response.body,
        );

        final data =
        decoded['data'];

        if (data is List) {

          return data;
        }
      }

    } catch (e) {

      print(
        '❌ getUnread failed: $e',
      );
    }

    return [];
  }

  // ======================================================
  // GET UNREAD COUNT
  // ======================================================

  static Future<int> getUnreadCount(
      AuthState authState,
      ) async {

    try {

      final unread =
      await getUnread(
        authState,
      );

      print(
        '🔢 [getUnreadCount] Count: ${unread.length}',
      );

      return unread.length;

    } catch (e) {

      print(
        '❌ getUnreadCount failed: $e',
      );

      return 0;
    }
  }

  // ======================================================
  // MARK SINGLE NOTIFICATION AS READ
  // ======================================================

  static Future<bool> markAsRead(
      AuthState authState,
      String id,
      ) async {

    try {

      final response =
      await http.put(

        Uri.parse(
          '$baseUrl/api/notifications/read/$id',
        ),

        headers:
        await _headers(),
      );

      print(
        '✅ [markAsRead] Status: ${response.statusCode}',
      );

      print(
        '📦 [markAsRead] Body: ${response.body}',
      );

      if (response.statusCode == 200) {

        final decoded =
        jsonDecode(
          response.body,
        );

        print(
          '✅ Notification saved as read in backend',
        );

        print(
          '📄 Updated Notification: ${decoded['data']}',
        );

        return true;
      }

      print(
        '❌ markAsRead failed with status ${response.statusCode}',
      );

      return false;

    } catch (e) {

      print(
        '❌ markAsRead failed for $id: $e',
      );

      return false;
    }
  }

  // ======================================================
  // MARK ALL NOTIFICATIONS AS READ
  // ======================================================

  static Future<bool> markAllAsRead(
      AuthState authState,
      ) async {

    try {

      final response =
      await http.patch(

        Uri.parse(
          '$baseUrl/api/notifications/read-all',
        ),

        headers:
        await _headers(),
      );

      print(
        '✅ [markAllAsRead] Status: ${response.statusCode}',
      );

      print(
        '📦 [markAllAsRead] Body: ${response.body}',
      );

      if (response.statusCode == 200) {

        print(
          '✅ All notifications marked as read',
        );

        return true;
      }

      return false;

    } catch (e) {

      print(
        '❌ markAllAsRead failed: $e',
      );

      return false;
    }
  }

  // ======================================================
  // ACCEPT NOTIFICATION
  // ======================================================

  static Future<bool> accept(
      AuthState authState,
      String id,
      ) async {

    try {

      final response =
      await http.put(

        Uri.parse(
          '$baseUrl/api/notifications/accept/$id',
        ),

        headers:
        await _headers(),
      );

      print(
        '✅ [accept] Status: ${response.statusCode}',
      );

      print(
        '📦 [accept] Body: ${response.body}',
      );

      return response.statusCode == 200;

    } catch (e) {

      print(
        '❌ accept failed for $id: $e',
      );

      return false;
    }
  }

  // ======================================================
  // DELETE NOTIFICATION
  // ======================================================

  static Future<bool> delete(
      AuthState authState,
      String id,
      ) async {

    try {

      final response =
      await http.delete(

        Uri.parse(
          '$baseUrl/api/notifications/$id',
        ),

        headers:
        await _headers(),
      );

      print(
        '🗑️ [delete] Status: ${response.statusCode}',
      );

      print(
        '📦 [delete] Body: ${response.body}',
      );

      return response.statusCode == 200;

    } catch (e) {

      print(
        '❌ delete failed for $id: $e',
      );

      return false;
    }
  }

  // ======================================================
  // GET SINGLE NOTIFICATION
  // ======================================================

  static Future<Map<String, dynamic>?> getSingle(
      AuthState authState,
      String id,
      ) async {

    try {

      final response =
      await http.get(

        Uri.parse(
          '$baseUrl/api/notifications/$id',
        ),

        headers:
        await _headers(),
      );

      print(
        '📥 [getSingle] Status: ${response.statusCode}',
      );

      print(
        '📦 [getSingle] Body: ${response.body}',
      );

      if (response.statusCode == 200) {

        final decoded =
        jsonDecode(
          response.body,
        );

        final data =
        decoded['data'];

        if (data is Map<String, dynamic>) {

          return data;
        }
      }

    } catch (e) {

      print(
        '❌ getSingle failed: $e',
      );
    }

    return null;
  }
}