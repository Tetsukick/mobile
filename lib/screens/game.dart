import 'package:flutter/material.dart';

import 'package:splitsio/models/game.dart';
import 'package:splitsio/models/run.dart';
import 'package:splitsio/models/runner.dart';
import 'package:splitsio/widgets/game_box_art_background.dart';
import 'package:splitsio/widgets/game_tab_controller.dart';
import 'package:splitsio/widgets/loading_spinner.dart';

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
    return FutureBuilder<Iterable<Run>>(
        future: runner.then((runner) => runner.pbsByGame(context, game)),
        builder: (BuildContext context, AsyncSnapshot<Iterable<Run>> snapshot) {
          if (snapshot.hasData) {
            return GameTabController(
                game: game, runs: snapshot.data, cover: cover);
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          return DefaultTabController(
              length: 1,
              child: Scaffold(
                appBar: AppBar(
                    bottom: TabBar(tabs: [Tab(text: 'Loading categories')]),
                    title: Text(game.name)),
                body: GameBoxArtBackground(
                    cover: cover, game: game, child: LoadingSpinner()),
              ));
        });
  }
}
