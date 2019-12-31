class Category {
  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  Category({this.id, this.name, this.createdAt, this.updatedAt});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
