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
      id: json['id'] as String,
      srdcId: json['srdc_id'] as String,
      realtimeDuration: Duration(milliseconds: json['realtime_duration_ms'] as int),
      gametimeDuration: Duration(milliseconds: json['gametime_duration_ms'] as int),
      realtimeSumOfBest:
          Duration(milliseconds: json['realtime_sum_of_best_ms'] as int),
      gametimeSumOfBest:
          Duration(milliseconds: json['gametime_sum_of_best_ms'] as int ?? 0),
      defaultTiming:
          json['default_timing'] == 'game' ? Timing.game : Timing.real,
      program: json['program'] as String,
      attempts: json['attempts'] as int,
      parsedAt: DateTime.parse(json['parsed_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      game: Game.fromJson(json['game'] as Map<String, dynamic>),
      category: Category.fromJson(json['category'] as Map<String, dynamic>),
      //runners: json['runners'].map((runner) => Runner.fromJson(runner)), // TODO: Broken for some reason
      //segments: json['segments'].map((segment) => Segment.fromJson(segment)), // TODO: Broken for some reason
    );
  }
  static Map<Game, Iterable<Run>> byGame(Iterable<Run> runs) {
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
    String twoDigitMinutes = twoDigits(d.inMinutes.remainder(60) as int);
    String twoDigitSeconds = twoDigits(d.inSeconds.remainder(60) as int);

    return "$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds";
  }

  Uri uri() {
    return Uri.https('splits.io', id);
  }
}
