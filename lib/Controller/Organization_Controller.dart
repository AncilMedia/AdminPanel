// // // import 'dart:convert';
// // // import 'package:http/http.dart' as http;
// // // import 'package:shared_preferences/shared_preferences.dart';
// // // import '../environmental variables.dart';
// // //
// // // class OrganizationService {
// // //   static String _baseUrl = '$baseUrl/api/organizations';
// // //
// // //   // ✅ Create Organization
// // //   static Future<String> createOrganization(String name) async {
// // //     final prefs = await SharedPreferences.getInstance();
// // //     final token = prefs.getString('accessToken');
// // //
// // //     if (token == null) throw Exception("No access token");
// // //
// // //     final response = await http.post(
// // //       Uri.parse(_baseUrl),
// // //       headers: {
// // //         'Authorization': 'Bearer $token',
// // //         'Content-Type': 'application/json',
// // //       },
// // //       body: json.encode({'name': name}),
// // //     );
// // //
// // //     if (response.statusCode == 201) {
// // //       final data = json.decode(response.body);
// // //       final orgId = data['_id'] ?? data['id'];
// // //       await prefs.setString('organizationId', orgId);
// // //       return orgId;
// // //     } else {
// // //       throw Exception('Failed to create organization: ${response.body}');
// // //     }
// // //   }
// // //
// //   // ✅ Get Organization by ID
// //   static Future<Map<String, dynamic>> getOrganization(String id) async {
// //     final prefs = await SharedPreferences.getInstance();
// //     final token = prefs.getString('accessToken');
// //
// //     final response = await http.get(
// //       Uri.parse('$_baseUrl/$id'),
// //       headers: {'Authorization': 'Bearer $token'},
// //     );
// //
// //     if (response.statusCode == 200) {
// //       return json.decode(response.body);
// //     } else {
// //       throw Exception('Failed to fetch organization: ${response.body}');
// //     }
// //   }
// // //
// // //   // ✅ Get Organization by Name
// // //   static Future<String?> getOrganizationByName(String name) async {
// // //     final prefs = await SharedPreferences.getInstance();
// // //     final token = prefs.getString('accessToken');
// // //
// // //     if (token == null) throw Exception("No access token");
// // //
// // //     final response = await http.get(
// // //       Uri.parse('$_baseUrl/by-name/$name'),
// // //       headers: {'Authorization': 'Bearer $token'},
// // //     );
// // //
// // //     if (response.statusCode == 200) {
// // //       final data = json.decode(response.body);
// // //       final orgId = data['_id'] ?? data['id'];
// // //       await prefs.setString('organizationId', orgId);
// // //       return orgId;
// // //     } else if (response.statusCode == 404) {
// // //       return null; // Not found
// // //     } else {
// // //       throw Exception('Failed to fetch organization by name: ${response.body}');
// // //     }
// // //   }
// // //
// // //   // ✅ Update Organization
// // //   static Future<void> updateOrganization(String id, String newName) async {
// // //     final prefs = await SharedPreferences.getInstance();
// // //     final token = prefs.getString('accessToken');
// // //
// // //     final response = await http.put(
// // //       Uri.parse('$_baseUrl/$id'),
// // //       headers: {
// // //         'Authorization': 'Bearer $token',
// // //         'Content-Type': 'application/json',
// // //       },
// // //       body: json.encode({'name': newName}),
// // //     );
// // //
// // //     if (response.statusCode != 200) {
// // //       throw Exception('Failed to update organization: ${response.body}');
// // //     }
// // //   }
// // //
// // //   // ✅ Delete Organization
// // //   static Future<void> deleteOrganization(String id) async {
// // //     final prefs = await SharedPreferences.getInstance();
// // //     final token = prefs.getString('accessToken');
// // //
// // //     final response = await http.delete(
// // //       Uri.parse('$_baseUrl/$id'),
// // //       headers: {'Authorization': 'Bearer $token'},
// // //     );
// // //
// // //     if (response.statusCode != 200) {
// // //       throw Exception('Failed to delete organization: ${response.body}');
// // //     }
// // //   }
// // //
// // //   // ✅ Get stored organizationId
// // //   static Future<String?> getStoredOrganizationId() async {
// // //     final prefs = await SharedPreferences.getInstance();
// // //     return prefs.getString('organizationId');
// // //   }
// // // }
// //
// //
// // import 'dart:convert';
// // import 'package:http/http.dart' as http;
// // import 'package:ancilmediaadminpanel/environmental variables.dart';
// //
// // class OrganizationController {
// //   static final String _orgUrl = '$baseUrl/api/organization';
// //
// //   // ✅ Fetch all organizations
// //   static Future<List<Map<String, dynamic>>> fetchOrganizations() async {
// //     final response = await http.get(Uri.parse(_orgUrl));
// //     print("Fetch Response: ${response.statusCode} ${response.body}");
// //
// //     final contentType = response.headers['content-type'];
// //     if (response.statusCode == 200 &&
// //         contentType != null &&
// //         contentType.contains('application/json')) {
// //       final List orgs = json.decode(response.body);
// //       return orgs.cast<Map<String, dynamic>>();
// //     } else {
// //       throw Exception("Invalid response: Not JSON or status != 200\n\nBody: ${response.body}");
// //     }
// //   }
// //
// //   // ✅ Regular user creates an organization (needs admin approval)
// //   static Future<String?> createOrganization(String name) async {
// //     final response = await http.post(
// //       Uri.parse(_orgUrl),
// //       headers: {'Content-Type': 'application/json'},
// //       body: jsonEncode({'name': name, 'createdByAdmin': false}),
// //     );
// //
// //     print("Create Org Response: ${response.statusCode} ${response.body}");
// //
// //     if (response.statusCode == 201) return null;
// //     if (response.statusCode == 409) return "Organization already exists";
// //
// //     final body = jsonDecode(response.body);
// //     return body['error'] ?? 'Failed to create organization';
// //   }
// //
// //   // ✅ Admin creates org + app-admin user (auto-approved)
// //   static Future<String?> createOrganizationWithAdmin({
// //     required String name,
// //     required String username,
// //     required String email,
// //     required String password,
// //     required String phone, // ✅ ADD phone
// //   }) async {
// //     final response = await http.post(
// //       Uri.parse(_orgUrl),
// //       headers: {'Content-Type': 'application/json'},
// //       body: jsonEncode({
// //         'name': name,
// //         'username': username,
// //         'email': email,
// //         'password': password,
// //         'phone': phone, // ✅ INCLUDE in payload
// //         'createdByAdmin': true,
// //       }),
// //     );
// //
// //     print("Create Org+Admin Response: ${response.statusCode} ${response.body}");
// //
// //     if (response.statusCode == 201) return null;
// //     if (response.statusCode == 409) {
// //       final body = jsonDecode(response.body);
// //       return body['error'] ?? "Conflict occurred";
// //     }
// //
// //     final body = jsonDecode(response.body);
// //     return body['error'] ?? 'Failed to create organization with admin';
// //   }
// //
// //   // ✅ Soft delete
// //   static Future<bool> deleteOrganization(String id) async {
// //     final response = await http.delete(Uri.parse("$_orgUrl/$id"));
// //     print("Delete Response: ${response.statusCode} ${response.body}");
// //     return response.statusCode == 200;
// //   }
// //
// //   // ✅ Block / Unblock
// //   static Future<bool> blockOrganization(String id, bool blocked) async {
// //     final response = await http.patch(
// //       Uri.parse("$_orgUrl/$id/block"),
// //       headers: {'Content-Type': 'application/json'},
// //       body: jsonEncode({'blocked': blocked}),
// //     );
// //     print("Block/Unblock Response: ${response.statusCode} ${response.body}");
// //     return response.statusCode == 200;
// //   }
// //
// //   // ✅ Approve / Reject / Reset
// //   static Future<bool> approveOrganization(String id, bool? approve) async {
// //     final response = await http.patch(
// //       Uri.parse("$_orgUrl/$id/approve"),
// //       headers: {'Content-Type': 'application/json'},
// //       body: jsonEncode({'approve': approve}),
// //     );
// //     print("Approve/Reject Response: ${response.statusCode} ${response.body}");
// //     return response.statusCode == 200;
// //   }
// //
// //   // ✅ Update organization name
// //   static Future<bool> updateOrganizationName(String id, String newName) async {
// //     final response = await http.put(
// //       Uri.parse("$_orgUrl/$id"),
// //       headers: {'Content-Type': 'application/json'},
// //       body: jsonEncode({'name': newName}),
// //     );
// //     print("Update Name Response: ${response.statusCode} ${response.body}");
// //     return response.statusCode == 200;
// //   }
// // }
//
//
//
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:ancilmediaadminpanel/environmental variables.dart';
//
// class OrganizationController {
//   static final String _orgUrl = '$baseUrl/api/organization';
//
//   // ✅ Fetch all organizations
//   static Future<List<Map<String, dynamic>>> fetchOrganizations() async {
//     final response = await http.get(Uri.parse(_orgUrl));
//     print("Fetch Response: ${response.statusCode} ${response.body}");
//
//     final contentType = response.headers['content-type'];
//     if (response.statusCode == 200 &&
//         contentType != null &&
//         contentType.contains('application/json')) {
//       final List orgs = json.decode(response.body);
//       return orgs.cast<Map<String, dynamic>>();
//     } else {
//       throw Exception("Invalid response: Not JSON or status != 200\n\nBody: ${response.body}");
//     }
//   }
//
//   // ✅ Admin creates org + app-admin user (auto-approved)
//   static Future<String?> createOrganizationWithAdmin({
//     required String name,
//     required String username,
//     required String email,
//     required String password,
//     required String phone,
//   }) async {
//     final response = await http.post(
//       Uri.parse(_orgUrl),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         'name': name,
//         'username': username,
//         'email': email,
//         'password': password,
//         'phone': phone,
//         'createdByAdmin': true,
//       }),
//     );
//
//     print("Create Org+Admin Response: ${response.statusCode} ${response.body}");
//
//     if (response.statusCode == 201) return null;
//     if (response.statusCode == 409) {
//       final body = jsonDecode(response.body);
//       return body['error'] ?? "Conflict occurred";
//     }
//
//     final body = jsonDecode(response.body);
//     return body['error'] ?? 'Failed to create organization with admin';
//   }
//
//   // ✅ Delete organization
//   static Future<bool> deleteOrganization(String id) async {
//     final response = await http.delete(Uri.parse("$_orgUrl/$id"));
//     print("Delete Response: ${response.statusCode} ${response.body}");
//     return response.statusCode == 200;
//   }
//
//   // ✅ Block / Unblock
//   static Future<bool> blockOrganization(String id, bool blocked) async {
//     final response = await http.patch(
//       Uri.parse("$_orgUrl/$id/block"),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'blocked': blocked}),
//     );
//     print("Block/Unblock Response: ${response.statusCode} ${response.body}");
//     return response.statusCode == 200;
//   }
//
//   // ✅ Approve / Reject
//   static Future<bool> approveOrganization(String id, bool? approve) async {
//     final response = await http.patch(
//       Uri.parse("$_orgUrl/$id/approve"),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'approve': approve}),
//     );
//     print("Approve/Reject Response: ${response.statusCode} ${response.body}");
//     return response.statusCode == 200;
//   }
//
//   // ✅ Update full organization details
//   static Future<bool> updateOrganizationDetails({
//     required String id,
//     required String name,
//     required String username,
//     required String email,
//     required String phone,
//   }) async {
//     final response = await http.put(
//       Uri.parse("$_orgUrl/$id"),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         'name': name,
//         'username': username,
//         'email': email,
//         'phone': phone,
//         'createdByAdmin': true,
//       }),
//     );
//     return response.statusCode == 200;
//   }
//
// }


