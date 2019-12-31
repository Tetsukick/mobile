import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:splitsio/models/run.dart';

class Runner {
  final String id;
  final String twitchId;
  final String twitchName;
  final String displayName;
  final String name;
  final Uri avatar;
  final DateTime createdAt;
  final DateTime updatedAt;

  Runner({this.id, this.twitchId, this.twitchName, this.displayName, this.name, this.avatar, this.createdAt, this.updatedAt});

  factory Runner.fromJson(Map<String, dynamic> json) {
    return Runner(
      id: json['id'],
      twitchId: json['twitch_id'],
      twitchName: json['twitch_name'],
      displayName: json['display_name'],
      name: json['name'],
      avatar: Uri.parse(json['avatar']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  static Future<Runner> byToken(String accessToken) async {
    final response = await http.get('https://splits.io/api/v4/runner', headers: {
      "Authorization": "Bearer $accessToken",
    });

    if (response.statusCode == 200) {
      return Runner.fromJson(JsonDecoder().convert(response.body)['runner']);
    }

    throw 'Cannot retrieve logged-in user from API. Maybe you do not have any runs?';
  }

  Future<List<Run>> pbs(String accessToken) {
    return Run.fetchPbs(accessToken: accessToken, runner: this);
  }
}
