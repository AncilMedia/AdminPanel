// // // // class ItemModel {
// // // //   String id;
// // // //   String title;
// // // //   String? subtitle;
// // // //   String? image;
// // // //   String? type;
// // // //   String? parentId;
// // // //   int? index;
// // // //   String? url;
// // // //   String? imageName;
// // // //
// // // //   ItemModel({
// // // //     required this.id,
// // // //     required this.title,
// // // //     this.subtitle,
// // // //     this.image,
// // // //     this.type,
// // // //     this.parentId,
// // // //     this.index,
// // // //     this.url,
// // // //     this.imageName,
// // // //   });
// // // //
// // // //   factory ItemModel.fromJson(Map<String, dynamic> json) {
// // // //     return ItemModel(
// // // //       id: json['_id'],
// // // //       title: json['title'],
// // // //       subtitle: json['subtitle'],
// // // //       image: json['image'],
// // // //       type: json['type'],
// // // //       parentId: json['parentId'],
// // // //       index: json['index'],
// // // //       url: json['url'],
// // // //       imageName: json['imageName'],
// // // //     );
// // // //   }
// // // //
// // // //   Map<String, dynamic> toJson() {
// // // //     return {
// // // //       '_id': id,
// // // //       'title': title,
// // // //       'subtitle': subtitle,
// // // //       'image': image,
// // // //       'type': type,
// // // //       'parentId': parentId,
// // // //       'index': index,
// // // //       'url': url,
// // // //       'imageName': imageName,
// // // //     };
// // // //   }
// // // // }
// // //
// // //
// // // class ItemModel {
// // //   String id;
// // //   String title;
// // //   String? subtitle;
// // //   String? image;
// // //   String? type;
// // //   String? parentId;
// // //   int? index;
// // //   String? url;
// // //   String? imageName;
// // //   String? organizationId; // ✅ New field
// // //
// // //   ItemModel({
// // //     required this.id,
// // //     required this.title,
// // //     this.subtitle,
// // //     this.image,
// // //     this.type,
// // //     this.parentId,
// // //     this.index,
// // //     this.url,
// // //     this.imageName,
// // //     this.organizationId, // ✅ Add to constructor
// // //   });
// // //
// // //   factory ItemModel.fromJson(Map<String, dynamic> json) {
// // //     return ItemModel(
// // //       id: json['_id'],
// // //       title: json['title'],
// // //       subtitle: json['subtitle'],
// // //       image: json['image'],
// // //       type: json['type'],
// // //       parentId: json['parentId'],
// // //       index: json['index'],
// // //       url: json['url'],
// // //       imageName: json['imageName'],
// // //       organizationId: json['organizationId'], // ✅ Parse org ID
// // //     );
// // //   }
// // //
// // //   Map<String, dynamic> toJson() {
// // //     return {
// // //       '_id': id,
// // //       'title': title,
// // //       'subtitle': subtitle,
// // //       'image': image,
// // //       'type': type,
// // //       'parentId': parentId,
// // //       'index': index,
// // //       'url': url,
// // //       'imageName': imageName,
// // //       'organizationId': organizationId, // ✅ Serialize org ID
// // //     };
// // //   }
// // // }
// //
// //
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
// //   String? organizationId;
// //   String? createdAt; // 👈 Add this for the Event Date/Time
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
// //     this.organizationId,
// //     this.createdAt, // 👈 Add to constructor
// //   });
// //
// //   factory ItemModel.fromJson(Map<String, dynamic> json) {
// //     return ItemModel(
// //       // Using ?? '' ensures that if _id is null, it doesn't crash the app
// //       id: json['_id'] ?? '',
// //       title: json['title'] ?? 'Untitled',
// //       subtitle: json['subtitle'],
// //       image: json['image'],
// //       type: json['type'],
// //       parentId: json['parentId'],
// //       index: json['index'],
// //       url: json['url'],
// //       imageName: json['imageName'],
// //       organizationId: json['organizationId'],
// //       createdAt: json['createdAt'], // 👈 Parse from JSON
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
// //       'organizationId': organizationId,
// //       'createdAt': createdAt, // 👈 Serialize
// //     };
// //   }
// // }
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
//   String? organizationId;
//
//   // ❌ createdAt is NOT event time (keep if needed)
//   String? createdAt;
//
//   // ✅ ADD THESE FOR EVENTS
//   String? startDateTime;
//   String? endDateTime;
//   bool? isAllDay;
//   String? calendar;
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
//     this.organizationId,
//     this.createdAt,
//
//     // ✅ NEW
//     this.startDateTime,
//     this.endDateTime,
//     this.isAllDay,
//     this.calendar,
//   });
//
//   factory ItemModel.fromJson(Map<String, dynamic> json) {
//     return ItemModel(
//       id: json['_id'] ?? '',
//       title: json['title'] ?? 'Untitled',
//       subtitle: json['subtitle'],
//       image: json['image'],
//       type: json['type'],
//       parentId: json['parentId'],
//       index: json['index'],
//       url: json['url'],
//       imageName: json['imageName'],
//       organizationId: json['organizationId'],
//       createdAt: json['createdAt'],
//
//       // ✅ PARSE EVENT DATA
//       startDateTime: json['startDateTime'],
//       endDateTime: json['endDateTime'],
//       isAllDay: json['isAllDay'] == true || json['isAllDay'] == 'true',
//       calendar: json['calendar'],
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
//       'organizationId': organizationId,
//       'createdAt': createdAt,
//
//       // ✅ SEND EVENT DATA
//       'startDateTime': startDateTime,
//       'endDateTime': endDateTime,
//       'isAllDay': isAllDay,
//       'calendar': calendar,
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

  String? createdAt;

  // ✅ ADD THESE
  String? startDateTime;
  String? endDateTime;
  bool? isAllDay;

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
    this.createdAt,

    // ✅ constructor
    this.startDateTime,
    this.endDateTime,
    this.isAllDay,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
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
      createdAt: json['createdAt'],

      // ✅ parse from backend
      startDateTime: json['startDateTime'],
      endDateTime: json['endDateTime'],
      isAllDay: json['isAllDay'],
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
      'createdAt': createdAt,

      // ✅ send to backend
      'startDateTime': startDateTime,
      'endDateTime': endDateTime,
      'isAllDay': isAllDay,
    };
  }
}