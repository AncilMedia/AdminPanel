// // class ListModel {
// //   final String id;
// //   final String title;
// //   final String? subtitle;
// //   final String image;
// //   final String? type;
// //   final String? parentId;
// //   final DateTime? createdAt;
// //   final DateTime? updatedAt;
// //   final int? v;
// //
// //   int index; // 👈 Add this (not final)
// //
// //   ListModel({
// //     required this.id,
// //     required this.title,
// //     this.subtitle,
// //     required this.image,
// //     this.type,
// //     this.parentId,
// //     this.createdAt,
// //     this.updatedAt,
// //     this.v,
// //     required this.index, // 👈 Make sure index is required
// //   });
// //
// //   factory ListModel.fromJson(Map<String, dynamic> json) {
// //     return ListModel(
// //       id: json['_id'] ?? '',
// //       title: json['title'] ?? '',
// //       subtitle: json['subtitle'],
// //       image: json['image'] ?? '',
// //       type: json['type'],
// //       parentId: json['parentId'],
// //       createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
// //       updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
// //       v: json['__v'],
// //       index: json['index'] ?? 0, // 👈 Parse index from backend
// //     );
// //   }
// //
// //   Map<String, dynamic> toJson() => {
// //     '_id': id,
// //     'title': title,
// //     'subtitle': subtitle,
// //     'image': image,
// //     'type': type,
// //     'parentId': parentId,
// //     'createdAt': createdAt?.toIso8601String(),
// //     'updatedAt': updatedAt?.toIso8601String(),
// //     '__v': v,
// //     'index': index, // 👈 Include in serialization
// //   };
// // }
//
//
//
// class ListModel {
//   final String id;
//   final String title;
//   final String? subtitle;
//   final String image;
//   final String? type; // list, link, event
//   final String? url;
//   final String? parentId;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;
//   final int? v;
//
//   int index;
//
//   ListModel({
//     required this.id,
//     required this.title,
//     this.subtitle,
//     required this.image,
//     this.type,
//     this.url,
//     this.parentId,
//     this.createdAt,
//     this.updatedAt,
//     this.v,
//     required this.index,
//   });
//
//   factory ListModel.fromJson(Map<String, dynamic> json) {
//     return ListModel(
//       id: json['_id'] ?? '',
//       title: json['title'] ?? '',
//       subtitle: json['subtitle'],
//       image: json['image'] ?? '',
//       type: json['type'],
//       url: json['url'],
//       parentId: json['parentId'],
//       createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
//       updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
//       v: json['__v'],
//       index: json['index'] ?? 0,
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     '_id': id,
//     'title': title,
//     'subtitle': subtitle,
//     'image': image,
//     'type': type,
//     'url': url,
//     'parentId': parentId,
//     'createdAt': createdAt?.toIso8601String(),
//     'updatedAt': updatedAt?.toIso8601String(),
//     '__v': v,
//     'index': index,
//   };
// }



class ListModel {
  final String id;
  final String title;
  final String? subtitle;
  final String image;
  final String? type; // list, link, event
  final String? url;
  final String? parentId;
  final String? organizationId; // ✅ New field
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  int index;

  ListModel({
    required this.id,
    required this.title,
    this.subtitle,
    required this.image,
    this.type,
    this.url,
    this.parentId,
    this.organizationId, // ✅ Add to constructor
    this.createdAt,
    this.updatedAt,
    this.v,
    required this.index,
  });

  factory ListModel.fromJson(Map<String, dynamic> json) {
    return ListModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'],
      image: json['image'] ?? '',
      type: json['type'],
      url: json['url'],
      parentId: json['parentId'],
      organizationId: json['organizationId'], // ✅ Parse org ID
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
      v: json['__v'],
      index: json['index'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'title': title,
    'subtitle': subtitle,
    'image': image,
    'type': type,
    'url': url,
    'parentId': parentId,
    'organizationId': organizationId, // ✅ Include in serialization
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    '__v': v,
    'index': index,
  };
}
