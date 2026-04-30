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

  Future<Map<String, dynamic>> updateMediaItem({
    required String id,
    String? title,
    String? description,
    DateTime? selectedDate,
    List<String>? speakers,
    List<String>? topics,
    List<String>? scriptures,
    File? file,
    PlatformFile? webFile,
  }) async {

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString("userId");
    final orgId = prefs.getString("organizationId");
    final roleId = prefs.getString("roleId");

    final uri = Uri.parse("$baseUrl/api/media/item/$id");

    /// 🚀 If NO FILE → use normal JSON PUT (fast & reliable)
    if (file == null && webFile == null) {

      final body = <String, dynamic>{};

      if (title != null && title.isNotEmpty) body["title"] = title;
      if (description != null && description.isNotEmpty) body["description"] = description;

      if (selectedDate != null) {
        body["date"] = selectedDate.toIso8601String();
      }

      if (speakers != null && speakers.isNotEmpty) {
        body["speakers"] = speakers;
      }

      if (topics != null && topics.isNotEmpty) {
        body["topics"] = topics;
      }

      if (scriptures != null && scriptures.isNotEmpty) {
        body["scriptures"] = scriptures;
      }

      body["createdBy"] = userId;
      body["organization"] = orgId;
      body["role"] = roleId;

      print("PUT JSON URL: $uri");
      print("BODY SENT: $body");

      final response = await http.put(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(body),
      );

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Update failed: ${response.body}");
      }
    }

    /// 🚀 If FILE exists → use Multipart
    var request = http.MultipartRequest("PUT", uri);

    request.headers['Accept'] = 'application/json';

    if (title != null && title.isNotEmpty) {
      request.fields["title"] = title;
    }

    if (description != null && description.isNotEmpty) {
      request.fields["description"] = description;
    }

    if (selectedDate != null) {
      request.fields["date"] = selectedDate.toIso8601String();
    }

    if (speakers != null && speakers.isNotEmpty) {
      request.fields["speakers"] = jsonEncode(speakers);
    }

    if (topics != null && topics.isNotEmpty) {
      request.fields["topics"] = jsonEncode(topics);
    }

    if (scriptures != null && scriptures.isNotEmpty) {
      request.fields["scriptures"] = jsonEncode(scriptures);
    }

    request.fields["createdBy"] = userId ?? "";
    request.fields["organization"] = orgId ?? "";
    request.fields["role"] = roleId ?? "";

    /// FILE UPLOAD
    if (kIsWeb && webFile != null && webFile.bytes != null) {

      final mimeType = lookupMimeType(webFile.name) ?? 'application/octet-stream';

      request.files.add(
        http.MultipartFile.fromBytes(
          "file",
          webFile.bytes!,
          filename: webFile.name,
          contentType: MediaType.parse(mimeType),
        ),
      );

    } else if (!kIsWeb && file != null) {

      final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';

      request.files.add(
        await http.MultipartFile.fromPath(
          "file",
          file.path,
          contentType: MediaType.parse(mimeType),
        ),
      );
    }

    print("PUT MULTIPART URL: $uri");
    print("FIELDS SENT: ${request.fields}");
    print("FILES SENT: ${request.files.map((e) => e.filename).toList()}");

    final response = await request.send();
    final resBody = await response.stream.bytesToString();

    print("STATUS: ${response.statusCode}");
    print("BODY: $resBody");

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(resBody);
    } else {
      throw Exception("Update failed: $resBody");
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

  Future<void> deleteMediaItem(String id) async {
    try {
      final response = await http.delete(
        Uri.parse("$baseUrl/api/media/item/$id"),
      );

      if (response.statusCode == 200) {
        print("✅ Media item deleted successfully: $id");
        print("Response: ${response.body}");
      } else {
        print("❌ Delete failed");
        print("Status Code: ${response.statusCode}");
        print("Response: ${response.body}");
        throw Exception("Delete failed: ${response.body}");
      }
    } catch (e) {
      print("🚨 Error deleting media item: $e");
      rethrow;
    }
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

  Future<void> addSpeakerComplex({
    required String name,
    required String designation,
    String? bio,
    dynamic image, // For Mobile (File)
    Uint8List? webImageBytes, // For Web
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final orgId = prefs.getString("organizationId");
    final userId = prefs.getString("userId");

    final uri = Uri.parse("$baseUrl/api/mediaspeaker");
    final request = http.MultipartRequest("POST", uri);

    // Standard Fields
    request.fields['name'] = name;
    request.fields['designation'] = designation;
    request.fields['bio'] = bio ?? "";
    request.fields['organization'] = orgId ?? "";
    request.fields['createdBy'] = userId ?? "";

    // Handle Image Attachment based on Platform
    if (kIsWeb && webImageBytes != null) {
      // ✅ Web Logic: Use bytes
      request.files.add(http.MultipartFile.fromBytes(
        'image',
        webImageBytes,
        filename: 'speaker_${DateTime.now().millisecondsSinceEpoch}.jpg',
        contentType: MediaType('image', 'jpeg'),
      ));
    } else if (!kIsWeb && image != null) {
      // ✅ Mobile Logic: Use file path
      final mimeType = lookupMimeType(image.path) ?? 'image/jpeg';
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        image.path,
        contentType: MediaType.parse(mimeType),
      ));
    }

    final response = await request.send();
    final respBody = await response.stream.bytesToString();

    if (response.statusCode == 201 || response.statusCode == 200) {
      print("✅ Speaker Created: $respBody");
    } else {
      print("❌ Server Error: $respBody");
      throw Exception("Failed to create speaker profile: $respBody");
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

  Future<void> addTopicComplex({
    required String name,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final orgId = prefs.getString("organizationId");
    final userId = prefs.getString("userId");
    final roleId = prefs.getString("roleId");

    final uri = Uri.parse("$baseUrl/api/mediatopic"); // Check your app.js mount point

    // Since Topic doesn't have files, a standard JSON POST is fine
    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "organization": orgId,
        "createdBy": userId,
        "role": roleId,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      print("✅ Topic Created: ${response.body}");
    } else {
      print("❌ Topic Creation Error: ${response.body}");
      throw Exception("Failed to create topic: ${response.body}");
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