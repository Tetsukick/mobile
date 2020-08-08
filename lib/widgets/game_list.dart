import 'package:flutter/material.dart';

import 'package:splitsio/models/game.dart';
import 'package:splitsio/models/runner.dart';
import 'package:splitsio/widgets/game_box_art.dart';

class GameList extends StatelessWidget {
  final Future<Runner> runner;
  final Future<String> accessToken;

  GameList({@required this.runner, @required this.accessToken});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: runner.then((runner) => runner.games(accessToken)),
      builder: (BuildContext context, AsyncSnapshot<List<Game>> snapshot) {
        if (snapshot.hasData) {
          return GridView.count(
            children: snapshot.data
                .map((Game game) => GameBoxArt(game: game))
                .toList(),
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            padding: EdgeInsets.all(10),
          );
        } else if (snapshot.hasError) {
          return Text(snapshot.error);
        }

        return Column(
          children: [
            Padding(padding: EdgeInsets.all(20)),
            CircularProgressIndicator(),
          ],
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
        );
      },
    );
  }
}
