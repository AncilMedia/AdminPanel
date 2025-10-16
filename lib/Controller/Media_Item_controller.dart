// // // // import 'dart:convert';
// // // // import 'dart:io';
// // // // import 'package:file_picker/file_picker.dart';
// // // // import 'package:flutter/foundation.dart';
// // // // import 'package:http/http.dart' as http;
// // // // import 'package:shared_preferences/shared_preferences.dart';
// // // // import '../environmental variables.dart';
// // // //
// // // // class MediaItemService {
// // // //   // ✅ Create Media Item
// // // //   Future<Map<String, dynamic>> createMediaItem({
// // // //     required String title,
// // // //     required String description,
// // // //     DateTime? selectedDate,
// // // //     String? tags, // comma-separated
// // // //     String? seriesId,
// // // //     List<String>? speakers,
// // // //     List<String>? topics,
// // // //     List<String>? scriptures,
// // // //     File? file, // mobile/desktop
// // // //     PlatformFile? webFile, // web
// // // //   }) async {
// // // //     final prefs = await SharedPreferences.getInstance();
// // // //     final userId = prefs.getString("userId");
// // // //     final orgId = prefs.getString("organizationId");
// // // //     final roleId = prefs.getString("roleId");
// // // //
// // // //     final uri = Uri.parse("$baseUrl/api/media/item");
// // // //     final request = http.MultipartRequest("POST", uri);
// // // //
// // // //     // 🔹 Text fields
// // // //     request.fields["title"] = title;
// // // //     request.fields["description"] = description;
// // // //     if (tags != null) request.fields["tags"] = tags;
// // // //     if (seriesId != null) request.fields["seriesId"] = seriesId;
// // // //     if (userId != null) request.fields["createdBy"] = userId;
// // // //     if (orgId != null) request.fields["organization"] = orgId;
// // // //     if (roleId != null) request.fields["role"] = roleId;
// // // //     if (selectedDate != null) request.fields["date"] = selectedDate.toIso8601String();
// // // //
// // // //     // 🔹 Optional arrays (backend expects them as JSON)
// // // //     if (speakers != null && speakers.isNotEmpty) {
// // // //       request.fields["speakers"] = jsonEncode(speakers);
// // // //     }
// // // //     if (topics != null && topics.isNotEmpty) {
// // // //       request.fields["topics"] = jsonEncode(topics);
// // // //     }
// // // //     if (scriptures != null && scriptures.isNotEmpty) {
// // // //       request.fields["scriptures"] = jsonEncode(scriptures);
// // // //     }
// // // //
// // // //     // 🔹 File upload (optional)
// // // //     if (kIsWeb && webFile != null) {
// // // //       request.files.add(
// // // //         http.MultipartFile.fromBytes(
// // // //           "file",
// // // //           webFile.bytes!,
// // // //           filename: webFile.name,
// // // //         ),
// // // //       );
// // // //     } else if (!kIsWeb && file != null) {
// // // //       request.files.add(
// // // //         await http.MultipartFile.fromPath("file", file.path),
// // // //       );
// // // //     }
// // // //     // else: no file uploaded, optional
// // // //
// // // //     print("📤 POST $uri with fields: ${request.fields.keys.toList()}");
// // // //
// // // //     final response = await request.send();
// // // //     final resBody = await response.stream.bytesToString();
// // // //     print("⬇️ Response [${response.statusCode}]: $resBody");
// // // //
// // // //     return jsonDecode(resBody);
// // // //   }
// // // //
// // // //   // ✅ Get All Media Items
// // // //   Future<List<dynamic>> getMediaItems() async {
// // // //     final uri = Uri.parse("$baseUrl/api/media/item");
// // // //     print("📤 GET $uri");
// // // //
// // // //     final response = await http.get(uri);
// // // //     print("⬇️ Response [${response.statusCode}]: ${response.body}");
// // // //
// // // //     final decoded = jsonDecode(response.body);
// // // //     if (decoded is List) return decoded;
// // // //     if (decoded is Map && decoded.containsKey("error")) throw Exception(decoded["error"]);
// // // //     return [];
// // // //   }
// // // //
// // // //   // ✅ Filter by User / Organization
// // // //   Future<List<dynamic>> getMediaItemsByUserOrOrg({
// // // //     String? userId,
// // // //     String? organizationId,
// // // //   }) async {
// // // //     final queryParams = <String, String>{};
// // // //     if (userId != null) queryParams['userId'] = userId;
// // // //     if (organizationId != null) queryParams['organizationId'] = organizationId;
// // // //
// // // //     final uri = Uri.parse("$baseUrl/api/media/item/filter")
// // // //         .replace(queryParameters: queryParams);
// // // //     print("📤 GET $uri");
// // // //
// // // //     final response = await http.get(uri);
// // // //     print("⬇️ Response [${response.statusCode}]: ${response.body}");
// // // //
// // // //     final decoded = jsonDecode(response.body);
// // // //     if (decoded is List) return decoded;
// // // //     if (decoded is Map && decoded.containsKey("error")) throw Exception(decoded["error"]);
// // // //     return [];
// // // //   }
// // // //
// // // //   // ✅ Get Media Item by ID
// // // //   Future<Map<String, dynamic>> getMediaItemById(String id) async {
// // // //     final uri = Uri.parse("$baseUrl/api/media/item/$id");
// // // //     print("📤 GET $uri");
// // // //
// // // //     final response = await http.get(uri);
// // // //     print("⬇️ Response [${response.statusCode}]: ${response.body}");
// // // //     return jsonDecode(response.body);
// // // //   }
// // // //
// // // //   // ✅ Update Media Item by ID
// // // //   Future<Map<String, dynamic>> updateMediaItem(
// // // //       String id, {
// // // //         String? title,
// // // //         String? description,
// // // //         DateTime? selectedDate,
// // // //         List<String>? tags,
// // // //         String? seriesId,
// // // //         List<String>? speakers,
// // // //         List<String>? topics,
// // // //         List<String>? scriptures,
// // // //       }) async {
// // // //     final body = <String, dynamic>{};
// // // //     if (title != null) body['title'] = title;
// // // //     if (description != null) body['description'] = description;
// // // //     if (tags != null) body['tags'] = tags;
// // // //     if (seriesId != null) body['seriesId'] = seriesId;
// // // //     if (speakers != null) body['speakers'] = speakers;
// // // //     if (topics != null) body['topics'] = topics;
// // // //     if (scriptures != null) body['scriptures'] = scriptures;
// // // //     if (selectedDate != null) body['date'] = selectedDate.toIso8601String();
// // // //
// // // //     final uri = Uri.parse("$baseUrl/api/media/item/$id");
// // // //     print("📤 PUT $uri with body: $body");
// // // //
// // // //     final response = await http.put(
// // // //       uri,
// // // //       headers: {"Content-Type": "application/json"},
// // // //       body: jsonEncode(body),
// // // //     );
// // // //
// // // //     print("⬇️ Response [${response.statusCode}]: ${response.body}");
// // // //     return jsonDecode(response.body);
// // // //   }
// // // //
// // // //   // ✅ Bulk Edit Tags
// // // //   Future<Map<String, dynamic>> bulkEditMediaItems({
// // // //     required List<String> ids,
// // // //     required List<String> tags,
// // // //   }) async {
// // // //     final uri = Uri.parse("$baseUrl/api/media/item/bulk-edit");
// // // //     final body = {"ids": ids, "tags": tags};
// // // //
// // // //     print("📤 PUT $uri with body: $body");
// // // //
// // // //     final response = await http.put(
// // // //       uri,
// // // //       headers: {"Content-Type": "application/json"},
// // // //       body: jsonEncode(body),
// // // //     );
// // // //
// // // //     print("⬇️ Response [${response.statusCode}]: ${response.body}");
// // // //     return jsonDecode(response.body);
// // // //   }
// // // //
// // // //   // ✅ Delete Media Item
// // // //   Future<Map<String, dynamic>> deleteMediaItem(String id) async {
// // // //     final uri = Uri.parse("$baseUrl/api/media/item/$id");
// // // //     print("📤 DELETE $uri");
// // // //
// // // //     final response = await http.delete(uri);
// // // //     print("⬇️ Response [${response.statusCode}]: ${response.body}");
// // // //     return jsonDecode(response.body);
// // // //   }
// // // // }
// // //
// // //
// // // import 'dart:convert';
// // // import 'dart:io';
// // // import 'package:file_picker/file_picker.dart';
// // // import 'package:flutter/foundation.dart';
// // // import 'package:http/http.dart' as http;
// // // import 'package:shared_preferences/shared_preferences.dart';
// // // import '../environmental variables.dart';
// // //
// // // class MediaItemService {
// // //   // ✅ Create Media Item
// // //   Future<Map<String, dynamic>> createMediaItem({
// // //     required String title,
// // //     required String description,
// // //     DateTime? selectedDate,
// // //     String? tags, // comma-separated
// // //     String? seriesId,
// // //     List<String>? speakers,
// // //     List<String>? topics,
// // //     List<String>? scriptures,
// // //     File? file, // mobile/desktop
// // //     PlatformFile? webFile, // web
// // //     File? thumbnailFile, // mobile/desktop
// // //     PlatformFile? webThumbnailFile, // web
// // //   }) async {
// // //     final prefs = await SharedPreferences.getInstance();
// // //     final userId = prefs.getString("userId");
// // //     final orgId = prefs.getString("organizationId");
// // //     final roleId = prefs.getString("roleId");
// // //
// // //     final uri = Uri.parse("$baseUrl/api/media/item");
// // //     final request = http.MultipartRequest("POST", uri);
// // //     request.headers['Accept'] = 'application/json';
// // //
// // //     // 🔹 Required fields
// // //     request.fields["title"] = title;
// // //     request.fields["description"] = description;
// // //
// // //     // 🔹 Optional simple fields
// // //     if (tags != null && tags.isNotEmpty) request.fields["tags"] = tags;
// // //     if (seriesId != null && seriesId.isNotEmpty) request.fields["seriesId"] = seriesId;
// // //     if (selectedDate != null) {
// // //       request.fields["date"] = selectedDate.toIso8601String();
// // //     }
// // //
// // //     // 🔹 Relational fields
// // //     if (userId != null) request.fields["createdBy"] = userId;
// // //     if (orgId != null) request.fields["organization"] = orgId;
// // //     if (roleId != null) request.fields["role"] = roleId;
// // //
// // //     // 🔹 JSON array fields
// // //     if (speakers != null && speakers.isNotEmpty) {
// // //       request.fields["speakers"] = jsonEncode(speakers);
// // //     }
// // //     if (topics != null && topics.isNotEmpty) {
// // //       request.fields["topics"] = jsonEncode(topics);
// // //     }
// // //     if (scriptures != null && scriptures.isNotEmpty) {
// // //       request.fields["scriptures"] = jsonEncode(scriptures);
// // //     }
// // //
// // //     // 🔹 Upload main media file (video/audio)
// // //     if (kIsWeb && webFile != null) {
// // //       request.files.add(
// // //         http.MultipartFile.fromBytes(
// // //           "file",
// // //           webFile.bytes!,
// // //           filename: webFile.name,
// // //         ),
// // //       );
// // //     } else if (!kIsWeb && file != null) {
// // //       request.files.add(
// // //         await http.MultipartFile.fromPath("file", file.path),
// // //       );
// // //     }
// // //
// // //     // 🔹 Upload thumbnail (optional)
// // //     if (kIsWeb && webThumbnailFile != null) {
// // //       request.files.add(
// // //         http.MultipartFile.fromBytes(
// // //           "thumbnail",
// // //           webThumbnailFile.bytes!,
// // //           filename: webThumbnailFile.name,
// // //         ),
// // //       );
// // //     } else if (!kIsWeb && thumbnailFile != null) {
// // //       request.files.add(
// // //         await http.MultipartFile.fromPath("thumbnail", thumbnailFile.path),
// // //       );
// // //     }
// // //
// // //     // 🧭 Debug logs
// // //     print("📤 POST $uri");
// // //     print("📦 Fields: ${jsonEncode(request.fields)}");
// // //     print("📎 Files: ${request.files.map((f) => f.field).toList()}");
// // //
// // //     // 🔹 Send Request
// // //     final response = await request.send();
// // //     final resBody = await response.stream.bytesToString();
// // //     print("⬇️ Response [${response.statusCode}]: $resBody");
// // //
// // //     // 🔹 Error handling
// // //     if (response.statusCode >= 200 && response.statusCode < 300) {
// // //       return jsonDecode(resBody);
// // //     } else {
// // //       throw Exception("Failed to create media item: ${response.statusCode} - $resBody");
// // //     }
// // //   }
// // //
// // //   // ✅ Get All Media Items
// // //   Future<List<dynamic>> getMediaItems() async {
// // //     final uri = Uri.parse("$baseUrl/api/media/item");
// // //     print("📤 GET $uri");
// // //
// // //     final response = await http.get(uri);
// // //     print("⬇️ Response [${response.statusCode}]: ${response.body}");
// // //
// // //     final decoded = jsonDecode(response.body);
// // //     if (decoded is List) return decoded;
// // //     if (decoded is Map && decoded.containsKey("error")) {
// // //       throw Exception(decoded["error"]);
// // //     }
// // //     return [];
// // //   }
// // //
// // //   // ✅ Filter by User / Organization
// // //   Future<List<dynamic>> getMediaItemsByUserOrOrg({
// // //     String? userId,
// // //     String? organizationId,
// // //   }) async {
// // //     final queryParams = <String, String>{};
// // //     if (userId != null) queryParams['userId'] = userId;
// // //     if (organizationId != null) queryParams['organizationId'] = organizationId;
// // //
// // //     final uri = Uri.parse("$baseUrl/api/media/item/filter")
// // //         .replace(queryParameters: queryParams);
// // //     print("📤 GET $uri");
// // //
// // //     final response = await http.get(uri);
// // //     print("⬇️ Response [${response.statusCode}]: ${response.body}");
// // //
// // //     final decoded = jsonDecode(response.body);
// // //     if (decoded is List) return decoded;
// // //     if (decoded is Map && decoded.containsKey("error")) {
// // //       throw Exception(decoded["error"]);
// // //     }
// // //     return [];
// // //   }
// // //
// // //   // ✅ Get Media Item by ID
// // //   Future<Map<String, dynamic>> getMediaItemById(String id) async {
// // //     final uri = Uri.parse("$baseUrl/api/media/item/$id");
// // //     print("📤 GET $uri");
// // //
// // //     final response = await http.get(uri);
// // //     print("⬇️ Response [${response.statusCode}]: ${response.body}");
// // //
// // //     if (response.statusCode >= 200 && response.statusCode < 300) {
// // //       return jsonDecode(response.body);
// // //     } else {
// // //       throw Exception("Failed to fetch media item: ${response.statusCode}");
// // //     }
// // //   }
// // //
// // //   // ✅ Update Media Item
// // //   Future<Map<String, dynamic>> updateMediaItem(
// // //       String id, {
// // //         String? title,
// // //         String? description,
// // //         DateTime? selectedDate,
// // //         List<String>? tags,
// // //         String? seriesId,
// // //         List<String>? speakers,
// // //         List<String>? topics,
// // //         List<String>? scriptures,
// // //       }) async {
// // //     final body = <String, dynamic>{};
// // //     if (title != null) body['title'] = title;
// // //     if (description != null) body['description'] = description;
// // //     if (tags != null) body['tags'] = tags;
// // //     if (seriesId != null) body['seriesId'] = seriesId;
// // //     if (speakers != null) body['speakers'] = speakers;
// // //     if (topics != null) body['topics'] = topics;
// // //     if (scriptures != null) body['scriptures'] = scriptures;
// // //     if (selectedDate != null) {
// // //       body['date'] = selectedDate.toIso8601String();
// // //     }
// // //
// // //     final uri = Uri.parse("$baseUrl/api/media/item/$id");
// // //     print("📤 PUT $uri with body: $body");
// // //
// // //     final response = await http.put(
// // //       uri,
// // //       headers: {"Content-Type": "application/json"},
// // //       body: jsonEncode(body),
// // //     );
// // //
// // //     print("⬇️ Response [${response.statusCode}]: ${response.body}");
// // //     if (response.statusCode >= 200 && response.statusCode < 300) {
// // //       return jsonDecode(response.body);
// // //     } else {
// // //       throw Exception("Failed to update media item: ${response.statusCode}");
// // //     }
// // //   }
// // //
// // //   // ✅ Bulk Edit Tags
// // //   Future<Map<String, dynamic>> bulkEditMediaItems({
// // //     required List<String> ids,
// // //     required List<String> tags,
// // //   }) async {
// // //     final uri = Uri.parse("$baseUrl/api/media/item/bulk-edit");
// // //     final body = {"ids": ids, "tags": tags};
// // //
// // //     print("📤 PUT $uri with body: $body");
// // //
// // //     final response = await http.put(
// // //       uri,
// // //       headers: {"Content-Type": "application/json"},
// // //       body: jsonEncode(body),
// // //     );
// // //
// // //     print("⬇️ Response [${response.statusCode}]: ${response.body}");
// // //     if (response.statusCode >= 200 && response.statusCode < 300) {
// // //       return jsonDecode(response.body);
// // //     } else {
// // //       throw Exception("Failed to bulk edit: ${response.statusCode}");
// // //     }
// // //   }
// // //
// // //   // ✅ Delete Media Item
// // //   Future<Map<String, dynamic>> deleteMediaItem(String id) async {
// // //     final uri = Uri.parse("$baseUrl/api/media/item/$id");
// // //     print("📤 DELETE $uri");
// // //
// // //     final response = await http.delete(uri);
// // //     print("⬇️ Response [${response.statusCode}]: ${response.body}");
// // //
// // //     if (response.statusCode >= 200 && response.statusCode < 300) {
// // //       return jsonDecode(response.body);
// // //     } else {
// // //       throw Exception("Failed to delete media item: ${response.statusCode}");
// // //     }
// // //   }
// // // }
// //
// //
// //
// //
// // import 'dart:convert';
// // import 'dart:io';
// // import 'package:file_picker/file_picker.dart';
// // import 'package:flutter/foundation.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:shared_preferences/shared_preferences.dart';
// // import '../environmental variables.dart';
// //
// // class MediaItemService {
// //   // ✅ Create Media Item
// //   Future<Map<String, dynamic>> createMediaItem({
// //     required String title,
// //     required String description,
// //     DateTime? selectedDate,
// //     String? tags,
// //     String? seriesId,
// //     List<String>? speakers,
// //     List<String>? topics,
// //     List<String>? scriptures,
// //     File? file,
// //     PlatformFile? webFile,
// //     File? thumbnailFile,
// //     PlatformFile? webThumbnailFile,
// //   }) async {
// //     final prefs = await SharedPreferences.getInstance();
// //     final userId = prefs.getString("userId");
// //     final orgId = prefs.getString("organizationId");
// //     final roleId = prefs.getString("roleId");
// //
// //     if (userId == null || orgId == null || roleId == null) {
// //       throw Exception("User, organization, or role not set in SharedPreferences");
// //     }
// //
// //     if ((file == null && webFile == null)) {
// //       throw Exception("Media file is required");
// //     }
// //
// //     final uri = Uri.parse("$baseUrl/api/media/item");
// //     final request = http.MultipartRequest("POST", uri);
// //     request.headers['Accept'] = 'application/json';
// //
// //     // Required fields
// //     request.fields["title"] = title;
// //     request.fields["description"] = description;
// //     request.fields["createdBy"] = userId;
// //     request.fields["organization"] = orgId;
// //     request.fields["role"] = roleId;
// //
// //     // Optional fields
// //     if (tags != null && tags.isNotEmpty) request.fields["tags"] = tags;
// //     if (seriesId != null && seriesId.isNotEmpty) request.fields["seriesId"] = seriesId;
// //     if (selectedDate != null) request.fields["date"] = selectedDate.toIso8601String();
// //
// //     // Relational JSON fields
// //     if (speakers != null && speakers.isNotEmpty) request.fields["speakers"] = jsonEncode(speakers);
// //     if (topics != null && topics.isNotEmpty) request.fields["topics"] = jsonEncode(topics);
// //     if (scriptures != null && scriptures.isNotEmpty) request.fields["scriptures"] = jsonEncode(scriptures);
// //
// //     // Attach main media file
// //     if (kIsWeb && webFile != null) {
// //       request.files.add(http.MultipartFile.fromBytes("file", webFile.bytes!, filename: webFile.name));
// //     } else if (!kIsWeb && file != null) {
// //       request.files.add(await http.MultipartFile.fromPath("file", file.path));
// //     }
// //
// //     // Attach thumbnail
// //     if (kIsWeb && webThumbnailFile != null) {
// //       request.files.add(http.MultipartFile.fromBytes("thumbnail", webThumbnailFile.bytes!, filename: webThumbnailFile.name));
// //     } else if (!kIsWeb && thumbnailFile != null) {
// //       request.files.add(await http.MultipartFile.fromPath("thumbnail", thumbnailFile.path));
// //     }
// //
// //     print("📤 POST $uri");
// //     print("📦 Fields: ${jsonEncode(request.fields)}");
// //     print("📎 Files: ${request.files.map((f) => f.filename).toList()}");
// //
// //     final response = await request.send();
// //     final resBody = await response.stream.bytesToString();
// //     print("⬇️ Response [${response.statusCode}]: $resBody");
// //
// //     if (response.statusCode >= 200 && response.statusCode < 300) {
// //       return jsonDecode(resBody);
// //     } else {
// //       throw Exception("Failed to create media item: ${response.statusCode} - $resBody");
// //     }
// //   }
// //
// //   // Fetch media items filtered by user or organization
// //   Future<List<dynamic>> getMediaItemsByUserOrOrg({
// //     String? userId,
// //     String? organizationId,
// //   }) async {
// //     final queryParams = <String, String>{};
// //     if (userId != null) queryParams['userId'] = userId;
// //     if (organizationId != null) queryParams['organizationId'] = organizationId;
// //
// //     final uri = Uri.parse("$baseUrl/api/media/item/filter")
// //         .replace(queryParameters: queryParams);
// //
// //     print("📤 GET $uri");
// //
// //     final response = await http.get(uri);
// //
// //     print("⬇️ Response [${response.statusCode}]: ${response.body}");
// //
// //     if (response.statusCode >= 200 && response.statusCode < 300) {
// //       final decoded = jsonDecode(response.body);
// //       if (decoded is List) return decoded;
// //       if (decoded is Map && decoded.containsKey("error")) {
// //         throw Exception(decoded["error"]);
// //       }
// //       return [];
// //     } else {
// //       throw Exception("Failed to fetch filtered media items: ${response.statusCode}");
// //     }
// //   }
// //
// //
// //   // ✅ Get All Media Items
// //   Future<List<dynamic>> getMediaItems() async {
// //     final uri = Uri.parse("$baseUrl/api/media/item");
// //     final response = await http.get(uri);
// //     if (response.statusCode >= 200 && response.statusCode < 300) {
// //       final decoded = jsonDecode(response.body);
// //       if (decoded is List) return decoded;
// //     }
// //     throw Exception("Failed to fetch media items: ${response.statusCode}");
// //   }
// //
// //   // ✅ Get Media Item by ID
// //   Future<Map<String, dynamic>> getMediaItemById(String id) async {
// //     final uri = Uri.parse("$baseUrl/api/media/item/$id");
// //     final response = await http.get(uri);
// //     if (response.statusCode >= 200 && response.statusCode < 300) {
// //       return jsonDecode(response.body);
// //     }
// //     throw Exception("Failed to fetch media item: ${response.statusCode}");
// //   }
// //
// //   // ✅ Fetch all speakers
// //   Future<List<Map<String, dynamic>>> fetchSpeakers() async {
// //     final url = '$baseUrl/api/mediaspeaker';
// //     print("📤 GET $url");
// //
// //     final response = await http.get(Uri.parse(url));
// //     print("⬇️ Response [${response.statusCode}]: ${response.body}");
// //
// //     if (response.statusCode == 200) {
// //       final decoded = json.decode(response.body);
// //       if (decoded is List) {
// //         print("✅ Speakers fetched: ${decoded.length}");
// //         return decoded.cast<Map<String, dynamic>>();
// //       } else {
// //         print("⚠️ Unexpected response format for speakers");
// //         return [];
// //       }
// //     } else {
// //       throw Exception('Failed to load speakers: ${response.statusCode}');
// //     }
// //   }
// //
// // // ✅ Fetch all topics
// //   Future<List<Map<String, dynamic>>> fetchTopics() async {
// //     final url = '$baseUrl/api/mediatopic';
// //     print("📤 GET $url");
// //
// //     final response = await http.get(Uri.parse(url));
// //     print("⬇️ Response [${response.statusCode}]: ${response.body}");
// //
// //     if (response.statusCode == 200) {
// //       final decoded = json.decode(response.body);
// //       if (decoded is List) {
// //         print("✅ Topics fetched: ${decoded.length}");
// //         return decoded.cast<Map<String, dynamic>>();
// //       } else {
// //         print("⚠️ Unexpected response format for topics");
// //         return [];
// //       }
// //     } else {
// //       throw Exception('Failed to load topics: ${response.statusCode}');
// //     }
// //   }
// //
// // // ✅ Fetch all scriptures
// //   Future<List<Map<String, dynamic>>> fetchScriptures() async {
// //     final url = '$baseUrl/api/mediascripture';
// //     print("📤 GET $url");
// //
// //     final response = await http.get(Uri.parse(url));
// //     print("⬇️ Response [${response.statusCode}]: ${response.body}");
// //
// //     if (response.statusCode == 200) {
// //       final decoded = json.decode(response.body);
// //       if (decoded is List) {
// //         print("✅ Scriptures fetched: ${decoded.length}");
// //         return decoded.cast<Map<String, dynamic>>();
// //       } else {
// //         print("⚠️ Unexpected response format for scriptures");
// //         return [];
// //       }
// //     } else {
// //       throw Exception('Failed to load scriptures: ${response.statusCode}');
// //     }
// //   }
// //
// // }
//
//
//
// import 'dart:convert';
// import 'dart:io';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/foundation.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import '../environmental variables.dart';
//
// class MediaItemService {
//   // ✅ Create Media Item
//   Future<Map<String, dynamic>> createMediaItem({
//     required String title,
//     required String description,
//     DateTime? selectedDate,
//     String? tags,
//     String? seriesId,
//     List<String>? speakers,
//     List<String>? topics,
//     List<String>? scriptures,
//     File? file,
//     PlatformFile? webFile,
//     File? thumbnailFile,
//     PlatformFile? webThumbnailFile,
//   }) async {
//     final prefs = await SharedPreferences.getInstance();
//     final userId = prefs.getString("userId");
//     final orgId = prefs.getString("organizationId");
//     final roleId = prefs.getString("roleId");
//
//     if (userId == null || orgId == null || roleId == null) {
//       throw Exception("User, organization, or role not set in SharedPreferences");
//     }
//
//     if ((file == null && webFile == null)) {
//       throw Exception("Media file is required");
//     }
//
//     final uri = Uri.parse("$baseUrl/api/media/item");
//     final request = http.MultipartRequest("POST", uri);
//     request.headers['Accept'] = 'application/json';
//
//     // Required fields
//     request.fields["title"] = title;
//     request.fields["description"] = description;
//     request.fields["createdBy"] = userId;
//     request.fields["organization"] = orgId;
//     request.fields["role"] = roleId;
//
//     // Optional fields
//     if (tags != null && tags.isNotEmpty) request.fields["tags"] = tags;
//     if (seriesId != null && seriesId.isNotEmpty) request.fields["seriesId"] = seriesId;
//     if (selectedDate != null) request.fields["date"] = selectedDate.toIso8601String();
//
//     // Relational fields
//     if (speakers != null && speakers.isNotEmpty) {
//       request.fields["speakers"] = jsonEncode(speakers.where((s) => s.isNotEmpty).toList());
//     }
//     if (topics != null && topics.isNotEmpty) {
//       request.fields["topics"] = jsonEncode(topics.where((t) => t.isNotEmpty).toList());
//     }
//     if (scriptures != null && scriptures.isNotEmpty) {
//       request.fields["scriptures"] = jsonEncode(scriptures.where((s) => s.isNotEmpty).toList());
//     }
//
//     // Attach main media file
//     if (kIsWeb && webFile != null && webFile.bytes != null) {
//       request.files.add(
//         http.MultipartFile.fromBytes("file", webFile.bytes!, filename: webFile.name),
//       );
//     } else if (!kIsWeb && file != null) {
//       request.files.add(await http.MultipartFile.fromPath("file", file.path));
//     }
//
//     // Attach thumbnail
//     if (kIsWeb && webThumbnailFile != null && webThumbnailFile.bytes != null) {
//       request.files.add(
//         http.MultipartFile.fromBytes("thumbnail", webThumbnailFile.bytes!, filename: webThumbnailFile.name),
//       );
//     } else if (!kIsWeb && thumbnailFile != null) {
//       request.files.add(await http.MultipartFile.fromPath("thumbnail", thumbnailFile.path));
//     }
//
//     if (kDebugMode) {
//       print("📤 POST $uri");
//       print("📦 Fields: ${jsonEncode(request.fields)}");
//       print("📎 Files: ${request.files.map((f) => f.filename).toList()}");
//     }
//
//     final response = await request.send().timeout(const Duration(seconds: 60));
//     final resBody = await response.stream.bytesToString();
//
//     if (kDebugMode) {
//       print("⬇️ Response [${response.statusCode}]: $resBody");
//     }
//
//     if (response.statusCode >= 200 && response.statusCode < 300) {
//       return jsonDecode(resBody);
//     } else {
//       throw Exception("Failed to create media item: ${response.statusCode} - $resBody");
//     }
//   }
//
//   // ✅ Fetch media items filtered by user or organization
//   Future<List<dynamic>> getMediaItemsByUserOrOrg({
//     String? userId,
//     String? organizationId,
//   }) async {
//     final queryParams = <String, String>{};
//     if (userId != null) queryParams['userId'] = userId;
//     if (organizationId != null) queryParams['organizationId'] = organizationId;
//
//     final uri = Uri.parse("$baseUrl/api/media/item/filter")
//         .replace(queryParameters: queryParams);
//
//     if (kDebugMode) print("📤 GET $uri");
//
//     final response = await http.get(uri).timeout(const Duration(seconds: 30));
//
//     if (kDebugMode) print("⬇️ Response [${response.statusCode}]: ${response.body}");
//
//     if (response.statusCode >= 200 && response.statusCode < 300) {
//       final decoded = jsonDecode(response.body);
//       if (decoded is List) return decoded;
//       if (decoded is Map && decoded.containsKey("error")) {
//         throw Exception(decoded["error"]);
//       }
//       return [];
//     } else {
//       throw Exception("Failed to fetch filtered media items: ${response.statusCode}");
//     }
//   }
//
//   // ✅ Get all media items
//   Future<List<dynamic>> getMediaItems() async {
//     final uri = Uri.parse("$baseUrl/api/media/item");
//     final response = await http.get(uri).timeout(const Duration(seconds: 30));
//     if (response.statusCode >= 200 && response.statusCode < 300) {
//       final decoded = jsonDecode(response.body);
//       if (decoded is List) return decoded;
//     }
//     throw Exception("Failed to fetch media items: ${response.statusCode}");
//   }
//
//   // ✅ Get media item by ID
//   Future<Map<String, dynamic>> getMediaItemById(String id) async {
//     final uri = Uri.parse("$baseUrl/api/media/item/$id");
//     final response = await http.get(uri).timeout(const Duration(seconds: 30));
//     if (response.statusCode >= 200 && response.statusCode < 300) {
//       return jsonDecode(response.body);
//     }
//     throw Exception("Failed to fetch media item: ${response.statusCode}");
//   }
//
//   // ✅ Fetch all speakers
//   Future<List<Map<String, dynamic>>> fetchSpeakers() async {
//     final url = '$baseUrl/api/mediaspeaker';
//     if (kDebugMode) print("📤 GET $url");
//
//     final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 30));
//
//     if (kDebugMode) print("⬇️ Response [${response.statusCode}]: ${response.body}");
//
//     if (response.statusCode == 200) {
//       final decoded = jsonDecode(response.body);
//       if (decoded is List) return decoded.cast<Map<String, dynamic>>();
//       return [];
//     } else {
//       throw Exception('Failed to load speakers: ${response.statusCode}');
//     }
//   }
//
//   // ✅ Fetch all topics
//   Future<List<Map<String, dynamic>>> fetchTopics() async {
//     final url = '$baseUrl/api/mediatopic';
//     if (kDebugMode) print("📤 GET $url");
//
//     final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 30));
//
//     if (kDebugMode) print("⬇️ Response [${response.statusCode}]: ${response.body}");
//
//     if (response.statusCode == 200) {
//       final decoded = jsonDecode(response.body);
//       if (decoded is List) return decoded.cast<Map<String, dynamic>>();
//       return [];
//     } else {
//       throw Exception('Failed to load topics: ${response.statusCode}');
//     }
//   }
//
//   // ✅ Fetch all scriptures
//   Future<List<Map<String, dynamic>>> fetchScriptures() async {
//     final url = '$baseUrl/api/mediascripture';
//     if (kDebugMode) print("📤 GET $url");
//
//     final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 30));
//
//     if (kDebugMode) print("⬇️ Response [${response.statusCode}]: ${response.body}");
//
//     if (response.statusCode == 200) {
//       final decoded = jsonDecode(response.body);
//       if (decoded is List) return decoded.cast<Map<String, dynamic>>();
//       return [];
//     } else {
//       throw Exception('Failed to load scriptures: ${response.statusCode}');
//     }
//   }
// }


