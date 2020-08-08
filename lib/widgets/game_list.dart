import 'package:flutter/material.dart';

import 'package:splitsio/models/game.dart';
import 'package:splitsio/models/runner.dart';
import 'package:splitsio/widgets/game_box_art.dart';

class GameList extends StatelessWidget {
  final String token;
  final Future<Runner> runner;

  GameList({@required this.token, @required this.runner});

  @override
  Widget build(BuildContext context) {
    // Start loading PBs early
    runner.then((Runner runner) => runner.pbs());

    return FutureBuilder(
      future: runner.then((runner) => runner.games()),
      builder: (BuildContext context, AsyncSnapshot<List<Game>> snapshot) {
        if (snapshot.hasData) {
          return GridView.count(
            children: snapshot.data
                .map((Game game) => GameBoxArt(game: game, token: token))
                .toList(),
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            padding: EdgeInsets.all(10),
          );
        } else if (snapshot.hasError) {
          return Text(snapshot.error as String);
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
