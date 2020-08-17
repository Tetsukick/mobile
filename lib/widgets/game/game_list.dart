import 'package:flutter/material.dart';

import 'package:splitsio/models/game.dart';
import 'package:splitsio/models/runner.dart';
import 'package:splitsio/widgets/game/game_box_art.dart';

class GameList extends StatelessWidget {
  final Future<Runner> runner;

  GameList({@required this.runner});

  @override
  Widget build(BuildContext context) {
    // Start loading PBs early
    //runner.then((Runner runner) => runner.pbs());

    return FutureBuilder(
      future: runner.then((runner) => runner.games(context)),
      builder: (BuildContext context, AsyncSnapshot<Iterable<Game>> snapshot) {
        if (snapshot.hasData) {
          return GridView.extent(
            childAspectRatio: .71,
            children: snapshot.data
                .map((Game game) => GameBoxArt(game: game))
                .toList(),
            crossAxisSpacing: 0,
            mainAxisSpacing: 0,
            maxCrossAxisExtent: 300,
          );
        } else if (snapshot.hasError) {
          throw snapshot.error;
        }

        return Center(
            child: Column(
          children: [
            Padding(padding: EdgeInsets.all(20)),
            CircularProgressIndicator(),
          ],
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
        ));
      },
    );
  }
}
