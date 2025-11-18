// // // // class NavigationModel {
// // // //   final String id;
// // // //   final String label;
// // // //   final String icon;
// // // //   final String type;
// // // //   final String? content;
// // // //   final int order;
// // // //   final bool isActive;
// // // //
// // // //   NavigationModel({
// // // //     required this.id,
// // // //     required this.label,
// // // //     required this.icon,
// // // //     required this.type,
// // // //     this.content,
// // // //     required this.order,
// // // //     required this.isActive,
// // // //   });
// // // //
// // // //   factory NavigationModel.fromJson(Map<String, dynamic> json) {
// // // //     return NavigationModel(
// // // //       id: json['_id'],
// // // //       label: json['label'],
// // // //       icon: json['icon'],
// // // //       type: json['type'],
// // // //       content: json['content'],
// // // //       order: json['order'],
// // // //       isActive: json['isActive'],
// // // //     );
// // // //   }
// // // //
// // // //   Map<String, dynamic> toJson() {
// // // //     return {
// // // //       "label": label,
// // // //       "icon": icon,
// // // //       "type": type,
// // // //       "content": content,
// // // //       "order": order,
// // // //       "isActive": isActive,
// // // //     };
// // // //   }
// // // // }
// // //
// // //
// // // // lib/Model/Navigation_model.dart
// // // class NavigationModel {
// // //   String id;
// // //   String label;
// // //   String icon;
// // //   String type;
// // //   String? content;
// // //   int order;
// // //   bool isActive;
// // //
// // //   NavigationModel({
// // //     required this.id,
// // //     required this.label,
// // //     required this.icon,
// // //     required this.type,
// // //     this.content,
// // //     required this.order,
// // //     required this.isActive,
// // //   });
// // //
// // //   factory NavigationModel.fromJson(Map<String, dynamic> json) {
// // //     return NavigationModel(
// // //       id: json['_id'] ?? json['id'] ?? '',
// // //       label: json['label'] ?? '',
// // //       icon: json['icon'] ?? '',
// // //       type: json['type'] ?? 'static',
// // //       content: json['content'],
// // //       order: json['order'] ?? 0,
// // //       isActive: json['isActive'] ?? true,
// // //     );
// // //   }
// // //
// // //   // used for safe fallback
// // //   factory NavigationModel.empty() => NavigationModel(
// // //     id: '',
// // //     label: '',
// // //     icon: '',
// // //     type: '',
// // //     content: '',
// // //     order: 0,
// // //     isActive: false,
// // //   );
// // // }
// //
// //
// // // lib/Model/Navigation_model.dart
// //
// // class NavigationModel {
// //   String id;
// //   String label;
// //   String icon;
// //   String type;
// //   String? content;
// //   int order;
// //   bool isActive;
// //   String organization; // <-- NEW FIELD
// //
// //   NavigationModel({
// //     required this.id,
// //     required this.label,
// //     required this.icon,
// //     required this.type,
// //     this.content,
// //     required this.order,
// //     required this.isActive,
// //     required this.organization,   // <-- NEW
// //   });
// //
// //   factory NavigationModel.fromJson(Map<String, dynamic> json) {
// //     return NavigationModel(
// //       id: json['_id'] ?? json['id'] ?? '',
// //       label: json['label'] ?? '',
// //       icon: json['icon'] ?? '',
// //       type: json['type'] ?? 'static',
// //       content: json['content'],
// //       order: json['order'] ?? 0,
// //       isActive: json['isActive'] ?? true,
// //       organization: json['organization'] ?? '',   // <-- NEW
// //     );
// //   }
// //
// //   factory NavigationModel.empty() => NavigationModel(
// //     id: '',
// //     label: '',
// //     icon: '',
// //     type: '',
// //     content: '',
// //     order: 0,
// //     isActive: false,
// //     organization: '',  // <-- NEW
// //   );
// //
// //   Map<String, dynamic> toJson() {
// //     return {
// //       "label": label,
// //       "icon": icon,
// //       "type": type,
// //       "content": content,
// //       "order": order,
// //       "isActive": isActive,
// //       "organization": organization,  // <-- NEW
// //     };
// //   }
// // }
//
//
// class NavigationModel {
//   String id;
//   String label;
//   String icon;
//   String type;
//   String? content;
//   int order;
//   bool isActive;
//
//   NavigationModel({
//     required this.id,
//     required this.label,
//     required this.icon,
//     required this.type,
//     this.content,
//     required this.order,
//     required this.isActive,
//   });
//
//   factory NavigationModel.fromJson(Map<String, dynamic> json) {
//     return NavigationModel(
//       id: json['_id'] ?? json['id'] ?? '',
//       label: json['label'] ?? '',
//       icon: json['icon'] ?? '',
//       type: json['type'] ?? 'static',
//       content: json['content'],
//       order: json['order'] ?? 0,
//       isActive: json['isActive'] ?? true,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       "label": label,
//       "icon": icon,
//       "type": type,
//       "content": content,
//       "order": order,
//       "isActive": isActive,
//     };
//   }
//
//   factory NavigationModel.empty() => NavigationModel(
//     id: '',
//     label: '',
//     icon: '',
//     type: '',
//     content: '',
//     order: 0,
//     isActive: false,
//   );
// }

class NavigationModel {
  String id;
  String label;
  String icon;
  String type;
  String? content;
  int order;
  bool isActive;

  NavigationModel({
    required this.id,
    required this.label,
    required this.icon,
    required this.type,
    this.content,
    required this.order,
    required this.isActive,
  });

  factory NavigationModel.fromJson(Map<String, dynamic> json) {
    return NavigationModel(
      id: json['_id'] ?? json['id'] ?? '',
      label: json['label'] ?? '',
      icon: json['icon'] ?? '',
      type: json['type'] ?? 'static',
      content: json['content'],
      order: json['order'] ?? 0,
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "label": label,
      "icon": icon,
      "type": type,
      "content": content,
      "order": order,
      "isActive": isActive,
    };
  }
}
