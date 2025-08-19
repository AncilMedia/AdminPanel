import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import '../environmental variables.dart';
import '../Services/api_client.dart';

class ProfileController {
  final ApiClient apiClient;

  ProfileController(this.apiClient);

  // ✅ Fetch profile
  Future<Map<String, dynamic>?> fetchProfile() async {
    final res = await apiClient.get('$baseUrl/api/settings');
    if (res.statusCode == 200) {
      final data = Map<String, dynamic>.from(await apiClient.decodeJson(res));
      print('[ℹ️] Profile data fetched: $data');
      return data;
    } else {
      print('[❌] Failed to fetch profile: ${res.statusCode} - ${res.body}');
    }
    return null;
  }

  // ✅ Update profile (with image)
  Future<void> updateProfile({
    required String username,
    required String email,
    required String phone,
    XFile? imageFile,
  }) async {
    final uri = Uri.parse('$NgrokUrl/api/settings');
    final request = http.MultipartRequest('PUT', uri);

    request.fields['username'] = username;
    request.fields['email'] = email;
    request.fields['phone'] = phone;

    if (imageFile != null) {
      final mimeType = lookupMimeType(imageFile.name) ?? 'image/jpeg';
      final mediaType = MediaType.parse(mimeType);

      if (kIsWeb) {
        // ✅ Web: must use bytes
        final bytes = await imageFile.readAsBytes();
        request.files.add(http.MultipartFile.fromBytes(
          'imageFile',
          bytes,
          filename: imageFile.name,
          contentType: mediaType,
        ));
        print('[DEBUG] Attached image (web): ${imageFile.name}');
      } else {
        // ✅ Mobile/Desktop: use path
        request.files.add(await http.MultipartFile.fromPath(
          'imageFile',
          imageFile.path,
          contentType: mediaType,
        ));
        print('[DEBUG] Attached image (mobile): ${imageFile.path}');
      }
    } else {
      print('[DEBUG] No image provided');
    }

    // Attach auth headers
    final headers = await apiClient.authHeader();
    request.headers.addAll(headers);

    // Send request
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    print('[DEBUG] Server response: ${response.statusCode} - ${response.body}');

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to update profile: ${response.body}');
    }
  }

  // ✅ Delete profile
  Future<bool> deleteProfile() async {
    final res = await apiClient.delete('$baseUrl/api/settings');
    return res.statusCode == 200;
  }
}