import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../environmental variables.dart';

class MediaItemService {
  // ✅ Create Media Item
  Future<Map<String, dynamic>> createMediaItem({
    required String title,
    required String description,
    DateTime? selectedDate,
    String? tags,
    String? seriesId,
    List<String>? speakers,
    List<String>? topics,
    List<String>? scriptures,
    File? file,
    PlatformFile? webFile,
    File? thumbnailFile,
    PlatformFile? webThumbnailFile,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString("userId");
    final orgId = prefs.getString("organizationId");
    final roleId = prefs.getString("roleId");

    if (userId == null || orgId == null || roleId == null) {
      throw Exception("User, organization, or role not set in SharedPreferences");
    }

    if (file == null && webFile == null) {
      throw Exception("Main media file is required");
    }

    final uri = Uri.parse("$baseUrl/api/media/item");
    final request = http.MultipartRequest("POST", uri);
    request.headers['Accept'] = 'application/json';

    // ✅ Required fields
    request.fields["title"] = title;
    request.fields["description"] = description;
    request.fields["createdBy"] = userId;
    request.fields["organization"] = orgId;
    request.fields["role"] = roleId;

    // ✅ Optional fields
    if (tags?.isNotEmpty == true) request.fields["tags"] = tags!;
    if (seriesId?.isNotEmpty == true) request.fields["seriesId"] = seriesId!;
    if (selectedDate != null) request.fields["date"] = selectedDate.toIso8601String();

    // ✅ Relational fields
    if (speakers != null && speakers.isNotEmpty) {
      request.fields["speakers"] = jsonEncode(speakers.where((e) => e.isNotEmpty).toList());
    }
    if (topics != null && topics.isNotEmpty) {
      request.fields["topics"] = jsonEncode(topics.where((e) => e.isNotEmpty).toList());
    }
    if (scriptures != null && scriptures.isNotEmpty) {
      request.fields["scriptures"] = jsonEncode(scriptures.where((e) => e.isNotEmpty).toList());
    }

    // ✅ Attach main media file
    if (kIsWeb && webFile != null && webFile.bytes != null) {
      final mimeType = lookupMimeType(webFile.name) ?? 'application/octet-stream';
      request.files.add(http.MultipartFile.fromBytes(
        "file",
        webFile.bytes!,
        filename: webFile.name,
        contentType: MediaType.parse(mimeType),
      ));
    } else if (!kIsWeb && file != null) {
      final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
      request.files.add(await http.MultipartFile.fromPath(
        "file",
        file.path,
        contentType: MediaType.parse(mimeType),
      ));
    }

    // ✅ Attach thumbnail (optional)
    if (kIsWeb && webThumbnailFile != null && webThumbnailFile.bytes != null) {
      final mimeType = lookupMimeType(webThumbnailFile.name) ?? 'application/octet-stream';
      request.files.add(http.MultipartFile.fromBytes(
        "thumbnail",
        webThumbnailFile.bytes!,
        filename: webThumbnailFile.name,
        contentType: MediaType.parse(mimeType),
      ));
    } else if (!kIsWeb && thumbnailFile != null) {
      final mimeType = lookupMimeType(thumbnailFile.path) ?? 'application/octet-stream';
      request.files.add(await http.MultipartFile.fromPath(
        "thumbnail",
        thumbnailFile.path,
        contentType: MediaType.parse(mimeType),
      ));
    }

    if (kDebugMode) {
      print("📤 POST $uri");
      print("📦 Fields: ${jsonEncode(request.fields)}");
      print("📎 Files: ${request.files.map((f) => f.filename).toList()}");
    }

    final response = await request.send().timeout(const Duration(seconds: 60));
    final resBody = await response.stream.bytesToString();

    if (kDebugMode) {
      print("⬇️ Response [${response.statusCode}]: $resBody");
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(resBody);
    } else {
      throw Exception("❌ Failed to create media item: ${response.statusCode} - $resBody");
    }
  }

  // ✅ Get all media items
  Future<List<dynamic>> getMediaItems() async {
    final uri = Uri.parse("$baseUrl/api/media/item");
    final response = await http.get(uri).timeout(const Duration(seconds: 30));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final decoded = jsonDecode(response.body);
      if (decoded is List) return decoded;
    }
    throw Exception("Failed to fetch media items: ${response.statusCode}");
  }

