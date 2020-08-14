import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:splitsio/models/game.dart';
import 'package:splitsio/models/runner.dart';
import 'package:splitsio/widgets/game/run_list.dart';

class GameScreen extends StatelessWidget {
  final Game game;
  final Future<Runner> runner;

  // cover can technically be retrieved from the game, but only as a future. By
  // allowing consumers to pass it in directly, we can do Hero animations that
  // wouldn't be possible with a Future<Uri>.
  final Uri cover;

  GameScreen(
      {@required this.game, @required this.cover, @required this.runner});

  @override
  Widget build(BuildContext context) {
    return PageView(children: [
      Scaffold(
        appBar: AppBar(title: Text("${game.name} PBs")),
        body: Stack(children: [
          Hero(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.1), BlendMode.dstATop),
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      cover.toString(),
                    ),
                  ),
                ),
              ),
            ),
            tag: game.id,
          ),
          BackdropFilter(
              child: RunList(game: game, runner: runner),
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5)),
        ]),
      )
    ]);
  }
}
