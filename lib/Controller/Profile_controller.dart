import 'dart:typed_data';
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
      print('[ℹ️] Profile data fetched: $data'); // 🔍 print to console
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
    final uri = Uri.parse('$baseUrl/api/settings');
    final request = http.MultipartRequest('PUT', uri);

    request.fields['username'] = username;
    request.fields['email'] = email;
    request.fields['phone'] = phone;

    if (imageFile != null) {
      final imageBytes = await imageFile.readAsBytes();
      final mimeType = lookupMimeType(imageFile.name, headerBytes: imageBytes) ?? 'image/jpeg';
      final mediaType = MediaType.parse(mimeType);

      request.files.add(http.MultipartFile.fromBytes(
        'imageFile',
        imageBytes,
        filename: imageFile.name,
        contentType: mediaType,
      ));
    }

    final headers = await apiClient.authHeader(); // include tokens
    request.headers.addAll(headers);

    final response = await request.send();
    final responseBody = await http.Response.fromStream(response);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to update profile: ${responseBody.body}');
    }
  }

  // ✅ Delete profile
  Future<bool> deleteProfile() async {
    final res = await apiClient.delete('$baseUrl/api/settings');
    return res.statusCode == 200;
  }
}
