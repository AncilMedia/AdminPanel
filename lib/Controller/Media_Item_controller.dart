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
    String source = "file",
    String? mediaUrl,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString("userId");
    final orgId = prefs.getString("organizationId");
    final roleId = prefs.getString("roleId");

    if (userId == null || orgId == null || roleId == null) {
      throw Exception("User, organization, or role not set in SharedPreferences");
    }

    // Only require file if source is 'file'
    if (source == "file" && file == null && webFile == null) {
      throw Exception("Main media file is required");
    }
    if ((source == "youtube" || source == "vimeo") && (mediaUrl == null || mediaUrl.isEmpty)) {
      throw Exception("Media URL is required for $source");
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
    request.fields["source"] = source;
    if (mediaUrl != null && source != "file") request.fields["mediaUrl"] = mediaUrl;

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