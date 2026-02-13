import 'dart:convert';
import 'package:ancilmediaadminpanel/environmental%20variables.dart';
import 'package:http/http.dart' as http;

class LiveApi {
  static const String baseUrl = "http://192.168.1.37:3000";

  static Future<Map<String, dynamic>> getToken({
    required String room,
    required String identity,
    required bool isHost,
  }) async {
    final res = await http.post(
      Uri.parse('$NgrokUrl/api/live/token'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "roomName": room,
        "userId": identity,
        "isHost": isHost,
      }),
    );

    if (res.statusCode != 200) {
      throw Exception("Token fetch failed");
    }

    return jsonDecode(res.body);
  }
}
