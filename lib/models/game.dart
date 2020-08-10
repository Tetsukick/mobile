import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:cache_image/cache_image.dart';

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

  Future<Uri> _cover;

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
    if (json == null) {
      return null;
    }

    if (cached.containsKey(json['id'])) {
      return cached[json['id']];
    }

    Game game = Game(
      id: json['id'] as String,
      srdcId: json['srdc_id'] as String,
      name: json['name'] as String,
      shortname: json['shortname'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      // categories: // Not present in Run response
      // json['categories'].map((category) => Category.fromJson(category)),
    );

    // Might as well start fetching the cover now, as we know we'll need it
    game.cover();
    cached[game.id] = game;
    return game;
  }

  Future<Uri> cover() async {
    if (_cover != null) {
      return _cover;
    }

    if (srdcId == null) {
      return defaultCover;
    }

    // Save the future for later so that:
    // 1. If another call to cover() is made before the future resolves, we don't queue another future to fetch another identical cover URI
    // 2. If another call to cover() is made after the future resolves, we reuse the fetched content
    _cover = http
        .get(Uri(
            scheme: 'https',
            host: 'speedrun.com',
            pathSegments: ['api', 'v1', 'games', srdcId]))
        .then((http.Response response) {
      try {
        Map<String, dynamic> game = JsonDecoder().convert(response.body)['data']
            as Map<String, dynamic>;
        if (game != null && game['assets']['cover-large']['uri'] != null) {
          return Uri.parse(game['assets']['cover-large']['uri'] as String);
        }
      } on FormatException catch (error) {
        stderr.writeln(error);
        return defaultCover;
      }

      // Fallback placeholder image
      return defaultCover;
    });

    return _cover;
  }

  Future<Widget> coverImage() async {
    return Hero(
        child: Image(
          fit: BoxFit.contain,
          image: CacheImage((await _cover).toString()),
        ),
        tag: id);
  }
}
