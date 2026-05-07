// // // import 'dart:convert';
// // // import 'dart:io';
// // // import 'package:camera/camera.dart';
// // // import 'package:flutter/foundation.dart';
// // // import 'package:http/http.dart' as http;
// // // import 'package:shared_preferences/shared_preferences.dart';
// // // import 'package:http_parser/http_parser.dart';
// // // import 'package:mime/mime.dart';
// // //
// // // import '../environmental variables.dart';
// // //
// // // class PushNotificationController {
// // //   // 🔐 Get bearer token
// // //   static Future<String?> _getToken() async {
// // //     final prefs = await SharedPreferences.getInstance();
// // //     return prefs.getString('accessToken');
// // //   }
// // //
// // //   // // ✅ POST: Send notification
// // //   // static Future<Map<String, dynamic>> sendNotification({
// // //   //   required String title,
// // //   //   required String body,
// // //   //   required String event,
// // //   //   required String type,
// // //   //   String? userId,
// // //   //   String? organizationId,
// // //   //   String? color,
// // //   //   String? icon,
// // //   //   File? imageFile,
// // //   // }) async {
// // //   //   final token = await _getToken();
// // //   //   if (token == null) throw Exception('Auth token not found');
// // //   //
// // //   //   final uri = Uri.parse('$baseUrl/api/pushnotification');
// // //   //   final request = http.MultipartRequest('POST', uri)
// // //   //     ..headers['Authorization'] = 'Bearer $token'
// // //   //     ..fields['title'] = title
// // //   //     ..fields['body'] = body
// // //   //     ..fields['event'] = event
// // //   //     ..fields['type'] = type;
// // //   //
// // //   //   if (userId != null) request.fields['userId'] = userId;
// // //   //   if (organizationId != null) request.fields['organizationId'] = organizationId;
// // //   //   if (color != null) request.fields['color'] = color;
// // //   //   if (icon != null) request.fields['icon'] = icon;
// // //   //
// // //   //   if (imageFile != null) {
// // //   //     final fileStream = http.ByteStream(imageFile.openRead());
// // //   //     final length = await imageFile.length();
// // //   //     final mimeType = lookupMimeType(imageFile.path) ?? 'application/octet-stream';
// // //   //     final multipartFile = http.MultipartFile(
// // //   //       'image',
// // //   //       fileStream,
// // //   //       length,
// // //   //       filename: imageFile.path.split('/').last,
// // //   //       contentType: MediaType.parse(mimeType),
// // //   //     );
// // //   //     request.files.add(multipartFile);
// // //   //   }
// // //   //
// // //   //   print('📤 Sending notification with fields: ${request.fields}');
// // //   //   if (imageFile != null) print('🖼️ Attached image: ${imageFile.path}');
// // //   //
// // //   //   try {
// // //   //     final streamedResponse = await request.send();
// // //   //     final response = await http.Response.fromStream(streamedResponse);
// // //   //
// // //   //     final Map<String, dynamic> responseData = jsonDecode(response.body);
// // //   //
// // //   //     if (response.statusCode == 200) {
// // //   //       print('✅ Notification sent successfully: ${response.body}');
// // //   //     } else {
// // //   //       print('❌ Notification failed: ${response.statusCode} - ${response.body}');
// // //   //     }
// // //   //
// // //   //     return {
// // //   //       'status': response.statusCode,
// // //   //       'data': responseData,
// // //   //     };
// // //   //   } catch (e) {
// // //   //     print('❌ Error sending notification: $e');
// // //   //     return {
// // //   //       'status': 500,
// // //   //       'data': {'message': 'Client error while sending notification'},
// // //   //     };
// // //   //   }
// // //   // }
// // //
// // //   static Future<Map<String, dynamic>> sendNotification({
// // //     required String title,
// // //     required String body,
// // //     required String event,
// // //     required String type,
// // //     String? userId,
// // //     String? organizationId,
// // //     String? color,
// // //     String? icon,
// // //     String? scheduledAt, // UTC Timestamp string
// // //     XFile? imageFile,    // Use XFile for Web/Mobile compatibility
// // //   }) async {
// // //     final token = await _getToken();
// // //     if (token == null) throw Exception('Auth token not found');
// // //
// // //     final uri = Uri.parse('$baseUrl/api/pushnotification');
// // //     final request = http.MultipartRequest('POST', uri)
// // //       ..headers['Authorization'] = 'Bearer $token'
// // //       ..fields['title'] = title
// // //       ..fields['body'] = body
// // //       ..fields['event'] = event
// // //       ..fields['type'] = type;
// // //
// // //     if (userId != null) request.fields['userId'] = userId;
// // //     if (organizationId != null) request.fields['organizationId'] = organizationId;
// // //     if (color != null) request.fields['color'] = color;
// // //     if (icon != null) request.fields['icon'] = icon;
// // //     if (scheduledAt != null) request.fields['scheduledAt'] = scheduledAt;
// // //
// // //     if (imageFile != null) {
// // //       if (kIsWeb) {
// // //         final bytes = await imageFile.readAsBytes();
// // //         request.files.add(http.MultipartFile.fromBytes(
// // //           'image',
// // //           bytes,
// // //           filename: imageFile.name,
// // //           contentType: MediaType.parse(lookupMimeType(imageFile.name) ?? 'image/jpeg'),
// // //         ));
// // //       } else {
// // //         final file = File(imageFile.path);
// // //         final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
// // //         request.files.add(await http.MultipartFile.fromPath(
// // //           'image',
// // //           file.path,
// // //           contentType: MediaType.parse(mimeType),
// // //         ));
// // //       }
// // //     }
// // //
// // //     try {
// // //       final streamedResponse = await request.send();
// // //       final response = await http.Response.fromStream(streamedResponse);
// // //       final Map<String, dynamic> responseData = jsonDecode(response.body);
// // //
// // //       return {
// // //         'status': response.statusCode,
// // //         'data': responseData,
// // //       };
// // //     } catch (e) {
// // //       return {
// // //         'status': 500,
// // //         'data': {'message': 'Client error: $e'},
// // //       };
// // //     }
// // //   }
// // //
// // //   // 📥 GET: All notifications
// // //   static Future<List<Map<String, dynamic>>> fetchNotifications() async {
// // //     final token = await _getToken();
// // //     if (token == null) throw Exception('Auth token not found');
// // //
// // //     final response = await http.get(
// // //       Uri.parse("$baseUrl/api/pushnotification"),
// // //       headers: {
// // //         'Authorization': 'Bearer $token',
// // //         'Content-Type': 'application/json',
// // //       },
// // //     );
// // //
// // //     if (response.statusCode != 200) {
// // //       print('❌ Failed to fetch notifications: ${response.statusCode} - ${response.body}');
// // //       throw Exception('Failed to load notifications');
// // //     }
// // //
// // //     print('✅ Notifications fetched successfully');
// // //     final List<dynamic> data = jsonDecode(response.body);
// // //     return data.map((e) => e as Map<String, dynamic>).toList();
// // //   }
// // //
// // //   // ❌ DELETE: Notification by ID
// // //   static Future<void> deleteNotification(String id) async {
// // //     final token = await _getToken();
// // //     if (token == null) throw Exception('Auth token not found');
// // //
// // //     final url = Uri.parse('$baseUrl/api/pushnotification/$id');
// // //
// // //     final response = await http.delete(
// // //       url,
// // //       headers: {
// // //         'Authorization': 'Bearer $token',
// // //         'Content-Type': 'application/json',
// // //       },
// // //     );
// // //
// // //     if (response.statusCode == 200) {
// // //       print('✅ Notification deleted: $id');
// // //     } else {
// // //       print('❌ Failed to delete notification: ${response.statusCode} - ${response.body}');
// // //       throw Exception('Failed to delete notification');
// // //     }
// // //   }
// // // }
// //
// //
// // import 'dart:convert';
// // import 'dart:io';
// // import 'package:camera/camera.dart';
// // import 'package:flutter/foundation.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:http_parser/http_parser.dart';
// // import 'package:mime/mime.dart';
// //
// // import '../environmental variables.dart';
// //
// // class PushNotificationController {
// //   // 🔐 Get bearer token
// //   static Future<String?> _getToken() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     return prefs.getString('accessToken');
// //   }
// //
// //   /* =========================================================
// //      📤 SEND / SCHEDULE NOTIFICATION
// //   ========================================================= */
// //   static Future<Map<String, dynamic>> sendNotification({
// //     required String title,
// //     required String body,
// //     required String event,
// //     required String type,
// //     String? userId,
// //     String? organizationId,
// //     String? color,
// //     String? icon,
// //     String? scheduledAt, // UTC ISO string
// //     XFile? imageFile,
// //   }) async {
// //     final token = await _getToken();
// //     if (token == null) throw Exception('Auth token not found');
// //
// //     final uri = Uri.parse('$baseUrl/api/pushnotification');
// //
// //     final request = http.MultipartRequest('POST', uri)
// //       ..headers['Authorization'] = 'Bearer $token'
// //       ..fields['title'] = title
// //       ..fields['body'] = body
// //       ..fields['event'] = event
// //       ..fields['type'] = type;
// //
// //     // OPTIONAL FIELDS
// //     if (userId != null) request.fields['userId'] = userId;
// //     if (organizationId != null) request.fields['organizationId'] = organizationId;
// //     if (color != null) request.fields['color'] = color;
// //     if (icon != null) request.fields['icon'] = icon;
// //
// //     /* ================= 🔥 FIX: SCHEDULE ================= */
// //     if (scheduledAt != null && scheduledAt.isNotEmpty) {
// //       request.fields['scheduledAt'] = scheduledAt;
// //       request.fields['isScheduled'] = 'true'; // ✅ REQUIRED
// //     }
// //
// //     /* ================= IMAGE ================= */
// //     if (imageFile != null) {
// //       try {
// //         if (kIsWeb) {
// //           final bytes = await imageFile.readAsBytes();
// //           request.files.add(http.MultipartFile.fromBytes(
// //             'image',
// //             bytes,
// //             filename: imageFile.name,
// //             contentType: MediaType.parse(
// //               lookupMimeType(imageFile.name) ?? 'image/jpeg',
// //             ),
// //           ));
// //         } else {
// //           final file = File(imageFile.path);
// //           final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
// //
// //           request.files.add(await http.MultipartFile.fromPath(
// //             'image',
// //             file.path,
// //             contentType: MediaType.parse(mimeType),
// //           ));
// //         }
// //       } catch (e) {
// //         print('❌ Image upload error: $e');
// //       }
// //     }
// //
// //     /* ================= DEBUG ================= */
// //     print('📤 Sending notification...');
// //     print('📝 Fields: ${request.fields}');
// //
// //     try {
// //       final streamedResponse = await request.send();
// //       final response = await http.Response.fromStream(streamedResponse);
// //
// //       final Map<String, dynamic> responseData =
// //       jsonDecode(response.body);
// //
// //       print('📥 Response: ${response.statusCode}');
// //       print('📦 Body: ${response.body}');
// //
// //       return {
// //         'status': response.statusCode,
// //         'data': responseData,
// //       };
// //     } catch (e) {
// //       print('❌ Request failed: $e');
// //       return {
// //         'status': 500,
// //         'data': {'message': 'Client error: $e'},
// //       };
// //     }
// //   }
// //
// //   /* =========================================================
// //      📥 GET ALL NOTIFICATIONS
// //   ========================================================= */
// //   static Future<List<Map<String, dynamic>>> fetchNotifications() async {
// //     final token = await _getToken();
// //     if (token == null) throw Exception('Auth token not found');
// //
// //     final response = await http.get(
// //       Uri.parse("$baseUrl/api/pushnotification"),
// //       headers: {
// //         'Authorization': 'Bearer $token',
// //         'Content-Type': 'application/json',
// //       },
// //     );
// //
// //     print('📥 Fetch status: ${response.statusCode}');
// //     print('📦 Fetch body: ${response.body}');
// //
// //     if (response.statusCode != 200) {
// //       throw Exception('Failed to load notifications');
// //     }
// //
// //     final List<dynamic> data = jsonDecode(response.body);
// //     return data.map((e) => e as Map<String, dynamic>).toList();
// //   }
// //
// //   /* =========================================================
// //      ❌ DELETE NOTIFICATION
// //   ========================================================= */
// //   static Future<void> deleteNotification(String id) async {
// //     final token = await _getToken();
// //     if (token == null) throw Exception('Auth token not found');
// //
// //     final url = Uri.parse('$baseUrl/api/pushnotification/$id');
// //
// //     final response = await http.delete(
// //       url,
// //       headers: {
// //         'Authorization': 'Bearer $token',
// //         'Content-Type': 'application/json',
// //       },
// //     );
// //
// //     print('🗑 Delete status: ${response.statusCode}');
// //     print('📦 Delete body: ${response.body}');
// //
// //     if (response.statusCode != 200) {
// //       throw Exception('Failed to delete notification');
// //     }
// //   }
// // }
//
// import 'dart:convert';
// import 'dart:io';
// import 'package:camera/camera.dart';
// import 'package:flutter/foundation.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http_parser/http_parser.dart';
// import 'package:mime/mime.dart';
//
// import '../environmental variables.dart';
//
// class PushNotificationController {
//   /* =========================================================
//      🔐 GET TOKEN
//   ========================================================= */
//   static Future<String?> _getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('accessToken');
//   }
//
//   /* =========================================================
//      📤 SEND / SCHEDULE NOTIFICATION
//   ========================================================= */
//   static Future<Map<String, dynamic>> sendNotification({
//     required String title,
//     required String body,
//     required String event,
//     required String type,
//     String? userId,
//     String? organizationId,
//     String? color,
//     String? icon,
//     String? scheduledAt, // UTC ISO string
//     XFile? imageFile,
//   }) async {
//     final token = await _getToken();
//     if (token == null) throw Exception('Auth token not found');
//
//     final uri = Uri.parse('$baseUrl/api/pushnotification');
//
//     final request = http.MultipartRequest('POST', uri)
//       ..headers['Authorization'] = 'Bearer $token'
//       ..fields['title'] = title
//       ..fields['body'] = body
//       ..fields['event'] = event
//       ..fields['type'] = type;
//
//     /* ================= OPTIONAL FIELDS ================= */
//     if (userId != null) request.fields['userId'] = userId;
//     if (organizationId != null) request.fields['organizationId'] = organizationId;
//     if (color != null) request.fields['color'] = color;
//     if (icon != null) request.fields['icon'] = icon;
//
//     /* ================= ✅ FIX: SCHEDULE ================= */
//     if (scheduledAt != null && scheduledAt.isNotEmpty) {
//       request.fields['scheduledAt'] = scheduledAt;
//       request.fields['isScheduled'] = 'true'; // 🔥 VERY IMPORTANT
//     }
//
//     /* ================= IMAGE ================= */
//     if (imageFile != null) {
//       try {
//         if (kIsWeb) {
//           final bytes = await imageFile.readAsBytes();
//           request.files.add(http.MultipartFile.fromBytes(
//             'image',
//             bytes,
//             filename: imageFile.name,
//             contentType: MediaType.parse(
//               lookupMimeType(imageFile.name) ?? 'image/jpeg',
//             ),
//           ));
//         } else {
//           final file = File(imageFile.path);
//           final mimeType =
//               lookupMimeType(file.path) ?? 'application/octet-stream';
//
//           request.files.add(await http.MultipartFile.fromPath(
//             'image',
//             file.path,
//             contentType: MediaType.parse(mimeType),
//           ));
//         }
//       } catch (e) {
//         print('❌ Image upload error: $e');
//       }
//     }
//
//     /* ================= 🔥 DEBUG LOGS ================= */
//     print("======================================");
//     print("📤 SENDING NOTIFICATION REQUEST");
//     print("🌐 URL: $uri");
//
//     print("📝 Fields:");
//     request.fields.forEach((key, value) {
//       print("   $key : $value");
//     });
//
//     if (imageFile != null) {
//       print("🖼 Image attached: ${imageFile.name}");
//     } else {
//       print("🖼 No image attached");
//     }
//
//     print("======================================");
//
//     try {
//       final streamedResponse = await request.send();
//       final response = await http.Response.fromStream(streamedResponse);
//
//       print("======================================");
//       print("📥 RESPONSE RECEIVED");
//       print("📊 Status Code: ${response.statusCode}");
//       print("📦 Body: ${response.body}");
//       print("======================================");
//
//       final Map<String, dynamic> responseData =
//       jsonDecode(response.body);
//
//       return {
//         'status': response.statusCode,
//         'data': responseData,
//       };
//     } catch (e) {
//       print("======================================");
//       print("❌ REQUEST FAILED: $e");
//       print("======================================");
//
//       return {
//         'status': 500,
//         'data': {'message': 'Client error: $e'},
//       };
//     }
//   }
//
//   /* =========================================================
//      📥 GET ALL NOTIFICATIONS
//   ========================================================= */
//   static Future<List<Map<String, dynamic>>> fetchNotifications() async {
//     final token = await _getToken();
//     if (token == null) throw Exception('Auth token not found');
//
//     final response = await http.get(
//       Uri.parse("$baseUrl/api/pushnotification"),
//       headers: {
//         'Authorization': 'Bearer $token',
//         'Content-Type': 'application/json',
//       },
//     );
//
//     print("📥 FETCH NOTIFICATIONS");
//     print("Status: ${response.statusCode}");
//     print("Body: ${response.body}");
//
//     if (response.statusCode != 200) {
//       throw Exception('Failed to load notifications');
//     }
//
//     final List<dynamic> data = jsonDecode(response.body);
//     return data.map((e) => e as Map<String, dynamic>).toList();
//   }
//
//   /* =========================================================
//      ❌ DELETE NOTIFICATION
//   ========================================================= */
//   static Future<void> deleteNotification(String id) async {
//     final token = await _getToken();
//     if (token == null) throw Exception('Auth token not found');
//
//     final url = Uri.parse('$baseUrl/api/pushnotification/$id');
//
//     final response = await http.delete(
//       url,
//       headers: {
//         'Authorization': 'Bearer $token',
//         'Content-Type': 'application/json',
//       },
//     );
//
//     print("🗑 DELETE NOTIFICATION");
//     print("Status: ${response.statusCode}");
//     print("Body: ${response.body}");
//
//     if (response.statusCode != 200) {
//       throw Exception('Failed to delete notification');
//     }
//   }
// }



