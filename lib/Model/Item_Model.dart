// class ItemModel {
//   final String id;
//   final String title;
//   final String? subtitle;
//   final String? url;
//   final String? image;
//   final String? imageName;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;
//   final int? v;
//   final int? index;
//
//   ItemModel({
//     required this.id,
//     required this.title,
//     this.subtitle,
//     this.url,
//     this.image,
//     this.imageName,
//     this.createdAt,
//     this.updatedAt,
//     this.v,
//     this.index,
//   });
//
//   factory ItemModel.fromJson(Map<String, dynamic> json) {
//     return ItemModel(
//       id: json["_id"] ?? '',
//       title: json["title"] ?? '',
//       subtitle: json["subtitle"],
//       url: json["url"],
//       image: json["image"],
//       imageName: json["imageName"],
//       createdAt: json["createdAt"] != null ? DateTime.parse(json["createdAt"]) : null,
//       updatedAt: json["updatedAt"] != null ? DateTime.parse(json["updatedAt"]) : null,
//       v: json["__v"],
//       index: json["index"],
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     "_id": id,
//     "title": title,
//     "subtitle": subtitle,
//     "url": url,
//     "image": image,
//     "imageName": imageName,
//     "createdAt": createdAt?.toIso8601String(),
//     "updatedAt": updatedAt?.toIso8601String(),
//     "__v": v,
//     "index": index,
//   };
// }


class ItemModel {
  final String id;
  final String title;
  final String? subtitle;
  final String? url;
  final String? image;
  final String? imageName;
  final String? type;
  final String? parentId; // ✅ For nested items
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final int? index;

  ItemModel({
    required this.id,
    required this.title,
    this.subtitle,
    this.url,
    this.image,
    this.imageName,
    this.type,
    this.parentId,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.index,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json["_id"] ?? '',
      title: json["title"] ?? '',
      subtitle: json["subtitle"],
      url: json["url"],
      image: json["image"],
      imageName: json["imageName"],
      type: json["type"],
      parentId: json["parentId"],
      createdAt: json["createdAt"] != null ? DateTime.tryParse(json["createdAt"]) : null,
      updatedAt: json["updatedAt"] != null ? DateTime.tryParse(json["updatedAt"]) : null,
      v: json["__v"],
      index: json["index"],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "_id": id,
      "title": title,
    };

    if (subtitle != null) data["subtitle"] = subtitle;
    if (url != null) data["url"] = url;
    if (image != null) data["image"] = image;
    if (imageName != null) data["imageName"] = imageName;
    if (type != null) data["type"] = type;
    if (parentId != null) data["parentId"] = parentId;
    if (createdAt != null) data["createdAt"] = createdAt!.toIso8601String();
    if (updatedAt != null) data["updatedAt"] = updatedAt!.toIso8601String();
    if (v != null) data["__v"] = v;
    if (index != null) data["index"] = index;

    return data;
  }
}
