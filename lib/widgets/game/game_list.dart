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
          return GridView.count(
            childAspectRatio: 0.71,
            children: snapshot.data
                .map((Game game) => GameBoxArt(game: game))
                .toList(),
            crossAxisCount: 2,
          );
        } else if (snapshot.hasError) {
          // Without a forced delay, Flutter will hit an error due to Navigation
          // hijinks. See
          // https://github.com/flutter/flutter/issues/49779#issuecomment-630340754
          /*
          Future<void>.delayed(Duration(seconds: 1)).then((_) => Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (context) => LandingPage())));
              */
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
