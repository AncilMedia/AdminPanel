class ItemModel {
  final String id;
  final String title;
  final String? subtitle;
  final String? image;
  final String? type;
  final String? parentId;

  // ✅ Make this mutable
  int? index;

  final String? url;
  final String? imageName;

  ItemModel({
    required this.id,
    required this.title,
    this.subtitle,
    this.image,
    this.type,
    this.parentId,
    this.index,         // ✅ keep in constructor
    this.url,
    this.imageName,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['_id'],
      title: json['title'],
      subtitle: json['subtitle'],
      image: json['image'],
      type: json['type'],
      parentId: json['parentId'],
      index: json['index'],           // ✅ support from API
      url: json['url'],
      imageName: json['imageName'],
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
    };
  }
}
