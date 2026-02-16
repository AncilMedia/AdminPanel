import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../environmental variables.dart';

enum HomeLayout { column, row, stacked }

class HomeLayoutController {

  static Future<HomeLayout> fetchLayout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final orgId = prefs.getString("organizationId");

      if (orgId == null) return HomeLayout.column;

      final response = await http.get(
        Uri.parse('$baseUrl/api/homelayout/$orgId'),
      );

      if (response.statusCode != 200) return HomeLayout.column;
      if (!response.body.startsWith('{')) return HomeLayout.column;

      final data = json.decode(response.body);
      final layout = data['layout'];

      switch (layout) {
        case 'row':
          return HomeLayout.row;
        case 'stacked':
          return HomeLayout.stacked;
        default:
          return HomeLayout.column;
      }

    } catch (e) {
      return HomeLayout.column;
    }
  }

  static Future<void> updateLayout(String layout) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final orgId = prefs.getString("organizationId");

      if (orgId == null) return;

      await http.put(
        Uri.parse('$baseUrl/api/homelayout/$orgId'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"layout": layout}),
      );
    } catch (_) {}
  }
}
