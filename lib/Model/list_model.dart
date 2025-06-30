class ListModel {
  final String id;
  final String title;
  final String subtitle;

  ListModel({required this.id, required this.title, required this.subtitle});

  factory ListModel.fromJson(Map<String, dynamic> json) {
    return ListModel(
      id: json['_id'],
      title: json['title'],
      subtitle: json['subtitle'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'subtitle': subtitle,
  };
}
