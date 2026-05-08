// lib/Controller/ics_controller.dart

import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../environmental variables.dart';


class IcsController {
  // ===============================
  // BASE URL
  // ===============================

  // ===============================
  // COMMON HEADERS
  // ===============================
  static Future<Map<String, String>> _headers() async {
    final prefs = await SharedPreferences.getInstance();

    final userId = prefs.getString('user_Id');

    final token = prefs.getString('accessToken');

    return {'x-user-id': userId ?? '', 'Authorization': 'Bearer $token'};
  }

  // ===============================
  // GET ALL ICS
  // ===============================
  static Future<List<dynamic>> getAllIcs() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/ics'),

        headers: await _headers(),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }

      throw Exception('Failed to fetch ICS calendars');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ===============================
  // GET SINGLE ICS
  // ===============================
  static Future<Map<String, dynamic>> getSingleIcs(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/ics/$id'),

        headers: await _headers(),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }

      throw Exception('Failed to fetch ICS calendar');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ===============================
  // CREATE ICS FROM FILE
  // ===============================
  static Future<Map<String, dynamic>> createIcsFromFile({
    required String title,

    String description = '',

    required PlatformFile file,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final organizationId = prefs.getString('organizationId');

      if (organizationId == null) {
        throw Exception('Missing organizationId');
      }

      final uri = Uri.parse('$baseUrl/api/ics');

      final request = http.MultipartRequest('POST', uri);

      request.headers.addAll(await _headers());

      // ===============================
      // FIELDS
      // ===============================
      request.fields['title'] = title;

      request.fields['description'] = description;

      request.fields['type'] = 'file';

      request.fields['organizationId'] = organizationId;

      // ===============================
      // FILE
      // ===============================
      if (file.bytes != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'icsFile',

            file.bytes!,

            filename: file.name,
          ),
        );
      } else if (file.path != null) {
        request.files.add(
          await http.MultipartFile.fromPath('icsFile', file.path!),
        );
      }

      final streamedResponse = await request.send();

      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      }

      print(response.body);

      throw Exception('Failed to create ICS');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ===============================
  // CREATE ICS FROM URL
  // ===============================
  static Future<Map<String, dynamic>> createIcsFromUrl({
    required String title,

    required String originalUrl,

    String description = '',
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final organizationId = prefs.getString('organizationId');

      if (organizationId == null) {
        throw Exception('Missing organizationId');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/api/ics'),

        headers: {...(await _headers()), 'Content-Type': 'application/json'},

        body: jsonEncode({
          'title': title,

          'description': description,

          'type': 'url',

          'organizationId': organizationId,

          'originalUrl': originalUrl,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      }

      print(response.body);

      throw Exception('Failed to create ICS from URL');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ===============================
  // UPDATE ICS
  // ===============================
  static Future<Map<String, dynamic>> updateIcs({
    required String id,

    String? title,
    String? description,
    String? originalUrl,

    bool? isActive,

    PlatformFile? file,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/api/ics/$id');

      final request = http.MultipartRequest('PUT', uri);

      request.headers.addAll(await _headers());

      // ===============================
      // OPTIONAL FIELDS
      // ===============================
      if (title != null) {
        request.fields['title'] = title;
      }

      if (description != null) {
        request.fields['description'] = description;
      }

      if (originalUrl != null) {
        request.fields['originalUrl'] = originalUrl;
      }

      if (isActive != null) {
        request.fields['isActive'] = isActive.toString();
      }

      // ===============================
      // FILE
      // ===============================
      if (file != null) {
        if (file.bytes != null) {
          request.files.add(
            http.MultipartFile.fromBytes(
              'icsFile',

              file.bytes!,

              filename: file.name,
            ),
          );
        } else if (file.path != null) {
          request.files.add(
            await http.MultipartFile.fromPath('icsFile', file.path!),
          );
        }
      }

      final streamedResponse = await request.send();

      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }

      print(response.body);

      throw Exception('Failed to update ICS');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ===============================
  // DELETE ICS
  // ===============================
  static Future<bool> deleteIcs(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/ics/$id'),

        headers: await _headers(),
      );

      if (response.statusCode == 200) {
        return true;
      }

      print(response.body);

      throw Exception('Failed to delete ICS');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ===============================
  // PICK ICS FILE
  // ===============================
  static Future<PlatformFile?> pickIcsFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,

        allowedExtensions: ['ics'],

        withData: true,
      );

      if (result == null) {
        return null;
      }

      return result.files.first;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
