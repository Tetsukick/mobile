import 'package:flutter/widgets.dart';

import 'package:splitsio/models/category.dart';

class Game {
  static Map<String, Game> cached = Map<String, Game>();
  static final defaultCover =
      Uri(scheme: 'https', host: 'splits.io', pathSegments: ['logo.png']);

  final String id;
  final String srdcId;
  final String name;
  final String shortname;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Category> categories;
  final Uri cover;

  Game({
    @required this.id,
    @required this.srdcId,
    @required this.name,
    @required this.shortname,
    @required this.createdAt,
    @required this.updatedAt,
    this.categories,
    @required this.cover,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }

    if (cached.containsKey(json['id'])) {
      return cached[json['id']];
    }

    Uri cover;
    if (json['cover_url'] is String) {
      cover = Uri.parse(json['cover_url'] as String);
    } else {
      cover = defaultCover;
    }

    Game game = Game(
      id: json['id'] as String,
      srdcId: json['srdc_id'] as String,
      name: json['name'] as String,
      shortname: json['shortname'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      cover: cover,
      // categories: // Not present in Run response
      // json['categories'].map((category) => Category.fromJson(category)),
    );

    cached[game.id] = game;
    return game;
  }
}
