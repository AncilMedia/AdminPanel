class ListModel {
  final String id;
  final String title;
  final String? subtitle;
  final String image;
  final String? type;
  final String? parentId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  ListModel({
    required this.id,
    required this.title,
    this.subtitle,
    required this.image,
    this.type,
    this.parentId,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory ListModel.fromJson(Map<String, dynamic> json) {
    return ListModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'],
      image: json['image'] ?? '',
      type: json['type'],
      parentId: json['parentId'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'title': title,
    'subtitle': subtitle,
    'image': image,
    'type': type,
    'parentId': parentId,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    '__v': v,
  };
}
