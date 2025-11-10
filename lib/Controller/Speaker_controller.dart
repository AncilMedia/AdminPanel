// // // // // // // // // import 'dart:convert';
// // // // // // // // // import 'dart:io';
// // // // // // // // // import 'package:flutter/foundation.dart' show kIsWeb;
// // // // // // // // // import 'package:http/http.dart' as http;
// // // // // // // // // import 'package:image_picker/image_picker.dart';
// // // // // // // // //
// // // // // // // // // import '../environmental variables.dart';
// // // // // // // // //
// // // // // // // // //
// // // // // // // // // class MediaSpeakerController {
// // // // // // // // //   // Replace with your actual backend API URL
// // // // // // // // //   // static const String baseUrl = "http://your-server-ip:5000/api/speakers";
// // // // // // // // //
// // // // // // // // //   /// Create new speaker
// // // // // // // // //   static Future<Map<String, dynamic>> createSpeaker({
// // // // // // // // //     required String name,
// // // // // // // // //     required String designation,
// // // // // // // // //     String? bio,
// // // // // // // // //     XFile? imageFile,
// // // // // // // // //     required String createdBy,
// // // // // // // // //     required String organization,
// // // // // // // // //     required String role,
// // // // // // // // //   }) async {
// // // // // // // // //     try {
// // // // // // // // //       var uri = Uri.parse('$baseUrl/api/speakers');
// // // // // // // // //       var request = http.MultipartRequest("POST", uri);
// // // // // // // // //
// // // // // // // // //       // ✅ Text fields
// // // // // // // // //       request.fields['name'] = name;
// // // // // // // // //       request.fields['designation'] = designation;
// // // // // // // // //       if (bio != null && bio.isNotEmpty) {
// // // // // // // // //         request.fields['bio'] = bio;
// // // // // // // // //       }
// // // // // // // // //       request.fields['createdBy'] = createdBy;
// // // // // // // // //       request.fields['organization'] = organization;
// // // // // // // // //       request.fields['role'] = role;
// // // // // // // // //
// // // // // // // // //       // ✅ Add image file (if exists)
// // // // // // // // //       if (imageFile != null) {
// // // // // // // // //         if (kIsWeb) {
// // // // // // // // //           // For web platform, use bytes directly
// // // // // // // // //           final bytes = await imageFile.readAsBytes();
// // // // // // // // //           request.files.add(http.MultipartFile.fromBytes(
// // // // // // // // //             'image',
// // // // // // // // //             bytes,
// // // // // // // // //             filename: imageFile.name,
// // // // // // // // //           ));
// // // // // // // // //         } else {
// // // // // // // // //           // For mobile platforms
// // // // // // // // //           request.files.add(await http.MultipartFile.fromPath(
// // // // // // // // //             'image',
// // // // // // // // //             imageFile.path,
// // // // // // // // //           ));
// // // // // // // // //         }
// // // // // // // // //       }
// // // // // // // // //
// // // // // // // // //       // ✅ Send request
// // // // // // // // //       var streamedResponse = await request.send();
// // // // // // // // //       var response = await http.Response.fromStream(streamedResponse);
// // // // // // // // //
// // // // // // // // //       if (response.statusCode == 201) {
// // // // // // // // //         return {"success": true, "data": jsonDecode(response.body)};
// // // // // // // // //       } else {
// // // // // // // // //         return {
// // // // // // // // //           "success": false,
// // // // // // // // //           "error":
// // // // // // // // //           jsonDecode(response.body)['error'] ?? "Failed to create speaker"
// // // // // // // // //         };
// // // // // // // // //       }
// // // // // // // // //     } catch (e) {
// // // // // // // // //       return {"success": false, "error": e.toString()};
// // // // // // // // //     }
// // // // // // // // //   }
// // // // // // // // //
// // // // // // // // //   /// Get all speakers
// // // // // // // // //   static Future<List<dynamic>> getSpeakers() async {
// // // // // // // // //     try {
// // // // // // // // //       var response = await http.get(Uri.parse("$baseUrl/api/speakers"));
// // // // // // // // //
// // // // // // // // //       if (response.statusCode == 200) {
// // // // // // // // //         return jsonDecode(response.body);
// // // // // // // // //       } else {
// // // // // // // // //         throw Exception("Failed to load speakers");
// // // // // // // // //       }
// // // // // // // // //     } catch (e) {
// // // // // // // // //       rethrow;
// // // // // // // // //     }
// // // // // // // // //   }
// // // // // // // // //
// // // // // // // // //   /// Delete speaker by ID
// // // // // // // // //   static Future<bool> deleteSpeaker(String id) async {
// // // // // // // // //     try {
// // // // // // // // //       var response = await http.delete(Uri.parse("$baseUrl/api/speakers/$id"));
// // // // // // // // //
// // // // // // // // //       if (response.statusCode == 200) return true;
// // // // // // // // //       return false;
// // // // // // // // //     } catch (e) {
// // // // // // // // //       return false;
// // // // // // // // //     }
// // // // // // // // //   }
// // // // // // // // // }
// // // // // // // //
// // // // // // // //
// // // // // // // // import 'dart:convert';
// // // // // // // // import 'dart:io';
// // // // // // // // import 'package:flutter/foundation.dart';
// // // // // // // // import 'package:http/http.dart' as http;
// // // // // // // // import 'package:shared_preferences/shared_preferences.dart';
// // // // // // // //
// // // // // // // // import '../environmental variables.dart';
// // // // // // // //
// // // // // // // // class MediaSpeakerController {
// // // // // // // //
// // // // // // // //   /// ✅ Helper: Get organization ID from SharedPreferences
// // // // // // // //   Future<String?> _getOrganizationId() async {
// // // // // // // //     final prefs = await SharedPreferences.getInstance();
// // // // // // // //     return prefs.getString('organizationId');
// // // // // // // //   }
// // // // // // // //
// // // // // // // //   /// ✅ Helper: Get user ID (createdBy)
// // // // // // // //   Future<String?> _getUserId() async {
// // // // // // // //     final prefs = await SharedPreferences.getInstance();
// // // // // // // //     return prefs.getString('userId');
// // // // // // // //   }
// // // // // // // //
// // // // // // // //   // -------------------------------------------------------------------------
// // // // // // // //   // 🔹 Get All Speakers (optionally filtered by organization)
// // // // // // // //   // -------------------------------------------------------------------------
// // // // // // // //   Future<List<Map<String, dynamic>>> getSpeakers() async {
// // // // // // // //     try {
// // // // // // // //       final organizationId = await _getOrganizationId();
// // // // // // // //       final createdBy = await _getUserId();
// // // // // // // //
// // // // // // // //       final uri = Uri.parse("$baseUrl/api/speakers?organization=$organizationId&createdBy=$createdBy");
// // // // // // // //
// // // // // // // //       final res = await http.get(uri);
// // // // // // // //
// // // // // // // //       if (res.statusCode == 200) {
// // // // // // // //         final List data = json.decode(res.body);
// // // // // // // //         return List<Map<String, dynamic>>.from(data);
// // // // // // // //       } else {
// // // // // // // //         throw Exception('Failed to load speakers: ${res.body}');
// // // // // // // //       }
// // // // // // // //     } catch (e) {
// // // // // // // //       if (kDebugMode) print("Error fetching speakers: $e");
// // // // // // // //       return [];
// // // // // // // //     }
// // // // // // // //   }
// // // // // // // //
// // // // // // // //   // -------------------------------------------------------------------------
// // // // // // // //   // 🔹 Create Speaker
// // // // // // // //   // -------------------------------------------------------------------------
// // // // // // // //   Future<bool> createSpeaker({
// // // // // // // //     required String name,
// // // // // // // //     required String designation,
// // // // // // // //     String? bio,
// // // // // // // //     File? imageFile,
// // // // // // // //     String? roleId,
// // // // // // // //   }) async {
// // // // // // // //     try {
// // // // // // // //       final orgId = await _getOrganizationId();
// // // // // // // //       final createdBy = await _getUserId();
// // // // // // // //
// // // // // // // //       if (orgId == null || createdBy == null) {
// // // // // // // //         throw Exception("Organization or user not found in preferences");
// // // // // // // //       }
// // // // // // // //
// // // // // // // //       // 🧩 If image file exists, upload via multipart
// // // // // // // //       var request = http.MultipartRequest('POST', Uri.parse("$baseUrl/api/speakers"));
// // // // // // // //       request.fields['name'] = name;
// // // // // // // //       request.fields['designation'] = designation;
// // // // // // // //       request.fields['bio'] = bio ?? '';
// // // // // // // //       request.fields['organization'] = orgId;
// // // // // // // //       request.fields['createdBy'] = createdBy;
// // // // // // // //       request.fields['role'] = roleId ?? '';
// // // // // // // //
// // // // // // // //       if (imageFile != null) {
// // // // // // // //         request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
// // // // // // // //       }
// // // // // // // //
// // // // // // // //       final res = await request.send();
// // // // // // // //       if (res.statusCode == 201) {
// // // // // // // //         return true;
// // // // // // // //       } else {
// // // // // // // //         final body = await res.stream.bytesToString();
// // // // // // // //         throw Exception('Create failed: $body');
// // // // // // // //       }
// // // // // // // //     } catch (e) {
// // // // // // // //       if (kDebugMode) print("Error creating speaker: $e");
// // // // // // // //       return false;
// // // // // // // //     }
// // // // // // // //   }
// // // // // // // //
// // // // // // // //   // -------------------------------------------------------------------------
// // // // // // // //   // 🔹 Update Speaker
// // // // // // // //   // -------------------------------------------------------------------------
// // // // // // // //   Future<bool> updateSpeaker({
// // // // // // // //     required String id,
// // // // // // // //     required String name,
// // // // // // // //     required String designation,
// // // // // // // //     String? bio,
// // // // // // // //     File? imageFile,
// // // // // // // //     String? roleId,
// // // // // // // //   }) async {
// // // // // // // //     try {
// // // // // // // //       final orgId = await _getOrganizationId();
// // // // // // // //       final createdBy = await _getUserId();
// // // // // // // //
// // // // // // // //       final uri = Uri.parse("$baseUrl/api/speakers/$id");
// // // // // // // //       var request = http.MultipartRequest('PUT', uri);
// // // // // // // //       request.fields['name'] = name;
// // // // // // // //       request.fields['designation'] = designation;
// // // // // // // //       request.fields['bio'] = bio ?? '';
// // // // // // // //       request.fields['organization'] = orgId ?? '';
// // // // // // // //       request.fields['createdBy'] = createdBy ?? '';
// // // // // // // //       request.fields['role'] = roleId ?? '';
// // // // // // // //
// // // // // // // //       if (imageFile != null) {
// // // // // // // //         request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
// // // // // // // //       }
// // // // // // // //
// // // // // // // //       final res = await request.send();
// // // // // // // //       if (res.statusCode == 200) {
// // // // // // // //         return true;
// // // // // // // //       } else {
// // // // // // // //         final body = await res.stream.bytesToString();
// // // // // // // //         throw Exception('Update failed: $body');
// // // // // // // //       }
// // // // // // // //     } catch (e) {
// // // // // // // //       if (kDebugMode) print("Error updating speaker: $e");
// // // // // // // //       return false;
// // // // // // // //     }
// // // // // // // //   }
// // // // // // // //
// // // // // // // //   // -------------------------------------------------------------------------
// // // // // // // //   // 🔹 Delete Speaker
// // // // // // // //   // -------------------------------------------------------------------------
// // // // // // // //   Future<bool> deleteSpeaker(String id) async {
// // // // // // // //     try {
// // // // // // // //       final res = await http.delete(Uri.parse("$baseUrl/api/speakers/$id"));
// // // // // // // //       if (res.statusCode == 200) return true;
// // // // // // // //       throw Exception('Delete failed: ${res.body}');
// // // // // // // //     } catch (e) {
// // // // // // // //       if (kDebugMode) print("Error deleting speaker: $e");
// // // // // // // //       return false;
// // // // // // // //     }
// // // // // // // //   }
// // // // // // // //
// // // // // // // //   // -------------------------------------------------------------------------
// // // // // // // //   // 🔹 Get Speaker by ID
// // // // // // // //   // -------------------------------------------------------------------------
// // // // // // // //   Future<Map<String, dynamic>?> getSpeakerById(String id) async {
// // // // // // // //     try {
// // // // // // // //       final res = await http.get(Uri.parse("$baseUrl/api/speakers/$id"));
// // // // // // // //       if (res.statusCode == 200) {
// // // // // // // //         return json.decode(res.body);
// // // // // // // //       } else {
// // // // // // // //         throw Exception('Speaker not found: ${res.body}');
// // // // // // // //       }
// // // // // // // //     } catch (e) {
// // // // // // // //       if (kDebugMode) print("Error fetching speaker by id: $e");
// // // // // // // //       return null;
// // // // // // // //     }
// // // // // // // //   }
// // // // // // // // }
// // // // // // //
// // // // // // //
// // // // // // // import 'dart:convert';
// // // // // // // import 'dart:io';
// // // // // // // import 'package:flutter/foundation.dart';
// // // // // // // import 'package:http/http.dart' as http;
// // // // // // // import 'package:shared_preferences/shared_preferences.dart';
// // // // // // //
// // // // // // // import '../environmental variables.dart';
// // // // // // //
// // // // // // // class MediaSpeakerController {
// // // // // // //   // Your backend endpoint pattern: baseUrl/api/speakers
// // // // // // //   final String endpoint = "$baseUrl/api/mediaspeaker";
// // // // // // //
// // // // // // //   /// ✅ Get organization ID
// // // // // // //   Future<String?> _getOrganizationId() async {
// // // // // // //     final prefs = await SharedPreferences.getInstance();
// // // // // // //     return prefs.getString('organizationId');
// // // // // // //   }
// // // // // // //
// // // // // // //   /// ✅ Get user ID (createdBy)
// // // // // // //   Future<String?> _getUserId() async {
// // // // // // //     final prefs = await SharedPreferences.getInstance();
// // // // // // //     return prefs.getString('userId');
// // // // // // //   }
// // // // // // //
// // // // // // //   // -------------------------------------------------------------------------
// // // // // // //   // 🔹 Get All Speakers (filtered by organization + createdBy)
// // // // // // //   // -------------------------------------------------------------------------
// // // // // // //   Future<List<Map<String, dynamic>>> getSpeakers() async {
// // // // // // //     try {
// // // // // // //       final organizationId = await _getOrganizationId();
// // // // // // //       final createdBy = await _getUserId();
// // // // // // //
// // // // // // //       final uri = Uri.parse(
// // // // // // //           "$endpoint?organization=$organizationId&createdBy=$createdBy");
// // // // // // //
// // // // // // //       final res = await http.get(uri);
// // // // // // //
// // // // // // //       if (res.statusCode == 200) {
// // // // // // //         final List data = json.decode(res.body);
// // // // // // //         return List<Map<String, dynamic>>.from(data);
// // // // // // //       } else {
// // // // // // //         throw Exception('Failed to load speakers: ${res.body}');
// // // // // // //       }
// // // // // // //     } catch (e) {
// // // // // // //       if (kDebugMode) print("❌ Error fetching speakers: $e");
// // // // // // //       return [];
// // // // // // //     }
// // // // // // //   }
// // // // // // //
// // // // // // //   // -------------------------------------------------------------------------
// // // // // // //   // 🔹 Create Speaker
// // // // // // //   // -------------------------------------------------------------------------
// // // // // // //   Future<bool> createSpeaker({
// // // // // // //     required String name,
// // // // // // //     required String designation,
// // // // // // //     String? bio,
// // // // // // //     File? imageFile,
// // // // // // //     String? roleId,
// // // // // // //   }) async {
// // // // // // //     try {
// // // // // // //       final orgId = await _getOrganizationId();
// // // // // // //       final createdBy = await _getUserId();
// // // // // // //
// // // // // // //       if (orgId == null || createdBy == null) {
// // // // // // //         throw Exception("Organization or user not found in preferences");
// // // // // // //       }
// // // // // // //
// // // // // // //       var request = http.MultipartRequest('POST', Uri.parse(endpoint));
// // // // // // //
// // // // // // //       request.fields['name'] = name;
// // // // // // //       request.fields['designation'] = designation;
// // // // // // //       request.fields['bio'] = bio ?? '';
// // // // // // //       request.fields['organization'] = orgId;
// // // // // // //       request.fields['createdBy'] = createdBy;
// // // // // // //       request.fields['role'] = roleId ?? '';
// // // // // // //
// // // // // // //       if (!kIsWeb && imageFile != null) {
// // // // // // //         request.files
// // // // // // //             .add(await http.MultipartFile.fromPath('image', imageFile.path));
// // // // // // //       }
// // // // // // //
// // // // // // //       final response = await request.send();
// // // // // // //       final resBody = await response.stream.bytesToString();
// // // // // // //
// // // // // // //       if (response.statusCode == 201) {
// // // // // // //         return true;
// // // // // // //       } else {
// // // // // // //         if (kDebugMode) print("❌ Create failed: $resBody");
// // // // // // //         return false;
// // // // // // //       }
// // // // // // //     } catch (e) {
// // // // // // //       if (kDebugMode) print("❌ Error creating speaker: $e");
// // // // // // //       return false;
// // // // // // //     }
// // // // // // //   }
// // // // // // //
// // // // // // //   // -------------------------------------------------------------------------
// // // // // // //   // 🔹 Update Speaker
// // // // // // //   // -------------------------------------------------------------------------
// // // // // // //   Future<bool> updateSpeaker({
// // // // // // //     required String id,
// // // // // // //     required String name,
// // // // // // //     required String designation,
// // // // // // //     String? bio,
// // // // // // //     File? imageFile,
// // // // // // //     String? roleId,
// // // // // // //   }) async {
// // // // // // //     try {
// // // // // // //       final orgId = await _getOrganizationId();
// // // // // // //       final createdBy = await _getUserId();
// // // // // // //
// // // // // // //       final uri = Uri.parse("$endpoint/$id");
// // // // // // //       var request = http.MultipartRequest('PUT', uri);
// // // // // // //
// // // // // // //       request.fields['name'] = name;
// // // // // // //       request.fields['designation'] = designation;
// // // // // // //       request.fields['bio'] = bio ?? '';
// // // // // // //       request.fields['organization'] = orgId ?? '';
// // // // // // //       request.fields['createdBy'] = createdBy ?? '';
// // // // // // //       request.fields['role'] = roleId ?? '';
// // // // // // //
// // // // // // //       if (!kIsWeb && imageFile != null) {
// // // // // // //         request.files
// // // // // // //             .add(await http.MultipartFile.fromPath('image', imageFile.path));
// // // // // // //       }
// // // // // // //
// // // // // // //       final response = await request.send();
// // // // // // //       final resBody = await response.stream.bytesToString();
// // // // // // //
// // // // // // //       if (response.statusCode == 200) {
// // // // // // //         return true;
// // // // // // //       } else {
// // // // // // //         if (kDebugMode) print("❌ Update failed: $resBody");
// // // // // // //         return false;
// // // // // // //       }
// // // // // // //     } catch (e) {
// // // // // // //       if (kDebugMode) print("❌ Error updating speaker: $e");
// // // // // // //       return false;
// // // // // // //     }
// // // // // // //   }
// // // // // // //
// // // // // // //   // -------------------------------------------------------------------------
// // // // // // //   // 🔹 Delete Speaker
// // // // // // //   // -------------------------------------------------------------------------
// // // // // // //   Future<bool> deleteSpeaker(String id) async {
// // // // // // //     try {
// // // // // // //       final res = await http.delete(Uri.parse("$endpoint/$id"));
// // // // // // //       if (res.statusCode == 200) return true;
// // // // // // //       if (kDebugMode) print("❌ Delete failed: ${res.body}");
// // // // // // //       return false;
// // // // // // //     } catch (e) {
// // // // // // //       if (kDebugMode) print("❌ Error deleting speaker: $e");
// // // // // // //       return false;
// // // // // // //     }
// // // // // // //   }
// // // // // // //
// // // // // // //   // -------------------------------------------------------------------------
// // // // // // //   // 🔹 Get Speaker by ID
// // // // // // //   // -------------------------------------------------------------------------
// // // // // // //   Future<Map<String, dynamic>?> getSpeakerById(String id) async {
// // // // // // //     try {
// // // // // // //       final res = await http.get(Uri.parse("$endpoint/$id"));
// // // // // // //       if (res.statusCode == 200) {
// // // // // // //         return json.decode(res.body);
// // // // // // //       } else {
// // // // // // //         if (kDebugMode) print("❌ Speaker not found: ${res.body}");
// // // // // // //         return null;
// // // // // // //       }
// // // // // // //     } catch (e) {
// // // // // // //       if (kDebugMode) print("❌ Error fetching speaker by id: $e");
// // // // // // //       return null;
// // // // // // //     }
// // // // // // //   }
// // // // // // // }
// // // // // //
// // // // // //
// // // // // // import 'dart:convert';
// // // // // // import 'dart:io';
// // // // // // import 'package:flutter/foundation.dart';
// // // // // // import 'package:http/http.dart' as http;
// // // // // // import 'package:shared_preferences/shared_preferences.dart';
// // // // // // import '../environmental variables.dart';
// // // // // //
// // // // // // class MediaSpeakerController {
// // // // // //   // API endpoint pattern: baseUrl/api/speakers
// // // // // //   final String endpoint = "$baseUrl/api/mediaspeaker";
// // // // // //
// // // // // //   /// 🔹 Get organizationId from SharedPreferences
// // // // // //   Future<String?> _getOrganizationId() async {
// // // // // //     final prefs = await SharedPreferences.getInstance();
// // // // // //     return prefs.getString('organizationId');
// // // // // //   }
// // // // // //
// // // // // //   /// 🔹 Get createdBy (User ID) from SharedPreferences
// // // // // //   Future<String?> _getUserId() async {
// // // // // //     final prefs = await SharedPreferences.getInstance();
// // // // // //     return prefs.getString('userId');
// // // // // //   }
// // // // // //
// // // // // //   // -------------------------------------------------------------------------
// // // // // //   // 🔹 Get All Speakers
// // // // // //   // -------------------------------------------------------------------------
// // // // // //   Future<List<Map<String, dynamic>>> getSpeakers() async {
// // // // // //     try {
// // // // // //       final orgId = await _getOrganizationId();
// // // // // //       final createdBy = await _getUserId();
// // // // // //
// // // // // //       final uri = Uri.parse("$endpoint?organization=$orgId&createdBy=$createdBy");
// // // // // //       final res = await http.get(uri);
// // // // // //
// // // // // //       if (res.statusCode == 200) {
// // // // // //         final List data = json.decode(res.body);
// // // // // //         return List<Map<String, dynamic>>.from(data);
// // // // // //       } else {
// // // // // //         throw Exception('Failed to load speakers: ${res.body}');
// // // // // //       }
// // // // // //     } catch (e) {
// // // // // //       if (kDebugMode) print("❌ Error fetching speakers: $e");
// // // // // //       return [];
// // // // // //     }
// // // // // //   }
// // // // // //
// // // // // //   // -------------------------------------------------------------------------
// // // // // //   // 🔹 Create Speaker (Multipart)
// // // // // //   // -------------------------------------------------------------------------
// // // // // //   Future<bool> createSpeaker({
// // // // // //     required String name,
// // // // // //     required String designation,
// // // // // //     String? bio,
// // // // // //     File? imageFile,
// // // // // //   }) async {
// // // // // //     try {
// // // // // //       final orgId = await _getOrganizationId();
// // // // // //       final createdBy = await _getUserId();
// // // // // //
// // // // // //       if (orgId == null || createdBy == null) {
// // // // // //         throw Exception("Missing organization or user ID");
// // // // // //       }
// // // // // //
// // // // // //       var request = http.MultipartRequest('POST', Uri.parse(endpoint));
// // // // // //
// // // // // //       // ✅ Add text fields
// // // // // //       request.fields.addAll({
// // // // // //         'name': name,
// // // // // //         'designation': designation,
// // // // // //         'bio': bio ?? '',
// // // // // //         'organization': orgId,
// // // // // //         'createdBy': createdBy,
// // // // // //       });
// // // // // //
// // // // // //       // ✅ Add image file (only if exists)
// // // // // //       if (!kIsWeb && imageFile != null) {
// // // // // //         request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
// // // // // //       }
// // // // // //
// // // // // //       // ✅ Send request
// // // // // //       final response = await request.send();
// // // // // //       final responseBody = await response.stream.bytesToString();
// // // // // //
// // // // // //       if (response.statusCode == 201 || response.statusCode == 200) {
// // // // // //         if (kDebugMode) print("✅ Speaker created successfully: $responseBody");
// // // // // //         return true;
// // // // // //       } else {
// // // // // //         if (kDebugMode) print("❌ Create failed: $responseBody");
// // // // // //         return false;
// // // // // //       }
// // // // // //     } catch (e) {
// // // // // //       if (kDebugMode) print("❌ Error creating speaker: $e");
// // // // // //       return false;
// // // // // //     }
// // // // // //   }
// // // // // //
// // // // // //   // -------------------------------------------------------------------------
// // // // // //   // 🔹 Update Speaker
// // // // // //   // -------------------------------------------------------------------------
// // // // // //   Future<bool> updateSpeaker({
// // // // // //     required String id,
// // // // // //     required String name,
// // // // // //     required String designation,
// // // // // //     String? bio,
// // // // // //     File? imageFile,
// // // // // //   }) async {
// // // // // //     try {
// // // // // //       final orgId = await _getOrganizationId();
// // // // // //       final createdBy = await _getUserId();
// // // // // //
// // // // // //       final uri = Uri.parse("$endpoint/$id");
// // // // // //       var request = http.MultipartRequest('PUT', uri);
// // // // // //
// // // // // //       request.fields.addAll({
// // // // // //         'name': name,
// // // // // //         'designation': designation,
// // // // // //         'bio': bio ?? '',
// // // // // //         'organization': orgId ?? '',
// // // // // //         'createdBy': createdBy ?? '',
// // // // // //       });
// // // // // //
// // // // // //       if (!kIsWeb && imageFile != null) {
// // // // // //         request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
// // // // // //       }
// // // // // //
// // // // // //       final response = await request.send();
// // // // // //       final resBody = await response.stream.bytesToString();
// // // // // //
// // // // // //       if (response.statusCode == 200) {
// // // // // //         return true;
// // // // // //       } else {
// // // // // //         if (kDebugMode) print("❌ Update failed: $resBody");
// // // // // //         return false;
// // // // // //       }
// // // // // //     } catch (e) {
// // // // // //       if (kDebugMode) print("❌ Error updating speaker: $e");
// // // // // //       return false;
// // // // // //     }
// // // // // //   }
// // // // // //
// // // // // //   // -------------------------------------------------------------------------
// // // // // //   // 🔹 Delete Speaker
// // // // // //   // -------------------------------------------------------------------------
// // // // // //   Future<bool> deleteSpeaker(String id) async {
// // // // // //     try {
// // // // // //       final res = await http.delete(Uri.parse("$endpoint/$id"));
// // // // // //       if (res.statusCode == 200) return true;
// // // // // //       if (kDebugMode) print("❌ Delete failed: ${res.body}");
// // // // // //       return false;
// // // // // //     } catch (e) {
// // // // // //       if (kDebugMode) print("❌ Error deleting speaker: $e");
// // // // // //       return false;
// // // // // //     }
// // // // // //   }
// // // // // //
// // // // // //   // -------------------------------------------------------------------------
// // // // // //   // 🔹 Get Speaker by ID
// // // // // //   // -------------------------------------------------------------------------
// // // // // //   Future<Map<String, dynamic>?> getSpeakerById(String id) async {
// // // // // //     try {
// // // // // //       final res = await http.get(Uri.parse("$endpoint/$id"));
// // // // // //       if (res.statusCode == 200) {
// // // // // //         return json.decode(res.body);
// // // // // //       } else {
// // // // // //         if (kDebugMode) print("❌ Speaker not found: ${res.body}");
// // // // // //         return null;
// // // // // //       }
// // // // // //     } catch (e) {
// // // // // //       if (kDebugMode) print("❌ Error fetching speaker by id: $e");
// // // // // //       return null;
// // // // // //     }
// // // // // //   }
// // // // // // }
// // // // //
// // // // //
// // // // //
// // // // // import 'dart:convert';
// // // // // import 'dart:io';
// // // // // import 'package:flutter/foundation.dart';
// // // // // import 'package:http/http.dart' as http;
// // // // // import 'package:shared_preferences/shared_preferences.dart';
// // // // // import '../environmental variables.dart';
// // // // //
// // // // // class MediaSpeakerController {
// // // // //   // API endpoint
// // // // //   final String endpoint = "$baseUrl/api/mediaspeaker";
// // // // //
// // // // //   /// 🔹 Get organizationId from SharedPreferences
// // // // //   Future<String?> _getOrganizationId() async {
// // // // //     final prefs = await SharedPreferences.getInstance();
// // // // //     return prefs.getString('organizationId');
// // // // //   }
// // // // //
// // // // //   /// 🔹 Get createdBy (User ID) from SharedPreferences
// // // // //   Future<String?> _getUserId() async {
// // // // //     final prefs = await SharedPreferences.getInstance();
// // // // //     return prefs.getString('userId');
// // // // //   }
// // // // //
// // // // //   // -------------------------------------------------------------------------
// // // // //   // 🔹 Get All Speakers
// // // // //   // -------------------------------------------------------------------------
// // // // //   Future<List<Map<String, dynamic>>> getSpeakers() async {
// // // // //     try {
// // // // //       final orgId = await _getOrganizationId();
// // // // //       final createdBy = await _getUserId();
// // // // //
// // // // //       final uri = Uri.parse("$endpoint?organization=$orgId&createdBy=$createdBy");
// // // // //       final res = await http.get(uri);
// // // // //
// // // // //       if (res.statusCode == 200) {
// // // // //         final List data = json.decode(res.body);
// // // // //         return List<Map<String, dynamic>>.from(data);
// // // // //       } else {
// // // // //         throw Exception('Failed to load speakers: ${res.body}');
// // // // //       }
// // // // //     } catch (e) {
// // // // //       if (kDebugMode) print("❌ Error fetching speakers: $e");
// // // // //       return [];
// // // // //     }
// // // // //   }
// // // // //
// // // // //   // -------------------------------------------------------------------------
// // // // //   // 🔹 Create Speaker (Multipart) — handles both Web & Mobile
// // // // //   // -------------------------------------------------------------------------
// // // // //   Future<bool> createSpeaker({
// // // // //     required String name,
// // // // //     required String designation,
// // // // //     String? bio,
// // // // //     File? imageFile, // For mobile
// // // // //     Uint8List? imageBytes, // For web
// // // // //   }) async {
// // // // //     try {
// // // // //       final orgId = await _getOrganizationId();
// // // // //       final createdBy = await _getUserId();
// // // // //
// // // // //       if (orgId == null || createdBy == null) {
// // // // //         throw Exception("Missing organization or user ID");
// // // // //       }
// // // // //
// // // // //       var request = http.MultipartRequest('POST', Uri.parse(endpoint));
// // // // //
// // // // //       // ✅ Add text fields
// // // // //       request.fields.addAll({
// // // // //         'name': name,
// // // // //         'designation': designation,
// // // // //         'bio': bio ?? '',
// // // // //         'organization': orgId,
// // // // //         'createdBy': createdBy,
// // // // //       });
// // // // //
// // // // //       // ✅ Add image file (for web or mobile)
// // // // //       if (kIsWeb && imageBytes != null) {
// // // // //         request.files.add(http.MultipartFile.fromBytes(
// // // // //           'image',
// // // // //           imageBytes,
// // // // //           filename: 'speaker.png',
// // // // //         ));
// // // // //       } else if (!kIsWeb && imageFile != null) {
// // // // //         request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
// // // // //       }
// // // // //
// // // // //       // ✅ Send request
// // // // //       final response = await request.send();
// // // // //       final responseBody = await response.stream.bytesToString();
// // // // //
// // // // //       if (response.statusCode == 201 || response.statusCode == 200) {
// // // // //         if (kDebugMode) print("✅ Speaker created successfully: $responseBody");
// // // // //         return true;
// // // // //       } else {
// // // // //         if (kDebugMode) print("❌ Create failed: $responseBody");
// // // // //         return false;
// // // // //       }
// // // // //     } catch (e) {
// // // // //       if (kDebugMode) print("❌ Error creating speaker: $e");
// // // // //       return false;
// // // // //     }
// // // // //   }
// // // // //
// // // // //   // -------------------------------------------------------------------------
// // // // //   // 🔹 Update Speaker (Multipart)
// // // // //   // -------------------------------------------------------------------------
// // // // //   Future<bool> updateSpeaker({
// // // // //     required String id,
// // // // //     required String name,
// // // // //     required String designation,
// // // // //     String? bio,
// // // // //     File? imageFile, // For mobile
// // // // //     Uint8List? imageBytes, // For web
// // // // //   }) async {
// // // // //     try {
// // // // //       final orgId = await _getOrganizationId();
// // // // //       final createdBy = await _getUserId();
// // // // //
// // // // //       final uri = Uri.parse("$endpoint/$id");
// // // // //       var request = http.MultipartRequest('PUT', uri);
// // // // //
// // // // //       // ✅ Add text fields
// // // // //       request.fields.addAll({
// // // // //         'name': name,
// // // // //         'designation': designation,
// // // // //         'bio': bio ?? '',
// // // // //         'organization': orgId ?? '',
// // // // //         'createdBy': createdBy ?? '',
// // // // //       });
// // // // //
// // // // //       // ✅ Add image file (for web or mobile)
// // // // //       if (kIsWeb && imageBytes != null) {
// // // // //         request.files.add(http.MultipartFile.fromBytes(
// // // // //           'image',
// // // // //           imageBytes,
// // // // //           filename: 'speaker.png',
// // // // //         ));
// // // // //       } else if (!kIsWeb && imageFile != null) {
// // // // //         request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
// // // // //       }
// // // // //
// // // // //       final response = await request.send();
// // // // //       final resBody = await response.stream.bytesToString();
// // // // //
// // // // //       if (response.statusCode == 200) {
// // // // //         if (kDebugMode) print("✅ Speaker updated successfully: $resBody");
// // // // //         return true;
// // // // //       } else {
// // // // //         if (kDebugMode) print("❌ Update failed: $resBody");
// // // // //         return false;
// // // // //       }
// // // // //     } catch (e) {
// // // // //       if (kDebugMode) print("❌ Error updating speaker: $e");
// // // // //       return false;
// // // // //     }
// // // // //   }
// // // // //
// // // // //   // -------------------------------------------------------------------------
// // // // //   // 🔹 Delete Speaker
// // // // //   // -------------------------------------------------------------------------
// // // // //   Future<bool> deleteSpeaker(String id) async {
// // // // //     try {
// // // // //       final res = await http.delete(Uri.parse("$endpoint/$id"));
// // // // //       if (res.statusCode == 200) {
// // // // //         if (kDebugMode) print("✅ Speaker deleted: $id");
// // // // //         return true;
// // // // //       }
// // // // //       if (kDebugMode) print("❌ Delete failed: ${res.body}");
// // // // //       return false;
// // // // //     } catch (e) {
// // // // //       if (kDebugMode) print("❌ Error deleting speaker: $e");
// // // // //       return false;
// // // // //     }
// // // // //   }
// // // // //
// // // // //   // -------------------------------------------------------------------------
// // // // //   // 🔹 Get Speaker by ID
// // // // //   // -------------------------------------------------------------------------
// // // // //   Future<Map<String, dynamic>?> getSpeakerById(String id) async {
// // // // //     try {
// // // // //       final res = await http.get(Uri.parse("$endpoint/$id"));
// // // // //       if (res.statusCode == 200) {
// // // // //         return json.decode(res.body);
// // // // //       } else {
// // // // //         if (kDebugMode) print("❌ Speaker not found: ${res.body}");
// // // // //         return null;
// // // // //       }
// // // // //     } catch (e) {
// // // // //       if (kDebugMode) print("❌ Error fetching speaker by id: $e");
// // // // //       return null;
// // // // //     }
// // // // //   }
// // // // // }
// // // //
// // // // import 'dart:convert';
// // // // import 'dart:typed_data';
// // // // import 'dart:io' show File, Platform;
// // // // import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode, Uint8List;
// // // // import 'package:http/http.dart' as http;
// // // // import 'package:shared_preferences/shared_preferences.dart';
// // // //
// // // // class MediaSpeakerController {
// // // //   final String baseUrl = "$baseUrl/mediaspeaker"; // 🔹 replace with your backend base URL
// // // //
// // // //   /// Helper to get stored organization ID
// // // //   Future<String?> _getOrganizationId() async {
// // // //     final prefs = await SharedPreferences.getInstance();
// // // //     return prefs.getString("organizationId");
// // // //   }
// // // //
// // // //   /// Helper to get stored user ID
// // // //   Future<String?> _getUserId() async {
// // // //     final prefs = await SharedPreferences.getInstance();
// // // //     return prefs.getString("userId");
// // // //   }
// // // //
// // // //   /// 🧩 CREATE SPEAKER
// // // //   Future<bool> createSpeaker({
// // // //     required String name,
// // // //     required String designation,
// // // //     String? bio,
// // // //     File? imageFile,          // for mobile
// // // //     Uint8List? imageBytes,    // for web
// // // //   }) async {
// // // //     try {
// // // //       final orgId = await _getOrganizationId();
// // // //       final createdBy = await _getUserId();
// // // //
// // // //       if (orgId == null || createdBy == null) {
// // // //         throw Exception("Missing organization or user ID");
// // // //       }
// // // //
// // // //       var request = http.MultipartRequest('POST', Uri.parse("$baseUrl/create"));
// // // //
// // // //       // Text fields
// // // //       request.fields.addAll({
// // // //         'name': name,
// // // //         'designation': designation,
// // // //         'bio': bio ?? '',
// // // //         'organization': orgId,
// // // //         'createdBy': createdBy,
// // // //       });
// // // //
// // // //       // ✅ Attach image properly
// // // //       if (kIsWeb && imageBytes != null) {
// // // //         request.files.add(http.MultipartFile.fromBytes(
// // // //           'image', // must match backend field name
// // // //           imageBytes,
// // // //           filename: 'speaker.png',
// // // //         ));
// // // //       } else if (!kIsWeb && imageFile != null) {
// // // //         request.files.add(await http.MultipartFile.fromPath(
// // // //           'image', // must match backend field name
// // // //           imageFile.path,
// // // //         ));
// // // //       }
// // // //
// // // //       if (kDebugMode) {
// // // //         print("📸 Sending image: web=${kIsWeb ? imageBytes != null : imageFile != null}");
// // // //       }
// // // //
// // // //       final response = await request.send();
// // // //       final responseBody = await response.stream.bytesToString();
// // // //
// // // //       if (response.statusCode == 201 || response.statusCode == 200) {
// // // //         if (kDebugMode) print("✅ Speaker created successfully: $responseBody");
// // // //         return true;
// // // //       } else {
// // // //         if (kDebugMode) print("❌ Create failed: $responseBody");
// // // //         return false;
// // // //       }
// // // //     } catch (e) {
// // // //       if (kDebugMode) print("❌ Error creating speaker: $e");
// // // //       return false;
// // // //     }
// // // //   }
// // // //
// // // //   /// 🧩 UPDATE SPEAKER
// // // //   Future<bool> updateSpeaker({
// // // //     required String id,
// // // //     required String name,
// // // //     required String designation,
// // // //     String? bio,
// // // //     File? imageFile,          // for mobile
// // // //     Uint8List? imageBytes,    // for web
// // // //   }) async {
// // // //     try {
// // // //       var request = http.MultipartRequest('PUT', Uri.parse("$baseUrl/update/$id"));
// // // //
// // // //       // Add fields
// // // //       request.fields.addAll({
// // // //         'name': name,
// // // //         'designation': designation,
// // // //         'bio': bio ?? '',
// // // //       });
// // // //
// // // //       // ✅ Handle image correctly
// // // //       if (kIsWeb && imageBytes != null) {
// // // //         request.files.add(http.MultipartFile.fromBytes(
// // // //           'image',
// // // //           imageBytes,
// // // //           filename: 'speaker.png',
// // // //         ));
// // // //       } else if (!kIsWeb && imageFile != null) {
// // // //         request.files.add(await http.MultipartFile.fromPath(
// // // //           'image',
// // // //           imageFile.path,
// // // //         ));
// // // //       }
// // // //
// // // //       final response = await request.send();
// // // //       final responseBody = await response.stream.bytesToString();
// // // //
// // // //       if (response.statusCode == 200) {
// // // //         if (kDebugMode) print("✅ Speaker updated successfully: $responseBody");
// // // //         return true;
// // // //       } else {
// // // //         if (kDebugMode) print("❌ Update failed: $responseBody");
// // // //         return false;
// // // //       }
// // // //     } catch (e) {
// // // //       if (kDebugMode) print("❌ Error updating speaker: $e");
// // // //       return false;
// // // //     }
// // // //   }
// // // //
// // // //   /// 🧩 GET ALL SPEAKERS
// // // //   Future<List<dynamic>> getAllSpeakers() async {
// // // //     try {
// // // //       final orgId = await _getOrganizationId();
// // // //       if (orgId == null) throw Exception("Missing organization ID");
// // // //
// // // //       final response = await http.get(Uri.parse("$baseUrl/all/$orgId"));
// // // //
// // // //       if (response.statusCode == 200) {
// // // //         final data = json.decode(response.body);
// // // //         return data['speakers'] ?? [];
// // // //       } else {
// // // //         throw Exception("Failed to load speakers");
// // // //       }
// // // //     } catch (e) {
// // // //       if (kDebugMode) print("❌ Error fetching speakers: $e");
// // // //       return [];
// // // //     }
// // // //   }
// // // //
// // // //   /// 🧩 DELETE SPEAKER
// // // //   Future<bool> deleteSpeaker(String id) async {
// // // //     try {
// // // //       final response = await http.delete(Uri.parse("$baseUrl/delete/$id"));
// // // //
// // // //       if (response.statusCode == 200) {
// // // //         if (kDebugMode) print("✅ Speaker deleted successfully");
// // // //         return true;
// // // //       } else {
// // // //         if (kDebugMode) print("❌ Delete failed: ${response.body}");
// // // //         return false;
// // // //       }
// // // //     } catch (e) {
// // // //       if (kDebugMode) print("❌ Error deleting speaker: $e");
// // // //       return false;
// // // //     }
// // // //   }
// // // // }
// // //
// // //
// // // import 'dart:convert';
// // // import 'dart:typed_data';
// // // import 'dart:io' show File;
// // // import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode, Uint8List;
// // // import 'package:http/http.dart' as http;
// // // import 'package:shared_preferences/shared_preferences.dart';
// // // import '../environmental variables.dart'; // ✅ make sure this defines: const String baseUrl = "https://your-api-url.com/api";
// // //
// // // class MediaSpeakerController {
// // //   // ✅ Correct endpoint
// // //   final String endpoint = "$baseUrl/api/mediaspeaker";
// // //
// // //   /// 🔹 Get stored organization ID
// // //   Future<String?> _getOrganizationId() async {
// // //     final prefs = await SharedPreferences.getInstance();
// // //     return prefs.getString("organizationId");
// // //   }
// // //
// // //   /// 🔹 Get stored user ID
// // //   Future<String?> _getUserId() async {
// // //     final prefs = await SharedPreferences.getInstance();
// // //     return prefs.getString("userId");
// // //   }
// // //
// // //   // -------------------------------------------------------------------------
// // //   // 🧩 CREATE SPEAKER
// // //   // -------------------------------------------------------------------------
// // //   Future<bool> createSpeaker({
// // //     required String name,
// // //     required String designation,
// // //     String? bio,
// // //     File? imageFile,          // for mobile
// // //     Uint8List? imageBytes,    // for web
// // //   }) async {
// // //     try {
// // //       final orgId = await _getOrganizationId();
// // //       final createdBy = await _getUserId();
// // //
// // //       if (orgId == null || createdBy == null) {
// // //         throw Exception("Missing organization or user ID");
// // //       }
// // //
// // //       final request = http.MultipartRequest('POST', Uri.parse("$endpoint"));
// // //
// // //       request.fields.addAll({
// // //         'name': name,
// // //         'designation': designation,
// // //         'bio': bio ?? '',
// // //         'organization': orgId,
// // //         'createdBy': createdBy,
// // //       });
// // //
// // //       // ✅ Handle image
// // //       if (kIsWeb && imageBytes != null) {
// // //         request.files.add(http.MultipartFile.fromBytes(
// // //           'image',
// // //           imageBytes,
// // //           filename: 'speaker.png',
// // //         ));
// // //       } else if (!kIsWeb && imageFile != null) {
// // //         request.files.add(await http.MultipartFile.fromPath(
// // //           'image',
// // //           imageFile.path,
// // //         ));
// // //       }
// // //
// // //       final response = await request.send();
// // //       final responseBody = await response.stream.bytesToString();
// // //
// // //       if (response.statusCode == 201 || response.statusCode == 200) {
// // //         if (kDebugMode) print("✅ Speaker created successfully: $responseBody");
// // //         return true;
// // //       } else {
// // //         if (kDebugMode) print("❌ Create failed: $responseBody");
// // //         return false;
// // //       }
// // //     } catch (e) {
// // //       if (kDebugMode) print("❌ Error creating speaker: $e");
// // //       return false;
// // //     }
// // //   }
// // //
// // //   // -------------------------------------------------------------------------
// // //   // 🧩 UPDATE SPEAKER
// // //   // -------------------------------------------------------------------------
// // //   Future<bool> updateSpeaker({
// // //     required String id,
// // //     required String name,
// // //     required String designation,
// // //     String? bio,
// // //     File? imageFile,
// // //     Uint8List? imageBytes,
// // //   }) async {
// // //     try {
// // //       final request = http.MultipartRequest('PUT', Uri.parse("$endpoint/$id"));
// // //
// // //       request.fields.addAll({
// // //         'name': name,
// // //         'designation': designation,
// // //         'bio': bio ?? '',
// // //       });
// // //
// // //       // ✅ Handle image
// // //       if (kIsWeb && imageBytes != null) {
// // //         request.files.add(http.MultipartFile.fromBytes(
// // //           'image',
// // //           imageBytes,
// // //           filename: 'speaker.png',
// // //         ));
// // //       } else if (!kIsWeb && imageFile != null) {
// // //         request.files.add(await http.MultipartFile.fromPath(
// // //           'image',
// // //           imageFile.path,
// // //         ));
// // //       }
// // //
// // //       final response = await request.send();
// // //       final responseBody = await response.stream.bytesToString();
// // //
// // //       if (response.statusCode == 200) {
// // //         if (kDebugMode) print("✅ Speaker updated successfully: $responseBody");
// // //         return true;
// // //       } else {
// // //         if (kDebugMode) print("❌ Update failed: $responseBody");
// // //         return false;
// // //       }
// // //     } catch (e) {
// // //       if (kDebugMode) print("❌ Error updating speaker: $e");
// // //       return false;
// // //     }
// // //   }
// // //
// // //   // -------------------------------------------------------------------------
// // //   // 🧩 GET ALL SPEAKERS
// // //   // -------------------------------------------------------------------------
// // //   Future<List<dynamic>> getAllSpeakers() async {
// // //     try {
// // //       final orgId = await _getOrganizationId();
// // //       if (orgId == null) throw Exception("Missing organization ID");
// // //
// // //       final response = await http.get(Uri.parse("$endpoint"));
// // //
// // //       if (response.statusCode == 200) {
// // //         final data = json.decode(response.body);
// // //         return data['speakers'] ?? [];
// // //       } else {
// // //         throw Exception("Failed to load speakers");
// // //       }
// // //     } catch (e) {
// // //       if (kDebugMode) print("❌ Error fetching speakers: $e");
// // //       return [];
// // //     }
// // //   }
// // //
// // //   // -------------------------------------------------------------------------
// // //   // 🧩 GET ALL SPEAKERS
// // //   // -------------------------------------------------------------------------
// // //   Future<List<dynamic>> getlSpeakersbyid() async {
// // //     try {
// // //       final orgId = await _getOrganizationId();
// // //       if (orgId == null) throw Exception("Missing organization ID");
// // //
// // //       final response = await http.get(Uri.parse("$endpoint/$orgId"));
// // //
// // //       if (response.statusCode == 200) {
// // //         final data = json.decode(response.body);
// // //         return data['speakers'] ?? [];
// // //       } else {
// // //         throw Exception("Failed to load speakers");
// // //       }
// // //     } catch (e) {
// // //       if (kDebugMode) print("❌ Error fetching speakers: $e");
// // //       return [];
// // //     }
// // //   }
// // //
// // //   // -------------------------------------------------------------------------
// // //   // 🧩 DELETE SPEAKER
// // //   // -------------------------------------------------------------------------
// // //   Future<bool> deleteSpeaker(String id) async {
// // //     try {
// // //       final response = await http.delete(Uri.parse("$endpoint/$id"));
// // //
// // //       if (response.statusCode == 200) {
// // //         if (kDebugMode) print("✅ Speaker deleted successfully");
// // //         return true;
// // //       } else {
// // //         if (kDebugMode) print("❌ Delete failed: ${response.body}");
// // //         return false;
// // //       }
// // //     } catch (e) {
// // //       if (kDebugMode) print("❌ Error deleting speaker: $e");
// // //       return false;
// // //     }
// // //   }
// // // }
// //
// //
// //
// // import 'dart:convert';
// // import 'dart:typed_data';
// // import 'dart:io' show File;
// // import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode, Uint8List;
// // import 'package:http/http.dart' as http;
// // import 'package:shared_preferences/shared_preferences.dart';
// // import '../environmental variables.dart'; // Make sure: const String baseUrl = "https://your-api-url.com";
// //
// // class MediaSpeakerController {
// //   // ✅ Correct endpoint
// //   final String endpoint = "$baseUrl/api/mediaspeaker";
// //
// //   /// 🔹 Get stored organization ID
// //   Future<String?> _getOrganizationId() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     return prefs.getString("organizationId");
// //   }
// //
// //   /// 🔹 Get stored user ID
// //   Future<String?> _getUserId() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     return prefs.getString("userId");
// //   }
// //
// //   // -------------------------------------------------------------------------
// //   // 🧩 CREATE SPEAKER
// //   // -------------------------------------------------------------------------
// //   Future<bool> createSpeaker({
// //     required String name,
// //     required String designation,
// //     String? bio,
// //     File? imageFile,          // for mobile
// //     Uint8List? imageBytes,    // for web
// //   }) async {
// //     try {
// //       final orgId = await _getOrganizationId();
// //       final createdBy = await _getUserId();
// //
// //       if (orgId == null || createdBy == null) {
// //         throw Exception("Missing organization or user ID");
// //       }
// //
// //       final request = http.MultipartRequest('POST', Uri.parse(endpoint));
// //
// //       request.fields.addAll({
// //         'name': name,
// //         'designation': designation,
// //         'bio': bio ?? '',
// //         'organization': orgId,
// //         'createdBy': createdBy,
// //       });
// //
// //       // ✅ Handle image
// //       if (kIsWeb && imageBytes != null) {
// //         request.files.add(http.MultipartFile.fromBytes(
// //           'image',
// //           imageBytes,
// //           filename: 'speaker.png',
// //         ));
// //       } else if (!kIsWeb && imageFile != null) {
// //         request.files.add(await http.MultipartFile.fromPath(
// //           'image',
// //           imageFile.path,
// //         ));
// //       }
// //
// //       final response = await request.send();
// //       final responseBody = await response.stream.bytesToString();
// //
// //       if (response.statusCode == 201 || response.statusCode == 200) {
// //         if (kDebugMode) print("✅ Speaker created successfully: $responseBody");
// //         return true;
// //       } else {
// //         if (kDebugMode) print("❌ Create failed: $responseBody");
// //         return false;
// //       }
// //     } catch (e) {
// //       if (kDebugMode) print("❌ Error creating speaker: $e");
// //       return false;
// //     }
// //   }
// //
// //   // -------------------------------------------------------------------------
// //   // 🧩 UPDATE SPEAKER
// //   // -------------------------------------------------------------------------
// //   Future<bool> updateSpeaker({
// //     required String id,
// //     required String name,
// //     required String designation,
// //     String? bio,
// //     File? imageFile,
// //     Uint8List? imageBytes,
// //   }) async {
// //     try {
// //       final request = http.MultipartRequest('PUT', Uri.parse("$endpoint/$id"));
// //
// //       request.fields.addAll({
// //         'name': name,
// //         'designation': designation,
// //         'bio': bio ?? '',
// //       });
// //
// //       // ✅ Handle image
// //       if (kIsWeb && imageBytes != null) {
// //         request.files.add(http.MultipartFile.fromBytes(
// //           'image',
// //           imageBytes,
// //           filename: 'speaker.png',
// //         ));
// //       } else if (!kIsWeb && imageFile != null) {
// //         request.files.add(await http.MultipartFile.fromPath(
// //           'image',
// //           imageFile.path,
// //         ));
// //       }
// //
// //       final response = await request.send();
// //       final responseBody = await response.stream.bytesToString();
// //
// //       if (response.statusCode == 200) {
// //         if (kDebugMode) print("✅ Speaker updated successfully: $responseBody");
// //         return true;
// //       } else {
// //         if (kDebugMode) print("❌ Update failed: $responseBody");
// //         return false;
// //       }
// //     } catch (e) {
// //       if (kDebugMode) print("❌ Error updating speaker: $e");
// //       return false;
// //     }
// //   }
// //
// //   // -------------------------------------------------------------------------
// //   // 🧩 GET ALL SPEAKERS
// //   // -------------------------------------------------------------------------
// //   Future<List<dynamic>> getAllSpeakers() async {
// //     try {
// //       final response = await http.get(Uri.parse(endpoint));
// //
// //       if (response.statusCode == 200) {
// //         final data = json.decode(response.body);
// //         // ✅ if backend returns a list, return directly
// //         if (data is List) return data;
// //         // otherwise, if wrapped in object
// //         return data['speakers'] ?? [];
// //       } else {
// //         throw Exception("Failed to load speakers");
// //       }
// //     } catch (e) {
// //       if (kDebugMode) print("❌ Error fetching speakers: $e");
// //       return [];
// //     }
// //   }
// //
// //   // -------------------------------------------------------------------------
// //   // 🧩 GET SPEAKERS BY ORG ID
// //   // -------------------------------------------------------------------------
// //   Future<List<dynamic>> getSpeakersByOrganization() async {
// //     try {
// //       final orgId = await _getOrganizationId();
// //       if (orgId == null) throw Exception("Missing organization ID");
// //
// //       final response = await http.get(Uri.parse("$endpoint/$orgId"));
// //
// //       if (response.statusCode == 200) {
// //         final data = json.decode(response.body);
// //         if (data is List) return data;
// //         return data['speakers'] ?? [];
// //       } else {
// //         throw Exception("Failed to load speakers by org");
// //       }
// //     } catch (e) {
// //       if (kDebugMode) print("❌ Error fetching speakers by org: $e");
// //       return [];
// //     }
// //   }
// //
// //   // -------------------------------------------------------------------------
// //   // 🧩 DELETE SPEAKER
// //   // -------------------------------------------------------------------------
// //   Future<bool> deleteSpeaker(String id) async {
// //     try {
// //       final response = await http.delete(Uri.parse("$endpoint/$id"));
// //
// //       if (response.statusCode == 200) {
// //         if (kDebugMode) print("✅ Speaker deleted successfully");
// //         return true;
// //       } else {
// //         if (kDebugMode) print("❌ Delete failed: ${response.body}");
// //         return false;
// //       }
// //     } catch (e) {
// //       if (kDebugMode) print("❌ Error deleting speaker: $e");
// //       return false;
// //     }
// //   }
// // }
//
//
// import 'dart:convert';
// import 'dart:typed_data';
// import 'dart:io' show File;
// import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode, Uint8List;
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import '../environmental variables.dart'; // must export: const String baseUrl = "https://your-api-url.com";
//
// class MediaSpeakerController {
//   // ✅ Centralized API endpoint
//   final String endpoint = "$baseUrl/api/mediaspeaker";
//
//   /// 🔹 Get stored organization ID
//   Future<String?> _getOrganizationId() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString("organizationId");
//   }
//
//   /// 🔹 Get stored user ID
//   Future<String?> _getUserId() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString("userId");
//   }
//
//   // -------------------------------------------------------------------------
//   // 🧩 CREATE SPEAKER
//   // -------------------------------------------------------------------------
//   Future<bool> createSpeaker({
//     required String name,
//     required String designation,
//     String? bio,
//     File? imageFile,
//     Uint8List? imageBytes,
//   }) async {
//     try {
//       final orgId = await _getOrganizationId();
//       final createdBy = await _getUserId();
//
//       if (orgId == null || createdBy == null) {
//         throw Exception("Missing organization or user ID");
//       }
//
//       final request = http.MultipartRequest('POST', Uri.parse(endpoint));
//
//       request.fields.addAll({
//         'name': name.trim(),
//         'designation': designation.trim(),
//         'bio': bio?.trim() ?? '',
//         'organization': orgId,
//         'createdBy': createdBy,
//       });
//
//       // ✅ Handle image (works for both web & mobile)
//       if (kIsWeb && imageBytes != null) {
//         request.files.add(http.MultipartFile.fromBytes(
//           'image',
//           imageBytes,
//           filename: 'speaker.png',
//         ));
//       } else if (!kIsWeb && imageFile != null) {
//         request.files.add(await http.MultipartFile.fromPath(
//           'image',
//           imageFile.path,
//         ));
//       }
//
//       if (kDebugMode) {
//         print("📤 Creating Speaker → Fields: ${request.fields}");
//       }
//
//       final response = await request.send();
//       final responseBody = await response.stream.bytesToString();
//
//       if (response.statusCode == 201 || response.statusCode == 200) {
//         if (kDebugMode) print("✅ Speaker created successfully: $responseBody");
//         return true;
//       } else {
//         if (kDebugMode) print("❌ Speaker creation failed: $responseBody");
//         return false;
//       }
//     } catch (e) {
//       if (kDebugMode) print("❌ Error creating speaker: $e");
//       return false;
//     }
//   }
//
//   // -------------------------------------------------------------------------
//   // 🧩 UPDATE SPEAKER
//   // -------------------------------------------------------------------------
//   Future<bool> updateSpeaker({
//     required String id,
//     required String name,
//     required String designation,
//     String? bio,
//     File? imageFile,
//     Uint8List? imageBytes,
//   }) async {
//     try {
//       final request = http.MultipartRequest('PUT', Uri.parse("$endpoint/$id"));
//
//       request.fields.addAll({
//         'name': name.trim(),
//         'designation': designation.trim(),
//         'bio': bio?.trim() ?? '',
//       });
//
//       if (kIsWeb && imageBytes != null) {
//         request.files.add(http.MultipartFile.fromBytes(
//           'image',
//           imageBytes,
//           filename: 'speaker.png',
//         ));
//       } else if (!kIsWeb && imageFile != null) {
//         request.files.add(await http.MultipartFile.fromPath(
//           'image',
//           imageFile.path,
//         ));
//       }
//
//       final response = await request.send();
//       final responseBody = await response.stream.bytesToString();
//
//       if (response.statusCode == 200) {
//         if (kDebugMode) print("✅ Speaker updated successfully: $responseBody");
//         return true;
//       } else {
//         if (kDebugMode) print("❌ Update failed: $responseBody");
//         return false;
//       }
//     } catch (e) {
//       if (kDebugMode) print("❌ Error updating speaker: $e");
//       return false;
//     }
//   }
//
//   // -------------------------------------------------------------------------
//   // 🧩 GET ALL SPEAKERS (Optionally filtered by org/user)
//   // -------------------------------------------------------------------------
//   Future<List<dynamic>> getAllSpeakers({String? organization, String? createdBy}) async {
//     try {
//       final queryParams = <String, String>{};
//       if (organization != null) queryParams['organization'] = organization;
//       if (createdBy != null) queryParams['createdBy'] = createdBy;
//
//       final uri = Uri.parse(endpoint).replace(queryParameters: queryParams.isNotEmpty ? queryParams : null);
//       final response = await http.get(uri);
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data is List) return data; // backend returns array directly
//         return data['speakers'] ?? [];
//       } else {
//         throw Exception("Failed to load speakers");
//       }
//     } catch (e) {
//       if (kDebugMode) print("❌ Error fetching speakers: $e");
//       return [];
//     }
//   }
//
//   // -------------------------------------------------------------------------
//   // 🧩 GET SPEAKER BY ID
//   // -------------------------------------------------------------------------
//   Future<Map<String, dynamic>?> getSpeakerById(String id) async {
//     try {
//       final response = await http.get(Uri.parse("$endpoint/$id"));
//
//       if (response.statusCode == 200) {
//         return json.decode(response.body);
//       } else {
//         if (kDebugMode) print("❌ Speaker not found: ${response.body}");
//         return null;
//       }
//     } catch (e) {
//       if (kDebugMode) print("❌ Error fetching speaker by ID: $e");
//       return null;
//     }
//   }
//
//   // -------------------------------------------------------------------------
//   // 🧩 DELETE SPEAKER
//   // -------------------------------------------------------------------------
//   Future<bool> deleteSpeaker(String id) async {
//     try {
//       final response = await http.delete(Uri.parse("$endpoint/$id"));
//
//       if (response.statusCode == 200) {
//         if (kDebugMode) print("✅ Speaker deleted successfully");
//         return true;
//       } else {
//         if (kDebugMode) print("❌ Delete failed: ${response.body}");
//         return false;
//       }
//     } catch (e) {
//       if (kDebugMode) print("❌ Error deleting speaker: $e");
//       return false;
//     }
//   }
// }