import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import '../environmental variables.dart';

class PushNotificationController {
  /* =========================================================
     🔐 GET TOKEN
  ========================================================= */
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  /* =========================================================
     📤 SEND / SCHEDULE NOTIFICATION
  ========================================================= */
  // static Future<Map<String, dynamic>> sendNotification({
  //   required String title,
  //   required String body,
  //   required String event,
  //   required String type,
  //   String? userId,
  //   String? organizationId,
  //   String? color,
  //   String? icon,
  //   String? scheduledAt, // UTC ISO string
  //   XFile? imageFile,
  // }) async {
  //   final token = await _getToken();
  //   if (token == null) throw Exception('Auth token not found');
  //
  //   final uri = Uri.parse('$baseUrl/api/pushnotification');
  //
  //   final request = http.MultipartRequest('POST', uri)
  //     ..headers['Authorization'] = 'Bearer $token'
  //     ..fields['title'] = title
  //     ..fields['body'] = body
  //     ..fields['event'] = event
  //     ..fields['type'] = type;
  //
  //   if (userId != null) request.fields['userId'] = userId;
  //   if (organizationId != null) request.fields['organizationId'] = organizationId;
  //   if (color != null) request.fields['color'] = color;
  //   if (icon != null) request.fields['icon'] = icon;
  //
  //   if (scheduledAt != null && scheduledAt.isNotEmpty) {
  //     request.fields['scheduledAt'] = scheduledAt;
  //     request.fields['isScheduled'] = 'true';
  //   }
  //
  //   /* ================= IMAGE ================= */
  //   if (imageFile != null) {
  //     try {
  //       if (kIsWeb) {
  //         final bytes = await imageFile.readAsBytes();
  //         request.files.add(http.MultipartFile.fromBytes(
  //           'image',
  //           bytes,
  //           filename: imageFile.name,
  //           contentType: MediaType.parse(
  //             lookupMimeType(imageFile.name) ?? 'image/jpeg',
  //           ),
  //         ));
  //       } else {
  //         final file = File(imageFile.path);
  //         final mimeType =
  //             lookupMimeType(file.path) ?? 'application/octet-stream';
  //
  //         request.files.add(await http.MultipartFile.fromPath(
  //           'image',
  //           file.path,
  //           contentType: MediaType.parse(mimeType),
  //         ));
  //       }
  //     } catch (e) {
  //       print('❌ Image upload error: $e');
  //     }
  //   }
  //
  //   /* ================= DEBUG ================= */
  //   print("======================================");
  //   print("📤 SENDING NOTIFICATION");
  //   print("🌐 $uri");
  //   request.fields.forEach((k, v) => print("📝 $k : $v"));
  //   print(imageFile != null ? "🖼 Image: ${imageFile.name}" : "🖼 No image");
  //   print("======================================");
  //
  //   try {
  //     final streamedResponse = await request.send();
  //     final response = await http.Response.fromStream(streamedResponse);
  //
  //     print("📥 RESPONSE: ${response.statusCode}");
  //     print("📦 BODY: ${response.body}");
  //
  //     return {
  //       'status': response.statusCode,
  //       'data': jsonDecode(response.body),
  //     };
  //   } catch (e) {
  //     print("❌ ERROR: $e");
  //     return {
  //       'status': 500,
  //       'data': {'message': 'Client error: $e'},
  //     };
  //   }
  // }

