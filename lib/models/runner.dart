import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:splitsio/models/auth.dart';
import 'package:splitsio/models/game.dart';
import 'package:splitsio/models/run.dart';

class Runner {
  static final storage = new FlutterSecureStorage();
  static final _byToken = new Map<String, Runner>();

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
    // Might as well start fetching the cover now, as we know we'll need it
    runner.pbs();
    return runner;
  }

  static Future<Runner> byToken(String accessToken) async {
    if (_byToken[accessToken] != null) {
      return _byToken[accessToken];
    }

    final response =
        await http.get('https://splits.io/api/v4/runner', headers: {
      "Authorization": "Bearer $accessToken",
    });

    if (response.statusCode == 200) {
      Runner runner = Runner.fromJson(JsonDecoder()
          .convert(response.body)['runner'] as Map<String, dynamic>);
      _byToken[accessToken] = runner;
      return runner;
    }
    throw "Error: Can't retrieve user from Splits.io API. Got status ${response.statusCode}";
  }

  Future<List<Game>> games() async {
    final uri = Uri(
        scheme: 'https',
        host: 'splits.io',
        pathSegments: ['api', 'v4', 'runners', this.name, 'games']);
    final response = await http.get(uri, headers: {
      "Authorization": "Bearer ${await Auth.token()}",
    });

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

    _pbs = http.get('https://splits.io/api/v4/runners/${name}/pbs', headers: {
      "Authorization": "Bearer ${await Auth.token()}",
    }).then((http.Response response) {
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
    return pbs().then((pbs) => pbs.where((run) => run.game.id == game.id));
  }
}
