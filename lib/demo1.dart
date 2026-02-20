import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:file_picker/file_picker.dart';

import 'environmental variables.dart';

class CloudinaryService {
  static  String cloudName = "$CLOUDINARYCLOUDNAME";
  static  String uploadPreset = "$CLOUDINARYPRESET";

  static Future<String> uploadFile1({
    File? file,
    PlatformFile? webFile,
    bool isVideo = false,
  }) async {
    final url = Uri.parse(
      "https://api.cloudinary.com/v1_1/$cloudName/${isVideo ? 'video' : 'image'}/upload",
    );

    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = uploadPreset;

    if (webFile != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          webFile.bytes!,
          filename: webFile.name,
          contentType: lookupMimeType(webFile.name) != null
              ? http.MediaType.parse(lookupMimeType(webFile.name)!)
              : null,
        ),
      );
    } else if (file != null) {
      request.files.add(
        await http.MultipartFile.fromPath('file', file.path),
      );
    }

    final response = await request.send();
    final resBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      return json.decode(resBody)['secure_url'];
    } else {
      throw Exception("Cloudinary upload failed: $resBody");
    }
  }
}
