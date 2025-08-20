import 'dart:convert';
import 'package:http/http.dart' as http;
import 'environmental variables.dart';

Future<String?> fetchNgrokUrl() async {
  try {
    final response = await http.get(Uri.parse(NgrokConfigGist));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['api']['settings']['ngrokUrl'];
    } else {
      print('Failed to fetch Ngrok URL: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching Ngrok URL: $e');
  }
  return null;
}
