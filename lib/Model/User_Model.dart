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
//     return UserModel(
//       id: json['_id'],
//       userId: json['userId'] ?? '',
//       username: json['username'],
//       email: json['email'],
//       phone: json['phone'] ?? '',
//       approved: json['approved'],
//       blocked: json['blocked'] ?? false,
//       role: json['role'] ?? '',
//     );
//   }
// }

class UserModel {
  final String id;         // MongoDB _id
  final String userId;     // Custom ID like "U0624012"
  final String username;
  final String email;
  final String phone;

  bool? approved; // nullable & mutable
  bool blocked;   // mutable
  String role;    // mutable

  UserModel({
    required this.id,
    required this.userId,
    required this.username,
    required this.email,
    required this.phone,
    this.approved,
    required this.blocked,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      userId: json['userId'] ?? '',
      username: json['username'],
      email: json['email'],
      phone: json['phone'] ?? '',
      approved: json['approved'],
      blocked: json['blocked'] ?? false,
      role: json['role'] ?? '',
    );
  }

  /// ✅ Add this factory for safe fallback use
  factory UserModel.empty() {
    return UserModel(
      id: '',
      userId: '',
      username: '',
      email: '',
      phone: '',
      approved: false,
      blocked: false,
      role: '',
    );
  }
}
