import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:splitsio/models/category.dart';

class Game {
  static Map<String, Game> cached = Map<String, Game>();

  final String id;
  final String srdcId;
  final String name;
  final String shortname;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Category> categories;

  Game({
    this.id,
    this.srdcId,
    this.name,
    this.shortname,
    this.createdAt,
    this.updatedAt,
    this.categories,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    if (cached.containsKey(json['id'])) {
      return cached[json['id']];
    }

    Game game = Game(
      id: json['id'],
      srdcId: json['srdc_id'],
      name: json['name'],
      shortname: json['shortname'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      // categories: // Not present in Run response
      // json['categories'].map((category) => Category.fromJson(category)),
    );

    cached[game.id] = game;
    return game;
  }

  Future<Uri> cover() {
    return http
        .get("https://speedrun.com/api/v1/games/$srdcId")
        .then((http.Response response) {
      var game = JsonDecoder().convert(response.body)['data'];
      if (game != null && game['assets']['cover-large']['uri'] != null) {
        return Uri.parse(game['assets']['cover-large']['uri']);
      }

      return Uri.parse("https://splits.io/logo.png");
    });
  }
}
