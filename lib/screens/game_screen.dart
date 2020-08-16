import 'package:flutter/material.dart';

import 'package:splitsio/models/game.dart';
import 'package:splitsio/models/run.dart';
import 'package:splitsio/models/runner.dart';
import 'package:splitsio/widgets/game/game_box_art_background.dart';
import 'package:splitsio/widgets/game/game_tab_controller.dart';
import 'package:splitsio/widgets/shared/loading_spinner.dart';

class GameScreen extends StatelessWidget {
  final Game game;
  final Future<Runner> runner;

  GameScreen({@required this.game, @required this.runner});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Iterable<Run>>(
        future: runner.then<Iterable<Run>>((runner) {
      return runner.pbsByGame(game);
    }), builder: (BuildContext context, AsyncSnapshot<Iterable<Run>> snapshot) {
      if (snapshot.hasData) {
        return GameTabController(
            game: game, runs: snapshot.data, cover: game.cover);
      } else if (snapshot.hasError) {
        throw snapshot.error;
      }

      return DefaultTabController(
          length: 1,
          child: Scaffold(
            appBar: AppBar(
                bottom: TabBar(tabs: [Tab(text: 'Loading categories')]),
                title: Text(game.name)),
            body: GameBoxArtBackground(game: game, child: LoadingSpinner()),
          ));
    });
  }
}
