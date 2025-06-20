class UserModel {
  final String id;
  final String username;
  final String email;
  final String phone;

  bool? approved; // nullable & mutable
  bool blocked;   // mutable
  String role;    // mutable

  UserModel({
    required this.id,
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
      username: json['username'],
      email: json['email'],
      phone: json['phone'] ?? '',
      approved: json['approved'],
      blocked: json['blocked'] ?? false,
      role: json['role'] ?? '',
    );
  }
}
