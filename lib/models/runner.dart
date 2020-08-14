import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:splitsio/models/auth.dart';
import 'package:splitsio/models/game.dart';
import 'package:splitsio/models/run.dart';

class Runner {
  static Future<Runner> _me;

  final String id;
  final String twitchId;
  final String twitchName;
  final String displayName;
  final String name;
  final Uri avatar;
  final DateTime createdAt;
  final DateTime updatedAt;

  Future<List<Run>> _pbs;

  Runner(
      {this.id,
      this.twitchId,
      this.twitchName,
      this.displayName,
      this.name,
      this.avatar,
      this.createdAt,
      this.updatedAt});

  factory Runner.fromJson(BuildContext context, Map<String, dynamic> json) {
    Runner runner = Runner(
      id: json['id'] as String,
      twitchId: json['twitch_id'] as String,
      twitchName: json['twitch_name'] as String,
      displayName: json['display_name'] as String,
      name: json['name'] as String,
      avatar: Uri.parse(json['avatar'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
    runner.pbs(context); // Start fetching now
    return runner;
  }

  static Future<Runner> me(BuildContext context) async {
    if (Auth.demo) {
      return Runner(id: '38310', name: 'splitsio_ios_review');
    }

    if (_me != null) {
      return _me;
    }

    http.Response response;

    try {
      response = await Auth.http.get('https://splits.io/api/v4/runner');
    } catch (PlatformException) {
      throw UserCanceledException();
    }

    if (response.statusCode == 200) {
      _me = Future.value(Runner.fromJson(
          context,
          JsonDecoder().convert(response.body)['runner']
              as Map<String, dynamic>));
    } else {
      throw "Error: Can't retrieve user from Splits.io API. Got status ${response.statusCode}";
    }

    return _me;
  }

  Future<List<Game>> games(BuildContext context) async {
    final response =
        await http.get('https://splits.io/api/v4/runners/$name/games');

    List<Future<Uri>> futures = [];

    List<Game> games = [];
    if (response.statusCode == 200) {
      final List<dynamic> gamesJson =
          JsonDecoder().convert(response.body)['games'] as List<dynamic>;
      for (var i = 0; i < gamesJson.length; i++) {
        Game game = Game.fromJson(gamesJson[i] as Map<String, dynamic>);
        games.add(game);
        futures.add(game.cover());
      }
      // Precache images, otherwise the UX of images slowly popping in will be bad
      List<Uri> covers = await Future.wait<Uri>(futures);
      await Future.wait<void>(covers.map((cover) =>
          precacheImage(Image.network(cover.toString()).image, context)));
      return games;
    }

    throw 'Cannot retrieve games for user $id $name';
  }

  Future<List<Run>> pbs(BuildContext context) async {
    if (_pbs != null) {
      return _pbs;
    }

    _pbs = http
        .get('https://splits.io/api/v4/runners/$name/pbs')
        .then((http.Response response) {
      List<Run> runs = [];
      if (response.statusCode == 200) {
        final List<dynamic> runsJson =
            JsonDecoder().convert(response.body)['pbs'] as List<dynamic>;
        for (var i = 0; i < runsJson.length; i++) {
          runs.add(Run.fromJson(runsJson[i] as Map<String, dynamic>));
        }
        return runs;
      }

      throw 'Cannot retrieve PBs for user $id $name';
    });
    return _pbs;
  }

  Future<Iterable<Run>> pbsByGame(BuildContext context, Game game) async {
    return pbs(context).then((pbs) =>
        pbs.where((run) => run.game != null && run.game.id == game.id));
  }
}
