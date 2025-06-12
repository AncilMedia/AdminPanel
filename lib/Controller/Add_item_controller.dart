import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as media;
import 'dart:convert';
import '../environmental variables.dart';

class AddItemController {
  static final String apiUrl = '$baseUrl/api/item';

  static Future<String?> uploadItem({
    required String title,
    Uint8List? imageBytes,
    String? imageUrl,
  }) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.fields['title'] = title;
      request.fields['subtitle'] = '';
      request.fields['url'] = '';

      // Set headers if needed (example: ngrok)
      // request.headers.addAll({
      //   'ngrok-skip-browser-warning': 'true',
      //   'Content-Type': 'multipart/form-data',
      // });


      // If local image file provided
      if (imageBytes != null) {
        request.files.add(http.MultipartFile.fromBytes(
          'imageFile',
          imageBytes,
          filename: 'upload.jpg',
          contentType: media.MediaType('image', 'jpeg'),
        ));
      } else if (imageUrl != null && imageUrl.isNotEmpty) {
        // If image URL provided instead
        request.fields['image'] = imageUrl;
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      print('Status code: ${response.statusCode}');
      print('Response body: $responseBody');

      if (response.statusCode == 201) {
        final responseJson = json.decode(responseBody);
        return responseJson['image'] ?? imageUrl;
      } else {
        print('Failed to upload item. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading item: $e');
    }

    return null;
  }
}
