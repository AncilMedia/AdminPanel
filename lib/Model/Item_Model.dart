class ItemModel {
  final String id;
  final String title;
  final String? subtitle;
  final String? url;
  final String? image;
  final String? imageName;
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
      createdAt: json["createdAt"] != null ? DateTime.parse(json["createdAt"]) : null,
      updatedAt: json["updatedAt"] != null ? DateTime.parse(json["updatedAt"]) : null,
      v: json["__v"],
      index: json["index"],
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "subtitle": subtitle,
    "url": url,
    "image": image,
    "imageName": imageName,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "index": index,
  };
}
