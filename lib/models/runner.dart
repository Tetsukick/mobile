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

  Future<Iterable<Run>> _pbs;
  Future<Iterable<Game>> _games;

  Runner(
      {this.id,
      this.twitchId,
      this.twitchName,
      this.displayName,
      this.name,
      this.avatar,
      this.createdAt,
      this.updatedAt});

  factory Runner.fromJson(Map<String, dynamic> json) {
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
    return runner;
  }

  static Future<Runner> me(BuildContext context) async {
    if (Auth.demo) {
      return Runner(id: '38310', name: 'splitsio_ios_review');
    }

    if (Auth.demoPaid) {
      return Runner(id: '38807', name: 'splitsio_ios_review_paid');
    }

    if (_me != null) {
      return _me;
    }

    try {
      _me = Auth.http
          .get('https://splits.io/api/v4/runner')
          .then((http.Response response) {
        if (response.statusCode == 200) {
          Map<String, dynamic> body =
              json.decode(response.body) as Map<String, dynamic>;
          _me = Future.value(
              Runner.fromJson(body['runner'] as Map<String, dynamic>));
          return _me;
        }

        throw "Error: Can't retrieve user from Splits.io API. Got status ${response.statusCode}";
      });
    } catch (PlatformException) {
      throw UserCanceledException();
    }

    return _me;
  }

  Future<Iterable<Game>> games(BuildContext context) async {
    if (_games != null) {
      return _games;
    }

    _games = http
        .get('https://splits.io/api/v4/runners/$name/games')
        .then((http.Response response) async {
      if (response.statusCode == 200) {
        final List<dynamic> gamesJson =
            JsonDecoder().convert(response.body)['games'] as List<dynamic>;

        final Iterable<Game> games = gamesJson
            .map((dynamic json) => Game.fromJson(json as Map<String, dynamic>));

        await Future.wait(games.map((game) {
          return precacheImage(
              Image.network(game.cover.toString()).image, context);
        }));

        return games;
      }

      throw 'Cannot retrieve games for user $id $name';
    });
    return _games;
  }

  Future<Iterable<Run>> pbs() async {
    if (_pbs != null) {
      return _pbs;
    }

    _pbs = http
        .get('https://splits.io/api/v4/runners/$name/pbs')
        .then<Iterable<Run>>((http.Response response) {
      if (response.statusCode == 200) {
        if (!(json.decode(response.body) is Map<String, dynamic>)) {
          throw 'pbs response body is not Map<String, dynamic>';
        }

        Map<String, dynamic> body =
            json.decode(response.body) as Map<String, dynamic>;

        if (!(body['pbs'] is List<dynamic>)) {
          throw 'pbs -> pbs body is not List<dynamic>';
        }
        List<dynamic> pbsJson = body['pbs'] as List<dynamic>;

        Iterable<Run> pbs = pbsJson.map((dynamic pbJson) {
          if (!(pbJson is Map<String, dynamic>)) {
            throw 'an entry of pbsJson was not Map<String, dynamic>';
          }
          return Run.fromJson(pbJson as Map<String, dynamic>);
        });

        return pbs;
      }

      throw 'Cannot retrieve PBs for user $id $name';
    });
    return _pbs;
  }

  Future<Iterable<Run>> pbsByGame(Game game) async {
    Iterable<Run> personalBests = await pbs();

    return personalBests.where((Run pb) {
      return pb.game != null && pb.game.id == game.id;
    });
  }
}