  static Future<Map<String, dynamic>> sendNotification({
    required String title,
    required String body,
    required String event,
    required String type,
    String? userId,
    String? organizationId,
    String? color,
    String? icon,
    String? scheduledAt,
    XFile? imageFile,
  }) async {

    final token = await _getToken();

    if (token == null) {
      throw Exception('Auth token not found');
    }

    final uri = Uri.parse('$baseUrl/api/pushnotification');

    /* =========================================================
     ✅ NORMAL JSON REQUEST (NO IMAGE)
  ========================================================= */

    if (imageFile == null) {

      final bodyData = {
        'title': title,
        'body': body,
        'event': event,
        'type': type,

        if (userId != null) 'userId': userId,
        if (organizationId != null)
          'organizationId': organizationId,

        if (color != null) 'color': color,
        if (icon != null) 'icon': icon,

        if (scheduledAt != null &&
            scheduledAt.isNotEmpty) ...{
          'scheduledAt': scheduledAt,
          'isScheduled': true,
        }
      };

      print("======================================");
      print("📤 SENDING JSON NOTIFICATION");
      print("🌐 $uri");
      print("📦 BODY: $bodyData");
      print("======================================");

      try {

        final response = await http.post(
          uri,
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(bodyData),
        );

        print("📥 RESPONSE: ${response.statusCode}");
        print("📦 BODY: ${response.body}");

        return {
          'status': response.statusCode,
          'data': jsonDecode(response.body),
        };

      } catch (e) {

        print("❌ JSON REQUEST ERROR: $e");

        return {
          'status': 500,
          'data': {
            'message': 'Client error: $e'
          }
        };
      }
    }

    /* =========================================================
     🖼 MULTIPART REQUEST (WITH IMAGE)
  ========================================================= */

    final request = http.MultipartRequest(
      'POST',
      uri,
    );

    request.headers['Authorization'] = 'Bearer $token';

    request.fields['title'] = title;
    request.fields['body'] = body;
    request.fields['event'] = event;
    request.fields['type'] = type;

    if (userId != null) {
      request.fields['userId'] = userId;
    }

    if (organizationId != null) {
      request.fields['organizationId'] = organizationId;
    }

    if (color != null) {
      request.fields['color'] = color;
    }

    if (icon != null) {
      request.fields['icon'] = icon;
    }

    if (scheduledAt != null &&
        scheduledAt.isNotEmpty) {

      request.fields['scheduledAt'] = scheduledAt;
      request.fields['isScheduled'] = 'true';
    }

    /* ================= IMAGE ================= */

    try {

      if (kIsWeb) {

        final bytes = await imageFile.readAsBytes();

        request.files.add(
          http.MultipartFile.fromBytes(
            'image',
            bytes,
            filename: imageFile.name,
            contentType: MediaType.parse(
              lookupMimeType(imageFile.name)
                  ?? 'image/jpeg',
            ),
          ),
        );

      } else {

        final file = File(imageFile.path);

        final mimeType =
            lookupMimeType(file.path)
                ?? 'application/octet-stream';

        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            file.path,
            contentType: MediaType.parse(mimeType),
          ),
        );
      }

    } catch (e) {

      print("❌ IMAGE ERROR: $e");
    }

    print("======================================");
    print("📤 SENDING MULTIPART NOTIFICATION");
    print("🌐 $uri");

    request.fields.forEach((k, v) {
      print("📝 $k : $v");
    });

    print("🖼 IMAGE: ${imageFile.name}");
    print("======================================");

    try {

      final streamedResponse =
      await request.send();

      final response =
      await http.Response.fromStream(
        streamedResponse,
      );

      print("📥 RESPONSE: ${response.statusCode}");
      print("📦 BODY: ${response.body}");

      return {
        'status': response.statusCode,
        'data': jsonDecode(response.body),
      };

    } catch (e) {

      print("❌ MULTIPART ERROR: $e");

      return {
        'status': 500,
        'data': {
          'message': 'Client error: $e'
        }
      };
    }
  }

  /* =========================================================
     📥 GET ALL NOTIFICATIONS
  ========================================================= */
  static Future<List<Map<String, dynamic>>> fetchNotifications() async {
    final token = await _getToken();
    if (token == null) throw Exception('Auth token not found');

    final res = await http.get(
      Uri.parse("$baseUrl/api/pushnotification"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print("📥 FETCH STATUS: ${res.statusCode}");
    print("📦 BODY: ${res.body}");

    if (res.statusCode != 200) {
      throw Exception('Failed to load notifications');
    }

    final List data = jsonDecode(res.body);
    return data.cast<Map<String, dynamic>>();
  }

  /* =========================================================
     📊 GET DELIVERY STATS
  ========================================================= */
  static Future<Map<String, dynamic>> getDeliveryStats(String id) async {
    final token = await _getToken();
    if (token == null) throw Exception('Auth token not found');

    final res = await http.get(
      Uri.parse("$baseUrl/api/pushnotification/$id/stats"),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    print("📊 STATS STATUS: ${res.statusCode}");
    print("📦 BODY: ${res.body}");

    if (res.statusCode != 200) {
      throw Exception('Failed to get stats');
    }

    return jsonDecode(res.body);
  }

  /* =========================================================
     ✏️ UPDATE NOTIFICATION
  ========================================================= */
  static Future<Map<String, dynamic>> updateNotification({
    required String id,
    String? title,
    String? body,
    String? event,
    String? type,
    String? scheduledAt,
    String? color,
    String? icon,
  }) async {
    final token = await _getToken();
    if (token == null) throw Exception('Auth token not found');

    final uri = Uri.parse('$baseUrl/api/pushnotification/$id');

    final bodyData = {
      if (title != null) "title": title,
      if (body != null) "body": body,
      if (event != null) "event": event,
      if (type != null) "type": type,
      if (scheduledAt != null) "scheduledAt": scheduledAt,
      if (color != null) "color": color,
      if (icon != null) "icon": icon,
    };

    print("✏️ UPDATE REQUEST");
    print("🆔 ID: $id");
    print("📦 BODY: $bodyData");

    final res = await http.put(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(bodyData),
    );

    print("📥 RESPONSE: ${res.statusCode}");
    print("📦 BODY: ${res.body}");

    return {
      'status': res.statusCode,
      'data': jsonDecode(res.body),
    };
  }

  /* =========================================================
     🚫 CANCEL NOTIFICATION
  ========================================================= */
  static Future<void> cancelNotification(String id) async {
    final token = await _getToken();
    if (token == null) throw Exception('Auth token not found');

    final uri = Uri.parse('$baseUrl/api/pushnotification/$id/cancel');

    print("🚫 CANCEL NOTIFICATION: $id");

    final res = await http.patch(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    print("📥 STATUS: ${res.statusCode}");
    print("📦 BODY: ${res.body}");

    if (res.statusCode != 200) {
      throw Exception('Failed to cancel notification');
    }
  }

  /* =========================================================
     ❌ DELETE NOTIFICATION
  ========================================================= */
  static Future<void> deleteNotification(String id) async {
    final token = await _getToken();
    if (token == null) throw Exception('Auth token not found');

    final uri = Uri.parse('$baseUrl/api/pushnotification/$id');

    print("🗑 DELETE: $id");

    final res = await http.delete(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    print("📥 STATUS: ${res.statusCode}");
    print("📦 BODY: ${res.body}");

    if (res.statusCode != 200) {
      throw Exception('Failed to delete notification');
    }
  }
}