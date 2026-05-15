// // // import 'package:ancilmediaadminpanel/environmental variables.dart';
// // // import 'package:http/http.dart' as http;
// // // import '../Services/api_client.dart';
// // // import '../View_model/Authentication_state.dart';
// // //
// // // class NotificationController {
// // //   static Future<List<dynamic>> getAll(AuthState authState) async {
// // //     final api = ApiClient(authState);
// // //     try {
// // //       final response = await api.get('$baseUrl/api/notifications');
// // //       print('📥 [getAll] Status: ${response.statusCode}');
// // //       print('📦 [getAll] Body: ${response.body}');
// // //       if (response.statusCode == 200) {
// // //         return api.decodeJson(response) ?? [];
// // //       }
// // //     } catch (e) {
// // //       print('❌ getAll failed: $e');
// // //     }
// // //     return [];
// // //   }
// // //
// // //   static Future<List<dynamic>> getUnread(AuthState authState) async {
// // //     final api = ApiClient(authState);
// // //     try {
// // //       final response = await api.get('$baseUrl/api/notifications/unread');
// // //       print('📥 [getUnread] Status: ${response.statusCode}');
// // //       print('📦 [getUnread] Body: ${response.body}');
// // //       if (response.statusCode == 200) {
// // //         return api.decodeJson(response) ?? [];
// // //       }
// // //     } catch (e) {
// // //       print('❌ getUnread failed: $e');
// // //     }
// // //     return [];
// // //   }
// // //
// // //   static Future<int> getUnreadCount(AuthState authState) async {
// // //     final unread = await getUnread(authState);
// // //     print('🔢 [getUnreadCount] Count: ${unread.length}');
// // //     return unread.length;
// // //   }
// // //
// // //   static Future<void> markAsRead(AuthState authState, String id) async {
// // //     final api = ApiClient(authState);
// // //     try {
// // //       final response = await api.put('$baseUrl/api/notifications/read/$id');
// // //       print('✅ [markAsRead] Response: ${response.statusCode} - ${response.body}');
// // //     } catch (e) {
// // //       print('❌ markAsRead failed for $id: $e');
// // //     }
// // //   }
// // //
// // //   static Future<void> accept(AuthState authState, String id) async {
// // //     final api = ApiClient(authState);
// // //     try {
// // //       final response = await api.put('$baseUrl/api/notifications/accept/$id');
// // //       print('✅ [accept] Response: ${response.statusCode} - ${response.body}');
// // //     } catch (e) {
// // //       print('❌ accept failed for $id: $e');
// // //     }
// // //   }
// // //
// // //   static Future<bool> delete(AuthState authState, String id) async {
// // //     final api = ApiClient(authState);
// // //     try {
// // //       final response = await api.delete('$baseUrl/api/notifications/$id');
// // //       print('🗑️ [delete] Response: ${response.statusCode} - ${response.body}');
// // //       return response.statusCode == 200;
// // //     } catch (e) {
// // //       print('❌ delete failed for $id: $e');
// // //       return false;
// // //     }
// // //   }
// // // }
// //
// //
// // import 'package:ancilmediaadminpanel/environmental variables.dart';
// // import 'package:http/http.dart' as http;
// // import '../Services/api_client.dart';
// // import '../View_model/Authentication_state.dart';
// //
// // class NotificationController {
// //   static Future<List<dynamic>> getAll(AuthState authState) async {
// //     final api = ApiClient(authState);
// //     try {
// //       final response = await api.get('$baseUrl/api/notifications');
// //       print('📥 [getAll] Status: ${response.statusCode}');
// //       print('📦 [getAll] Body: ${response.body}');
// //       if (response.statusCode == 200) {
// //         final decoded = api.decodeJson(response);
// //         return decoded['data'] ?? [];   // ✅ Fix here
// //       }
// //     } catch (e) {
// //       print('❌ getAll failed: $e');
// //     }
// //     return [];
// //   }
// //
// //   static Future<List<dynamic>> getUnread(AuthState authState) async {
// //     final api = ApiClient(authState);
// //     try {
// //       final response = await api.get('$baseUrl/api/notifications/unread');
// //       print('📥 [getUnread] Status: ${response.statusCode}');
// //       print('📦 [getUnread] Body: ${response.body}');
// //       if (response.statusCode == 200) {
// //         final decoded = api.decodeJson(response);
// //         return decoded['data'] ?? [];   // ✅ Fix here
// //       }
// //     } catch (e) {
// //       print('❌ getUnread failed: $e');
// //     }
// //     return [];
// //   }
// //
// //   static Future<int> getUnreadCount(AuthState authState) async {
// //     final unread = await getUnread(authState);
// //     print('🔢 [getUnreadCount] Count: ${unread.length}');
// //     return unread.length;
// //   }
// //
// //   static Future<void> markAsRead(AuthState authState, String id) async {
// //     final api = ApiClient(authState);
// //     try {
// //       final response = await api.put('$baseUrl/api/notifications/read/$id');
// //       print('✅ [markAsRead] Response: ${response.statusCode} - ${response.body}');
// //     } catch (e) {
// //       print('❌ markAsRead failed for $id: $e');
// //     }
// //   }
// //
// //   static Future<void> accept(AuthState authState, String id) async {
// //     final api = ApiClient(authState);
// //     try {
// //       final response = await api.put('$baseUrl/api/notifications/accept/$id');
// //       print('✅ [accept] Response: ${response.statusCode} - ${response.body}');
// //     } catch (e) {
// //       print('❌ accept failed for $id: $e');
// //     }
// //   }
// //
// //   static Future<bool> delete(AuthState authState, String id) async {
// //     final api = ApiClient(authState);
// //     try {
// //       final response = await api.delete('$baseUrl/api/notifications/$id');
// //       print('🗑️ [delete] Response: ${response.statusCode} - ${response.body}');
// //       return response.statusCode == 200;
// //     } catch (e) {
// //       print('❌ delete failed for $id: $e');
// //       return false;
// //     }
// //   }
// // }
//
//
// import 'package:ancilmediaadminpanel/environmental variables.dart';
// import 'package:http/http.dart' as http;
//
// import '../Services/api_client.dart';
// import '../View_model/Authentication_state.dart';
//
// class NotificationController {
//
//   // ======================================================
//   // GET ALL NOTIFICATIONS
//   // ======================================================
//
//   static Future<List<dynamic>> getAll(
//       AuthState authState,
//       ) async {
//
//     final api = ApiClient(authState);
//
//     try {
//
//       final response =
//       await api.get(
//         '$baseUrl/api/notifications',
//       );
//
//       print(
//         '📥 [getAll] Status: ${response.statusCode}',
//       );
//
//       print(
//         '📦 [getAll] Body: ${response.body}',
//       );
//
//       if (response.statusCode == 200) {
//
//         final decoded =
//         api.decodeJson(response);
//
//         return decoded['data'] ?? [];
//       }
//
//     } catch (e) {
//
//       print(
//         '❌ getAll failed: $e',
//       );
//     }
//
//     return [];
//   }
//
//   // ======================================================
//   // GET UNREAD
//   // ======================================================
//
//   static Future<List<dynamic>> getUnread(
//       AuthState authState,
//       ) async {
//
//     final api = ApiClient(authState);
//
//     try {
//
//       final response =
//       await api.get(
//         '$baseUrl/api/notifications/unread',
//       );
//
//       print(
//         '📥 [getUnread] Status: ${response.statusCode}',
//       );
//
//       print(
//         '📦 [getUnread] Body: ${response.body}',
//       );
//
//       if (response.statusCode == 200) {
//
//         final decoded =
//         api.decodeJson(response);
//
//         return decoded['data'] ?? [];
//       }
//
//     } catch (e) {
//
//       print(
//         '❌ getUnread failed: $e',
//       );
//     }
//
//     return [];
//   }
//
//   // ======================================================
//   // GET UNREAD COUNT
//   // ======================================================
//
//   static Future<int> getUnreadCount(
//       AuthState authState,
//       ) async {
//
//     final unread =
//     await getUnread(authState);
//
//     print(
//       '🔢 [getUnreadCount] Count: ${unread.length}',
//     );
//
//     return unread.length;
//   }
//
//   // ======================================================
//   // MARK SINGLE AS READ
//   // ======================================================
//
//   static Future<bool> markAsRead(
//       AuthState authState,
//       String id,
//       ) async {
//
//     final api = ApiClient(authState);
//
//     try {
//
//       final response =
//       await api.put(
//         '$baseUrl/api/notifications/read/$id',
//       );
//
//       print(
//         '✅ [markAsRead] ${response.statusCode}',
//       );
//
//       print(
//         '📦 ${response.body}',
//       );
//
//       return response.statusCode == 200;
//
//     } catch (e) {
//
//       print(
//         '❌ markAsRead failed for $id: $e',
//       );
//
//       return false;
//     }
//   }
//
//   // ======================================================
//   // MARK ALL AS READ
//   // ======================================================
//
//   static Future<bool> markAllAsRead(
//       AuthState authState,
//       ) async {
//
//     try {
//
//       final response =
//       await http.patch(
//
//         Uri.parse(
//           '$baseUrl/api/notifications/read-all',
//         ),
//
//         headers: {
//
//           'Authorization':
//           'Bearer ${authState.accessToken}',
//
//           'Content-Type':
//           'application/json',
//         },
//       );
//
//       print(
//         '✅ [markAllAsRead] ${response.statusCode}',
//       );
//
//       print(
//         '📦 ${response.body}',
//       );
//
//       return response.statusCode == 200;
//
//     } catch (e) {
//
//       print(
//         '❌ markAllAsRead failed: $e',
//       );
//
//       return false;
//     }
//   }
//
//   // ======================================================
//   // ACCEPT NOTIFICATION
//   // ======================================================
//
//   static Future<bool> accept(
//       AuthState authState,
//       String id,
//       ) async {
//
//     final api = ApiClient(authState);
//
//     try {
//
//       final response =
//       await api.put(
//         '$baseUrl/api/notifications/accept/$id',
//       );
//
//       print(
//         '✅ [accept] ${response.statusCode}',
//       );
//
//       print(
//         '📦 ${response.body}',
//       );
//
//       return response.statusCode == 200;
//
//     } catch (e) {
//
//       print(
//         '❌ accept failed for $id: $e',
//       );
//
//       return false;
//     }
//   }
//
//   // ======================================================
//   // DELETE NOTIFICATION
//   // ======================================================
//
//   static Future<bool> delete(
//       AuthState authState,
//       String id,
//       ) async {
//
//     final api = ApiClient(authState);
//
//     try {
//
//       final response =
//       await api.delete(
//         '$baseUrl/api/notifications/$id',
//       );
//
//       print(
//         '🗑️ [delete] ${response.statusCode}',
//       );
//
//       print(
//         '📦 ${response.body}',
//       );
//
//       return response.statusCode == 200;
//
//     } catch (e) {
//
//       print(
//         '❌ delete failed for $id: $e',
//       );
//
//       return false;
//     }
//   }
//
//   // ======================================================
//   // GET SINGLE NOTIFICATION
//   // ======================================================
//
//   static Future<Map<String, dynamic>?> getSingle(
//       AuthState authState,
//       String id,
//       ) async {
//
//     final api = ApiClient(authState);
//
//     try {
//
//       final response =
//       await api.get(
//         '$baseUrl/api/notifications/$id',
//       );
//
//       print(
//         '📥 [getSingle] ${response.statusCode}',
//       );
//
//       print(
//         '📦 ${response.body}',
//       );
//
//       if (response.statusCode == 200) {
//
//         final decoded =
//         api.decodeJson(response);
//
//         return decoded['data'];
//       }
//
//     } catch (e) {
//
//       print(
//         '❌ getSingle failed: $e',
//       );
//     }
//
//     return null;
//   }
// }

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

        return decoded['data'] ?? [];
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

        return decoded['data'] ?? [];
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

    final unread =
    await getUnread(
      authState,
    );

    print(
      '🔢 [getUnreadCount] Count: ${unread.length}',
    );

    return unread.length;
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
        '✅ [markAsRead] ${response.statusCode}',
      );

      print(
        '📦 ${response.body}',
      );

      return response.statusCode == 200;

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
        '✅ [markAllAsRead] ${response.statusCode}',
      );

      print(
        '📦 ${response.body}',
      );

      return response.statusCode == 200;

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
        '✅ [accept] ${response.statusCode}',
      );

      print(
        '📦 ${response.body}',
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
        '🗑️ [delete] ${response.statusCode}',
      );

      print(
        '📦 ${response.body}',
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
        '📥 [getSingle] ${response.statusCode}',
      );

      print(
        '📦 ${response.body}',
      );

      if (response.statusCode == 200) {

        final decoded =
        jsonDecode(
          response.body,
        );

        return decoded['data'];
      }

    } catch (e) {

      print(
        '❌ getSingle failed: $e',
      );
    }

    return null;
  }
}