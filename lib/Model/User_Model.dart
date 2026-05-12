// // // class UserModel {
// // //   final String id;         // MongoDB _id
// // //   final String userId;     // Custom ID like "U0624012"
// // //   final String username;
// // //   final String email;
// // //   final String phone;
// // //
// // //   bool? approved; // nullable & mutable
// // //   bool blocked;   // mutable
// // //   String role;    // mutable
// // //
// // //   UserModel({
// // //     required this.id,
// // //     required this.userId,
// // //     required this.username,
// // //     required this.email,
// // //     required this.phone,
// // //     this.approved,
// // //     required this.blocked,
// // //     required this.role,
// // //   });
// // //
// // //   factory UserModel.fromJson(Map<String, dynamic> json) {
// // //     return UserModel(
// // //       id: json['_id'],
// // //       userId: json['userId'] ?? '',
// // //       username: json['username'],
// // //       email: json['email'],
// // //       phone: json['phone'] ?? '',
// // //       approved: json['approved'],
// // //       blocked: json['blocked'] ?? false,
// // //       role: json['role'] ?? '',
// // //     );
// // //   }
// // // }
// //
// // class UserModel {
// //   final String id;         // MongoDB _id
// //   final String userId;     // Custom ID like "U0624012"
// //   final String username;
// //   final String email;
// //   final String phone;
// //
// //   bool? approved; // nullable & mutable
// //   bool blocked;   // mutable
// //   String role;    // mutable
// //
// //   UserModel({
// //     required this.id,
// //     required this.userId,
// //     required this.username,
// //     required this.email,
// //     required this.phone,
// //     this.approved,
// //     required this.blocked,
// //     required this.role,
// //   });
// //
// //   factory UserModel.fromJson(Map<String, dynamic> json) {
// //     return UserModel(
// //       id: json['_id'],
// //       userId: json['userId'] ?? '',
// //       username: json['username'],
// //       email: json['email'],
// //       phone: json['phone'] ?? '',
// //       approved: json['approved'],
// //       blocked: json['blocked'] ?? false,
// //       role: json['role'] ?? '',
// //     );
// //   }
// //
// //   /// ✅ Add this factory for safe fallback use
// //   factory UserModel.empty() {
// //     return UserModel(
// //       id: '',
// //       userId: '',
// //       username: '',
// //       email: '',
// //       phone: '',
// //       approved: false,
// //       blocked: false,
// //       role: '',
// //     );
// //   }
// // }
//
// class UserModel {
//   final String id;         // MongoDB _id
//   final String userId;     // Custom ID like "U0624012"
//   final String username;
//   final String email;
//   final String phone;
//
//   bool? approved; // nullable & mutable
//   bool blocked;   // mutable
//   String role;    // mutable
//
//   UserModel({
//     required this.id,
//     required this.userId,
//     required this.username,
//     required this.email,
//     required this.phone,
//     this.approved,
//     required this.blocked,
//     required this.role,
//   });
//
//   factory UserModel.fromJson(Map<String, dynamic> json) {
//     // Handle role as either String or Map
//     String roleName = '';
//     if (json['role'] is String) {
//       roleName = json['role'];
//     } else if (json['role'] is Map<String, dynamic>) {
//       roleName = json['role']['name'] ?? '';
//     }
//
//     return UserModel(
//       id: json['_id'] ?? '',
//       userId: json['userId'] ?? '',
//       username: json['username'] ?? '',
//       email: json['email'] ?? '',
//       phone: json['phone'] ?? '',
//       approved: json['approved'],
//       blocked: json['blocked'] ?? false,
//       role: roleName,
//     );
//   }
//
//   /// Safe empty fallback
//   factory UserModel.empty() {
//     return UserModel(
//       id: '',
//       userId: '',
//       username: '',
//       email: '',
//       phone: '',
//       approved: false,
//       blocked: false,
//       role: '',
//     );
//   }
// }


class UserModel {
  final String id;
  final String userId;
  final String username;
  final String email;
  final String? phone;

  final String role;

  final bool? approved;
  final bool blocked;

  final String? image;
  final String? imageName;

  // ================= PRESENCE =================
  final bool isOnline;
  final DateTime? lastSeen;

  UserModel({
    required this.id,
    required this.userId,
    required this.username,
    required this.email,
    this.phone,
    required this.role,
    required this.approved,
    required this.blocked,
    this.image,
    this.imageName,

    // ================= PRESENCE =================
    required this.isOnline,
    required this.lastSeen,
  });

  // ================= EMPTY CONSTRUCTOR =================
  factory UserModel.empty() {
    return UserModel(
      id: '',
      userId: '',
      username: '',
      email: '',
      phone: null,
      role: '',
      approved: null,
      blocked: false,
      image: null,
      imageName: null,
      isOnline: false,
      lastSeen: null,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',

      userId: json['userId'] ?? '',

      username: json['username'] ?? '',

      email: json['email'] ?? '',

      phone: json['phone'],

      role: json['role'] is Map
          ? (json['role']['name'] ?? '')
          : (json['role'] ?? ''),

      approved: json['approved'],

      blocked: json['blocked'] ?? false,

      image: json['image'],

      imageName: json['imageName'],

      // ================= PRESENCE =================
      isOnline: json['isOnline'] ?? false,

      lastSeen: json['lastSeen'] != null
          ? DateTime.tryParse(json['lastSeen'].toString())
          : null,
    );
  }
}