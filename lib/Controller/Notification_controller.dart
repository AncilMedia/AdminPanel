// // controller/NotificationController.dart
// import 'dart:convert';
// import 'package:ancilmediaadminpanel/environmental variables.dart';
// import 'package:http/http.dart' as http;
// import '../Services/api_client.dart';
// import '../View_model/Authentication_state.dart';
//
// class NotificationController {
//   static Future<List<dynamic>> getAll(AuthState authState) async {
//     final api = ApiClient(authState);
//     final response = await api.get('$baseUrl/api/notifications');
//
//     if (response.statusCode == 200) {
//       return api.decodeJson(response) ?? [];
//     } else {
//       print('❌ Failed to fetch notifications');
//       return [];
//     }
//   }
//
//   static Future<int> getUnreadCount(AuthState authState) async {
//     final api = ApiClient(authState);
//     final response = await api.get('$baseUrl/api/notifications/unread');
//
//     if (response.statusCode == 200) {
//       final list = api.decodeJson(response);
//       return list?.length ?? 0;
//     } else {
//       return 0;
//     }
//   }
//
//   static Future<void> markAsRead(AuthState authState, String id) async {
//     final api = ApiClient(authState);
//     await api.put('$baseUrl/api/notifications/read/$id');
//   }
//
//   static Future<void> accept(AuthState authState, String id) async {
//     final api = ApiClient(authState);
//     await api.put('$baseUrl/api/notifications/accept/$id');
//   }
//
//   static Future<void> delete(AuthState authState, String id) async {
//     final api = ApiClient(authState);
//     await api.delete('$baseUrl/api/notifications/$id');
//   }
// }

import 'package:ancilmediaadminpanel/environmental variables.dart';
import 'package:http/http.dart' as http;
import '../Services/api_client.dart';
import '../View_model/Authentication_state.dart';

class NotificationController {
  static Future<List<dynamic>> getAll(AuthState authState) async {
    final api = ApiClient(authState);
    try {
      final response = await api.get('$baseUrl/api/notifications');
      print('📥 [getAll] Status: ${response.statusCode}');
      print('📦 [getAll] Body: ${response.body}');
      if (response.statusCode == 200) {
        return api.decodeJson(response) ?? [];
      }
    } catch (e) {
      print('❌ getAll failed: $e');
    }
    return [];
  }

  static Future<List<dynamic>> getUnread(AuthState authState) async {
    final api = ApiClient(authState);
    try {
      final response = await api.get('$baseUrl/api/notifications/unread');
      print('📥 [getUnread] Status: ${response.statusCode}');
      print('📦 [getUnread] Body: ${response.body}');
      if (response.statusCode == 200) {
        return api.decodeJson(response) ?? [];
      }
    } catch (e) {
      print('❌ getUnread failed: $e');
    }
    return [];
  }

  static Future<int> getUnreadCount(AuthState authState) async {
    final unread = await getUnread(authState);
    print('🔢 [getUnreadCount] Count: ${unread.length}');
    return unread.length;
  }

  static Future<void> markAsRead(AuthState authState, String id) async {
    final api = ApiClient(authState);
    try {
      final response = await api.put('$baseUrl/api/notifications/read/$id');
      print('✅ [markAsRead] Response: ${response.statusCode} - ${response.body}');
    } catch (e) {
      print('❌ markAsRead failed for $id: $e');
    }
  }

  static Future<void> accept(AuthState authState, String id) async {
    final api = ApiClient(authState);
    try {
      final response = await api.put('$baseUrl/api/notifications/accept/$id');
      print('✅ [accept] Response: ${response.statusCode} - ${response.body}');
    } catch (e) {
      print('❌ accept failed for $id: $e');
    }
  }

  static Future<bool> delete(AuthState authState, String id) async {
    final api = ApiClient(authState);
    try {
      final response = await api.delete('$baseUrl/api/notifications/$id');
      print('🗑️ [delete] Response: ${response.statusCode} - ${response.body}');
      return response.statusCode == 200;
    } catch (e) {
      print('❌ delete failed for $id: $e');
      return false;
    }
  }
}