import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ancilmediaadminpanel/environmental variables.dart';

class OrganizationController {
  static final String _orgUrl = '$baseUrl/api/organization';

  // ✅ Fetch all organizations
  static Future<List<Map<String, dynamic>>> fetchOrganizations() async {
    try {
      final response = await http.get(Uri.parse(_orgUrl)).timeout(const Duration(seconds: 10));
      print("Fetch Response: ${response.statusCode} ${response.body}");

      final contentType = response.headers['content-type'];
      if (response.statusCode == 200 && contentType != null && contentType.contains('application/json')) {
        final List orgs = json.decode(response.body);
        return orgs.cast<Map<String, dynamic>>();
      } else {
        throw Exception("Invalid response: Not JSON or status != 200\n\nBody: ${response.body}");
      }
    } catch (e) {
      print("Fetch error: $e");
      rethrow;
    }
  }

  // ✅ Admin creates org + app-admin user (auto-approved)
  static Future<String?> createOrganizationWithAdmin({
    required String name,
    required String username,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_orgUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'username': username,
          'email': email,
          'password': password,
          'phone': phone,
          'createdByAdmin': true,
        }),
      );

      print("Create Org+Admin Response: ${response.statusCode} ${response.body}");

      if (response.statusCode == 201) return null;
      final body = jsonDecode(response.body);
      if (response.statusCode == 409) {
        return body['error'] ?? "Conflict occurred";
      }
      return body['error'] ?? 'Failed to create organization with admin';
    } catch (e) {
      print("Create error: $e");
      return 'Network or server error';
    }
  }

  // ✅ Delete organization
  static Future<bool> deleteOrganization(String id) async {
    try {
      final response = await http.delete(Uri.parse("$_orgUrl/$id"));
      print("Delete Response: ${response.statusCode} ${response.body}");
      return response.statusCode == 200;
    } catch (e) {
      print("Delete error: $e");
      return false;
    }
  }

  // ✅ Block / Unblock
  static Future<bool> blockOrganization(String id, bool blocked) async {
    try {
      final response = await http.patch(
        Uri.parse("$_orgUrl/$id/block"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'blocked': blocked}),
      );
      print("Block/Unblock Response: ${response.statusCode} ${response.body}");
      return response.statusCode == 200;
    } catch (e) {
      print("Block error: $e");
      return false;
    }
  }

  // ✅ Approve / Reject
  static Future<bool> approveOrganization(String id, bool? approve) async {
    try {
      final response = await http.patch(
        Uri.parse("$_orgUrl/$id/approve"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'approve': approve}),
      );
      print("Approve/Reject Response: ${response.statusCode} ${response.body}");
      return response.statusCode == 200;
    } catch (e) {
      print("Approve error: $e");
      return false;
    }
  }

  // ✅ Update full organization details
  static Future<bool> updateOrganizationDetails({
    required String id,
    required String name,
    required String username,
    required String email,
    required String phone,
  }) async {
    try {
      final response = await http.put(
        Uri.parse("$_orgUrl/$id"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'username': username,
          'email': email,
          'phone': phone,
          'createdByAdmin': true,
        }),
      );
      print("Update Response: ${response.statusCode} ${response.body}");
      return response.statusCode == 200;
    } catch (e) {
      print("Update error: $e");
      return false;
    }
  }
}
