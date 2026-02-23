// // class ItemModel {
// //   String id;
// //   String title;
// //   String? subtitle;
// //   String? image;
// //   String? type;
// //   String? parentId;
// //   int? index;
// //   String? url;
// //   String? imageName;
// //
// //   ItemModel({
// //     required this.id,
// //     required this.title,
// //     this.subtitle,
// //     this.image,
// //     this.type,
// //     this.parentId,
// //     this.index,
// //     this.url,
// //     this.imageName,
// //   });
// //
// //   factory ItemModel.fromJson(Map<String, dynamic> json) {
// //     return ItemModel(
// //       id: json['_id'],
// //       title: json['title'],
// //       subtitle: json['subtitle'],
// //       image: json['image'],
// //       type: json['type'],
// //       parentId: json['parentId'],
// //       index: json['index'],
// //       url: json['url'],
// //       imageName: json['imageName'],
// //     );
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     return {
// //       '_id': id,
// //       'title': title,
// //       'subtitle': subtitle,
// //       'image': image,
// //       'type': type,
// //       'parentId': parentId,
// //       'index': index,
// //       'url': url,
// //       'imageName': imageName,
// //     };
// //   }
// // }
//
//
// class ItemModel {
//   String id;
//   String title;
//   String? subtitle;
//   String? image;
//   String? type;
//   String? parentId;
//   int? index;
//   String? url;
//   String? imageName;
//   String? organizationId; // ✅ New field
//
//   ItemModel({
//     required this.id,
//     required this.title,
//     this.subtitle,
//     this.image,
//     this.type,
//     this.parentId,
//     this.index,
//     this.url,
//     this.imageName,
//     this.organizationId, // ✅ Add to constructor
//   });
//
//   factory ItemModel.fromJson(Map<String, dynamic> json) {
//     return ItemModel(
//       id: json['_id'],
//       title: json['title'],
//       subtitle: json['subtitle'],
//       image: json['image'],
//       type: json['type'],
//       parentId: json['parentId'],
//       index: json['index'],
//       url: json['url'],
//       imageName: json['imageName'],
//       organizationId: json['organizationId'], // ✅ Parse org ID
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'title': title,
//       'subtitle': subtitle,
//       'image': image,
//       'type': type,
//       'parentId': parentId,
//       'index': index,
//       'url': url,
//       'imageName': imageName,
//       'organizationId': organizationId, // ✅ Serialize org ID
//     };
//   }
// }


class ItemModel {
  String id;
  String title;
  String? subtitle;
  String? image;
  String? type;
  String? parentId;
  int? index;
  String? url;
  String? imageName;
  String? organizationId;
  String? createdAt; // 👈 Add this for the Event Date/Time

  ItemModel({
    required this.id,
    required this.title,
    this.subtitle,
    this.image,
    this.type,
    this.parentId,
    this.index,
    this.url,
    this.imageName,
    this.organizationId,
    this.createdAt, // 👈 Add to constructor
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      // Using ?? '' ensures that if _id is null, it doesn't crash the app
      id: json['_id'] ?? '',
      title: json['title'] ?? 'Untitled',
      subtitle: json['subtitle'],
      image: json['image'],
      type: json['type'],
      parentId: json['parentId'],
      index: json['index'],
      url: json['url'],
      imageName: json['imageName'],
      organizationId: json['organizationId'],
      createdAt: json['createdAt'], // 👈 Parse from JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'subtitle': subtitle,
      'image': image,
      'type': type,
      'parentId': parentId,
      'index': index,
      'url': url,
      'imageName': imageName,
      'organizationId': organizationId,
      'createdAt': createdAt, // 👈 Serialize
    };
  }
}