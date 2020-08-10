import 'dart:async';
import 'dart:convert';
import 'dart:io';

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
    runner.pbs(); // Start fetching now
    return runner;
  }

  static Future<Runner> me() async {
    if (Auth.demo) {
      return Runner(id: '38310', name: 'splitsio_ios_review');
    }

    if (_me != null) {
      return _me;
    }

    try {
      _me = Auth.http
          .get('https://splits.io/api/v4/runner')
          .then((http.Response response) {
        if (response.statusCode == 200) {
          return Runner.fromJson(JsonDecoder().convert(response.body)['runner']
              as Map<String, dynamic>);
        }

        throw "Error: Can't retrieve user from Splits.io API. Got status ${response.statusCode}";
      });
    } catch (PlatformException) {
      stderr.write("User declined to sign in");
    }

    return _me;
  }

  Future<List<Game>> games() async {
    final response =
        await http.get('https://splits.io/api/v4/runners/$name/games');

    List<Game> games = [];
    if (response.statusCode == 200) {
      final List<dynamic> gamesJson =
          JsonDecoder().convert(response.body)['games'] as List<dynamic>;
      for (var i = 0; i < gamesJson.length; i++) {
        games.add(Game.fromJson(gamesJson[i] as Map<String, dynamic>));
      }
      return games;
    }

    throw 'Cannot retrieve games for user $id $name';
  }

  Future<List<Run>> pbs() async {
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

  Future<Iterable<Run>> pbsByGame(Game game) async {
    return pbs().then((pbs) =>
        pbs.where((run) => run.game != null && run.game.id == game.id));
  }
}
