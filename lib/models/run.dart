import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:splitsio/models/category.dart';
import 'package:splitsio/models/game.dart';
import 'package:splitsio/models/runner.dart';
import 'package:splitsio/models/segment.dart';

enum Timing {
  real,
  game,
}

class Run {
  final String id;
  final String srdcId;
  final Duration realtimeDuration;
  final Duration gametimeDuration;
  final Duration realtimeSumOfBest;
  final Duration gametimeSumOfBest;
  final Timing defaultTiming;
  final String program;
  final int attempts;
  final DateTime parsedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Game game;
  final Category category;
  final List<Runner> runners;
  final List<Segment> segments;

  Run({
    this.id,
    this.srdcId,
    this.realtimeDuration,
    this.gametimeDuration,
    this.realtimeSumOfBest,
    this.gametimeSumOfBest,
    this.defaultTiming,
    this.program,
    this.attempts,
    this.parsedAt,
    this.createdAt,
    this.updatedAt,
    this.game,
    this.category,
    this.runners,
    this.segments,
  });

  factory Run.fromJson(Map<String, dynamic> json) {
    return Run(
      id: json['id'],
      srdcId: json['srdc_id'],
      realtimeDuration: Duration(milliseconds: json['realtime_duration_ms']),
      gametimeDuration: Duration(milliseconds: json['gametime_duration_ms']),
      realtimeSumOfBest:
          Duration(milliseconds: json['realtime_sum_of_best_ms']),
      gametimeSumOfBest:
          Duration(milliseconds: json['gametime_sum_of_best_ms']),
      defaultTiming:
          json['default_timing'] == 'game' ? Timing.game : Timing.real,
      program: json['program'],
      attempts: json['attempts'],
      parsedAt: DateTime.parse(json['parsed_at']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      game: Game.fromJson(json['game']),
      category: Category.fromJson(json['category']),
      //runners: json['runners'].map((runner) => Runner.fromJson(runner)), // TODO: Broken for some reason
      //segments: json['segments'].map((segment) => Segment.fromJson(segment)), // TODO: Broken for some reason
    );
  }

  static Future<List<Run>> fetchPbs({String accessToken, Runner runner}) async {
    final response = await http
        .get('https://splits.io/api/v4/runners/${runner.name}/pbs', headers: {
      "Authorization": "Bearer $accessToken",
    });

    List<Run> runs = [];
    if (response.statusCode == 200) {
      final runsJson = JsonDecoder().convert(response.body)['pbs'];
      for (var i = 0; i < runsJson.length; i++) {
        runs.add(Run.fromJson(runsJson[i]));
      }
      return runs;
    }

    throw 'Cannot retrieve runs for user';
  }

  static Map<Game, List<Run>> byGame(List<Run> runs) {
    Map<Game, List<Run>> m = Map<Game, List<Run>>();
    runs.forEach((run) {
      m.putIfAbsent(run.game, () => List<Run>());
      m[run.game].add(run);
    });
    return m;
  }

  String duration() {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    Duration d;
    if (defaultTiming == Timing.game) {
      d = gametimeDuration;
    } else {
      d = realtimeDuration;
    }

    String twoDigitHours = twoDigits(d.inHours);
    String twoDigitMinutes = twoDigits(d.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(d.inSeconds.remainder(60));

    return "$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds";
  }
}