  // ✅ Get media items by user or organization
  Future<List<dynamic>> getMediaItemsByUserOrOrg({
    String? userId,
    String? organizationId,
  }) async {
    final queryParams = <String, String>{};
    if (userId != null) queryParams['userId'] = userId;
    if (organizationId != null) queryParams['organizationId'] = organizationId;

    final uri = Uri.parse("$baseUrl/api/media/item/filter").replace(queryParameters: queryParams);

    if (kDebugMode) print("📤 GET $uri");

    final response = await http.get(uri).timeout(const Duration(seconds: 30));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final decoded = jsonDecode(response.body);
      if (decoded is List) return decoded;
      if (decoded is Map && decoded.containsKey("error")) throw Exception(decoded["error"]);
      return [];
    } else {
      throw Exception("Failed to fetch filtered media items: ${response.statusCode}");
    }
  }

  // ✅ Get media item by ID
  Future<Map<String, dynamic>> getMediaItemById(String id) async {
    final uri = Uri.parse("$baseUrl/api/media/item/$id");
    final response = await http.get(uri).timeout(const Duration(seconds: 30));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    }
    throw Exception("Failed to fetch media item: ${response.statusCode}");
  }

  // ✅ Fetch all speakers
  Future<List<Map<String, dynamic>>> fetchSpeakers() async {
    final url = '$baseUrl/api/mediaspeaker';
    final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return (decoded is List) ? decoded.cast<Map<String, dynamic>>() : [];
    } else {
      throw Exception('Failed to load speakers: ${response.statusCode}');
    }
  }

  // ✅ Fetch all topics
  Future<List<Map<String, dynamic>>> fetchTopics() async {
    final url = '$baseUrl/api/mediatopic';
    final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return (decoded is List) ? decoded.cast<Map<String, dynamic>>() : [];
    } else {
      throw Exception('Failed to load topics: ${response.statusCode}');
    }
  }

  // ✅ Fetch all scriptures
  Future<List<Map<String, dynamic>>> fetchScriptures() async {
    final url = '$baseUrl/api/mediascripture';
    final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return (decoded is List) ? decoded.cast<Map<String, dynamic>>() : [];
    } else {
      throw Exception('Failed to load scriptures: ${response.statusCode}');
    }
  }
}