import 'dart:convert';
import 'dart:typed_data';
import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode, Uint8List;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../environmental variables.dart'; // must export: const String baseUrl = "https://your-api-url.com";

class MediaSpeakerController {
  // ✅ Centralized API endpoint
  final String endpoint = "$baseUrl/api/mediaspeaker";

  /// 🔹 Get stored organization ID
  Future<String?> _getOrganizationId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("organizationId");
  }

  /// 🔹 Get stored user ID
  Future<String?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("userId");
  }

  // -------------------------------------------------------------------------
  // 🧩 CREATE SPEAKER
  // -------------------------------------------------------------------------
  Future<bool> createSpeaker({
    required String name,
    required String designation,
    String? bio,
    File? imageFile,
    Uint8List? imageBytes,
  }) async {
    try {
      final orgId = await _getOrganizationId();
      final createdBy = await _getUserId();

      if (orgId == null || createdBy == null) {
        throw Exception("Missing organization or user ID");
      }

      final request = http.MultipartRequest('POST', Uri.parse(endpoint));

      request.fields.addAll({
        'name': name.trim(),
        'designation': designation.trim(),
        'bio': bio?.trim() ?? '',
        'organization': orgId,
        'createdBy': createdBy,
      });

      // ✅ Handle image (works for both web & mobile)
      if (kIsWeb && imageBytes != null) {
        request.files.add(http.MultipartFile.fromBytes(
          'image',
          imageBytes,
          filename: 'speaker.png',
        ));
      } else if (!kIsWeb && imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
        ));
      }

      if (kDebugMode) {
        print("📤 Creating Speaker → Fields: ${request.fields}");
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 201 || response.statusCode == 200) {
        if (kDebugMode) print("✅ Speaker created successfully: $responseBody");
        return true;
      } else {
        if (kDebugMode) print("❌ Speaker creation failed: $responseBody");
        return false;
      }
    } catch (e) {
      if (kDebugMode) print("❌ Error creating speaker: $e");
      return false;
    }
  }

  // -------------------------------------------------------------------------
  // 🧩 UPDATE SPEAKER
  // -------------------------------------------------------------------------
  Future<bool> updateSpeaker({
    required String id,
    required String name,
    required String designation,
    String? bio,
    File? imageFile,
    Uint8List? imageBytes,
  }) async {
    try {
      final request = http.MultipartRequest('PUT', Uri.parse("$endpoint/$id"));

      request.fields.addAll({
        'name': name.trim(),
        'designation': designation.trim(),
        'bio': bio?.trim() ?? '',
      });

      if (kIsWeb && imageBytes != null) {
        request.files.add(http.MultipartFile.fromBytes(
          'image',
          imageBytes,
          filename: 'speaker.png',
        ));
      } else if (!kIsWeb && imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
        ));
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        if (kDebugMode) print("✅ Speaker updated successfully: $responseBody");
        return true;
      } else {
        if (kDebugMode) print("❌ Update failed: $responseBody");
        return false;
      }
    } catch (e) {
      if (kDebugMode) print("❌ Error updating speaker: $e");
      return false;
    }
  }

  // -------------------------------------------------------------------------
  // 🧩 GET ALL SPEAKERS (Optionally filtered by org/user)
  // -------------------------------------------------------------------------
  Future<List<dynamic>> getAllSpeakers({String? organization, String? createdBy}) async {
    try {
      final queryParams = <String, String>{};
      if (organization != null) queryParams['organization'] = organization;
      if (createdBy != null) queryParams['createdBy'] = createdBy;

      final uri = Uri.parse(endpoint).replace(queryParameters: queryParams.isNotEmpty ? queryParams : null);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) return data; // backend returns array directly
        return data['speakers'] ?? [];
      } else {
        throw Exception("Failed to load speakers");
      }
    } catch (e) {
      if (kDebugMode) print("❌ Error fetching speakers: $e");
      return [];
    }
  }

  // -------------------------------------------------------------------------
  // 🧩 GET SPEAKER BY ID
  // -------------------------------------------------------------------------
  Future<Map<String, dynamic>?> getSpeakerById(String id) async {
    try {
      final response = await http.get(Uri.parse("$endpoint/$id"));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        if (kDebugMode) print("❌ Speaker not found: ${response.body}");
        return null;
      }
    } catch (e) {
      if (kDebugMode) print("❌ Error fetching speaker by ID: $e");
      return null;
    }
  }

  // -------------------------------------------------------------------------
  // 🧩 DELETE SPEAKER
  // -------------------------------------------------------------------------
  Future<bool> deleteSpeaker(String id) async {
    try {
      final response = await http.delete(Uri.parse("$endpoint/$id"));

      if (response.statusCode == 200) {
        if (kDebugMode) print("✅ Speaker deleted successfully");
        return true;
      } else {
        if (kDebugMode) print("❌ Delete failed: ${response.body}");
        return false;
      }
    } catch (e) {
      if (kDebugMode) print("❌ Error deleting speaker: $e");
      return false;
    }
  }
}
