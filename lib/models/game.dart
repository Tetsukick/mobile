import 'package:splitsio/models/category.dart';

class Game {
  final String id;
  final String name;
  final String shortname;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Category> categories;

  Game({
    this.id,
    this.name,
    this.shortname,
    this.createdAt,
    this.updatedAt,
    this.categories,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'],
      name: json['name'],
      shortname: json['shortname'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      // categories: // Not present in Run response
          // json['categories'].map((category) => Category.fromJson(category)),
    );
  }
}
